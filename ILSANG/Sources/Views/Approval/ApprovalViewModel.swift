//
//  ApprovalViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/1/24.
//

import SwiftUI
/*
✅ 이모지 에셋 변경
✅ 이모지 불러오기(idx 0, 1..<)
✅ 이모지 활성&비활성
❌ 이모지 카운트 +-
✅ 공유하기 & 신고하기 UI 추가
✅ 공유하기 & 신고하기 기능 추가
✅ 페이지네이션
✅ 리프레시
*/

final class ApprovalViewModel: ObservableObject {
    enum ViewStatus {
        case error
        case loading
        case loaded
    }
    
    @Published var viewStatus: ViewStatus = .loading
    @Published var itemList: [ApprovalViewModelItem] = []
    
    @Published var showReportAlert = false
    @Published var selectedChallenge: ApprovalViewModelItem?
    
    lazy var paginationManager = PaginationManager<ApprovalViewModelItem>(
        size: 10,
        threshold: 3,
        loadPage: { [weak self] page in
            guard let self = self else { return ([], 0) }
            return await self.getChallengesWithImage(page: page)
        }
    )
    
    private let emojiNetwork: EmojiNetwork
    private let challengeNetwork: ChallengeNetwork
    
    var lastUpdatedEmojiIdx: Int = 0
    
    init(emojiNetwork: EmojiNetwork, challengeNetwork: ChallengeNetwork) {
        self.emojiNetwork = emojiNetwork
        self.challengeNetwork = challengeNetwork
    }
    
    @MainActor
    func loadInitialData() async {
        changeViewStatus(.loading)
        await self.paginationManager.loadData(isRefreshing: true)
        
        // 인덱스가 0인 도전내역의 이모지 불러오기
        if let _ = itemList.first {
            await getEmoji(idx: 0)
            lastUpdatedEmojiIdx = 0
        }
        
        changeViewStatus(.loaded)
        
        // 인덱스가 1 이상인 도전내역의 이모지 불러오기
        await fetchEmojis()
    }
    
    @MainActor
    func loadMoreData() async {
        guard paginationManager.canLoadMoreData() else { return }
        await paginationManager.loadData(isRefreshing: false)
        await fetchEmojis()
    }
        
    @MainActor
    func getChallengesWithImage(page: Int) async -> ([ApprovalViewModelItem], Int) {
        let getChallengeResult = await getRandomChallenges(page: page, size: paginationManager.size)
        var challenges = getChallengeResult.data
        
        // 중복된 id 제거
        var seenIDs = Set<String>()
        challenges = challenges.filter { challenge in
            if seenIDs.contains(challenge.id) {
                return false
            } else {
                seenIDs.insert(challenge.id)
                return true
            }
        }
        
        if page == 0 {
            itemList = challenges
        } else {
            itemList += challenges
        }
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, challenge) in challenges.enumerated() {
                group.addTask {
                    let image = await ImageCacheService.shared.loadImageAsync(imageId: challenge.imageId)
                    return (index, image)
                }
            }
            
            for await (index, image) in group {
                if let image = image {
                    if page == 0 {
                        itemList[index].image = image
                    } else {
                        itemList[itemList.count - challenges.count + index].image = image
                    }
                }
            }
        }
        
        return (itemList, getChallengeResult.total)
    }
    
    private func getRandomChallenges(page: Int, size: Int) async -> (data: [ApprovalViewModelItem], total: Int) {
        let res = await challengeNetwork.getRandomChallenges(page: page, size: size)
        switch res {
        case .success(let response):
            return (response.data.map { ApprovalViewModelItem.init(challenge: $0) }, response.total)
        case .failure:
            return ([], 0)
        }
    }
    
    private func fetchEmojis() async {
        let remainingIndexes = lastUpdatedEmojiIdx..<itemList.count
        
        await withTaskGroup(of: Void.self) { group in
            for idx in remainingIndexes {
                if itemList[idx].emoji == nil { // 불러온 적 없는 이모지에 대해서만 네트워크 요청
                    group.addTask {
                        await self.getEmoji(idx: idx)
                    }
                }
            }
        }
        lastUpdatedEmojiIdx = itemList.count - 1
    }
    
    func onLike(for idx: Int) {
        Task {
            await updateEmojiWithPrev(emojiType: .like, idx: idx)
        }
    }
    
    func onHate(for idx: Int) {
        Task {
            await updateEmojiWithPrev(emojiType: .hate, idx: idx)
        }
    }
    
    /// 업데이트할 이모지 타입에 따라 이전 이모지 상태의 반대로 서버에 업데이트를 요청하고,
    /// 서버 업데이트가 성공하면 로컬 상태를 업데이트합니다.
    /// - Parameter emojiType: 업데이트할 이모지의 유형 (like 또는 hate).
    @MainActor func updateEmojiWithPrev(emojiType: EmojiType, idx: Int) async {
        guard let prevEmoji = self.itemList[idx].emoji else { return }
        
        let wasPrevEmojiActive: Bool
        var emojiId: String? = nil

        switch emojiType {
        case .like:
            wasPrevEmojiActive = prevEmoji.isLike
            if let prevLikeId = prevEmoji.likeId {
                emojiId = prevLikeId
            }
        case .hate:
            wasPrevEmojiActive = prevEmoji.isHate
            if let prevHateId = prevEmoji.hateId {
                emojiId = prevHateId
            }
        }
        
        let challengeId = itemList[idx].id
        let isServerUpdateSuccessful = await updateEmojiStatus(challengeId: challengeId, emojiType: emojiType, emojiId: emojiId, prevEmojiActive: wasPrevEmojiActive, idx: idx)
        
        if isServerUpdateSuccessful {
            switch emojiType {
            case .like:
                self.itemList[idx].emoji?.isLike.toggle()
                if let emoji = self.itemList[idx].emoji, !emoji.isLike {
                    self.itemList[idx].emoji?.likeId = nil
                }
            case .hate:
                self.itemList[idx].emoji?.isHate.toggle()
                if let emoji = self.itemList[idx].emoji, !emoji.isHate {
                    self.itemList[idx].emoji?.hateId = nil
                }
            }
        }
    }
    
    /// 이모지 등록하면 emojiid받아와서 현재 Emoji에 넣어줌
    @MainActor
    private func updateEmojiStatus(challengeId: String, emojiType: EmojiType, emojiId: String?, prevEmojiActive: Bool, idx: Int) async -> Bool {
        var updateSucceeded = false
        if prevEmojiActive {
            guard let emojiId = emojiId else { return false }
            updateSucceeded = await emojiNetwork.deleteEmoji(emojiId: emojiId)
        } else {
            let res = await emojiNetwork.postEmoji(challengeId: challengeId, emojiType: emojiType)
            switch res {
            case .success(let emojiId):
                switch emojiType {
                case .like:
                    self.itemList[idx].emoji?.likeId = emojiId
                case .hate:
                    self.itemList[idx].emoji?.hateId = emojiId
                }
                updateSucceeded = true
            case .failure:
                print(idx, challengeId, "이모지 업데이트 상태 포스트 실패")
                updateSucceeded = false
            }
        }
        return updateSucceeded
    }
    
    @MainActor
    func getEmoji(idx: Int) async {
        let challengeId = self.itemList[idx].id
        let getEmojiResult = await emojiNetwork.getEmoji(challengeId: challengeId)
        
        switch getEmojiResult {
        case .success(let response):
            self.itemList[idx].emoji = response.data
        case .failure:
            self.itemList[idx].emoji = nil
        }
    }
    
    func confirmReport() async {
        guard let selectedChallenge = selectedChallenge else { return }
        await reportChallenge()
        showReportAlert = false
    }
    
    func dismissReportAlert() {
        showReportAlert = false
    }
    
    private func reportChallenge() async {
        guard let challengeId = self.selectedChallenge?.id else { return }
        let result = await challengeNetwork.patchChallenge(challengeId: challengeId)
        switch result {
        case .success:
            await loadInitialData()
        case .failure(let err):
            Log("챌린지 신고 실패 \(challengeId) \(err.localizedDescription)")
        }
    }
    
    @MainActor
    func changeViewStatus(_ viewStatus: ViewStatus) {
        self.viewStatus = viewStatus
    }
}

struct ApprovalViewModelItem: Identifiable {
    let id: String
    let title: String
    var image: UIImage?
    var imageId: String
    var nickname: String
    var time: String
    var likeCnt: Int
    var hateCnt: Int
    var emoji: Emoji?
    
    init(
        id: String = UUID().uuidString,
        title: String,
        image: UIImage? = nil,
        imageId: String,
        nickname: String,
        time: String,
        likeCnt: Int,
        hateCnt: Int,
        emoji: Emoji?
    ) {
        self.id = id
        self.title = title
        self.image = image
        self.imageId = imageId
        self.nickname = nickname
        self.time = time
        self.likeCnt = likeCnt
        self.hateCnt = hateCnt
        self.emoji = emoji
    }
    
    init(challenge: Challenge) {
        self.id = challenge.challengeId
        self.title = challenge.missionTitle ?? ""
        self.image = nil
        self.imageId = challenge.receiptImageId
        // TODO: nickname 옵셔널 해제
        self.nickname = challenge.userNickName ?? "일상"
        self.time = challenge.createdAt.timeAgoSinceDate()
        self.likeCnt = challenge.likeCnt
        self.hateCnt = challenge.hateCnt
        self.emoji = nil // Emoji(isLike: false, isHate: false) // TODO: 수정
    }
    
    static var failedData = ApprovalViewModelItem(
        title: "불러올 수 없습니다",
        imageId: "",
        nickname: "",
        time: "",
        likeCnt: 0,
        hateCnt: 0,
        emoji: nil
    )
    
    static var mockDataList = [
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", nickname: "일상1", time: "3시간 전", likeCnt: 0, hateCnt: 0, emoji: Emoji(isLike: false, isHate: false)),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", nickname: "일상2", time: "1시간 전", likeCnt: 0, hateCnt: 0, emoji: Emoji(isLike: false, isHate: false)),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", nickname: "일상3", time: "2시간 전", likeCnt: 0, hateCnt: 0, emoji: Emoji(isLike: false, isHate: false)),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", nickname: "일상4", time: "2시간 전", likeCnt: 0, hateCnt: 0, emoji: Emoji(isLike: false, isHate: false))
    ]
}
