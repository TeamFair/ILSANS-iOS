//
//  ApprovalViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/1/24.
//

import SwiftUI

final class ApprovalViewModel: ObservableObject {
    // TODO: 페이지네이션 시 ViewStatus 고려 필요
    enum ViewStatus {
        case error
        case loading
        case loaded
    }
    
    @Published var viewStatus: ViewStatus = .loading
    @Published var itemList: [ApprovalViewModelItem] = []
    @Published var currentIdx = 0 {
        didSet {
            Task {
                if !itemList.isEmpty {
                    await getEmoji(challengeId: itemList[currentIdx].id)
                }
            }
        }
    }
    @Published var isScrolling = false
    @Published var emoji: Emoji?
    
    private let imageNetwork: ImageNetwork
    private let emojiNetwork: EmojiNetwork
    private let challengeNetwork: ChallengeNetwork
    
    init(imageNetwork: ImageNetwork, emojiNetwork: EmojiNetwork, challengeNetwork: ChallengeNetwork) {
        self.imageNetwork = imageNetwork
        self.emojiNetwork = emojiNetwork
        self.challengeNetwork = challengeNetwork
    }
    
    func getData() async {
        await changeViewStatus(.loading)
        await getChallengesWithImage(page: 0)
        // TODO: 현재 인덱스의 challengeId로 수정
        await getEmoji(challengeId: "86efe988-2acc-4add-99a5-06e414d04dfa")
        await changeViewStatus(.loaded)
    }
    
    @MainActor
    func changeViewStatus(_ viewStatus: ViewStatus) {
        self.viewStatus = viewStatus
    }
    
    @MainActor
    func getChallengesWithImage(page: Int) async {
        let challenges = await getRandomChallenges(page: page)
        
        if page == 0 {
            itemList = challenges
        } else {
            itemList += challenges
        }
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, challenge) in challenges.enumerated() {
                group.addTask {
                    let image = await self.getImage(imageId: challenge.imageId)
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
    }
    
    private func getRandomChallenges(page: Int) async -> [ApprovalViewModelItem] {
        let res = await challengeNetwork.getRandomChallenges(page: page)
        switch res {
        case .success(let success):
            return success.content.map { ApprovalViewModelItem.init(challenge: $0) }
        case .failure:
            return []
        }
    }
    
    private func getImage(imageId: String) async -> UIImage? {
        let res = await imageNetwork.getImage(imageId: imageId)
        switch res {
        case .success(let uiImage):
            return uiImage
        case .failure:
            return nil
        }
    }
    
    /// 업데이트할 이모지 타입에 따라 이전 이모지 상태의 반대로 서버에 업데이트를 요청하고,
    /// 서버 업데이트가 성공하면 로컬 상태를 업데이트합니다.
    /// - Parameter emojiType: 업데이트할 이모지의 유형 (like 또는 hate).
    func updateEmojiWithPrev(emojiType: EmojiType) async {
        guard let prevEmoji = self.emoji else { return }
        
        let wasPrevEmojiActive: Bool
        switch emojiType {
        case .like:
            wasPrevEmojiActive = prevEmoji.isLike
        case .hate:
            wasPrevEmojiActive = prevEmoji.isHate
        }
        
        // TODO: 현재 인덱스의 challengeId로 수정
        let challengeId = "86efe988-2acc-4add-99a5-06e414d04dfa"
        
        let isServerUpdateSuccessful = await updateEmojiStatus(challengeId: challengeId, emojiType: emojiType, prevEmojiActive: wasPrevEmojiActive)
        
        if isServerUpdateSuccessful {
            switch emojiType {
            case .like:
                self.emoji?.isLike.toggle()
            case .hate:
                self.emoji?.isHate.toggle()
            }
        }
    }
    
    private func updateEmojiStatus(challengeId: String, emojiType: EmojiType, prevEmojiActive: Bool) async -> Bool {
        var updateSucceeded = false
        if prevEmojiActive {
            updateSucceeded = await emojiNetwork.deleteEmoji(emojiId: "emj000")
        } else {
            updateSucceeded = await emojiNetwork.postEmoji(challengeId: challengeId, emojiType: emojiType)
        }
        return updateSucceeded
    }
    
    @MainActor
    func getEmoji(challengeId: String) async {
        let getEmojiResult = await emojiNetwork.getEmoji(challengeId: challengeId)
        switch getEmojiResult {
        case .success(let model):
            self.emoji = model.data
        case .failure:
            self.emoji = nil
        }
    }
    
    func handleDragChange(_ value: DragGesture.Value) {
        if value.translation.height < 0 && currentIdx != itemList.count-1 {
            isScrolling = true
            
            itemList[currentIdx].offset = value.translation.height
            
            /// 다음 이미지 y축 올리는 효과
            if currentIdx + 1 != itemList.count-1 {
                itemList[currentIdx + 1].offset = -12
            }
        }
    }
    
    func handleDragEnd(_ value: DragGesture.Value, _ viewHeight: CGFloat) {
        if value.translation.height < 0 {  /// 위로 스크롤
            if currentIdx != itemList.count-1 {
                itemList[currentIdx].offset = -viewHeight
                if currentIdx + 1 != itemList.count-1 {
                    itemList[currentIdx + 1].offset = 0
                }
                currentIdx += 1
            } else {
                itemList[currentIdx].offset = 0
            }
        } else {  /// 아래로 스크롤
            if currentIdx > 0 {
                if value.translation.height > 0 {
                    itemList[currentIdx - 1].offset = 0
                    currentIdx -= 1
                } else {
                    itemList[currentIdx - 1].offset = -viewHeight
                }
            }
        }
        isScrolling = false
    }
    
    func calculateOpacity(itemIndex: Int) -> CGFloat {
        switch abs(itemIndex - currentIdx) {
        case 0:
            return isScrolling ? 0.5 : 1 /// 활성화된 아이템이 >> 화면 스크롤 중이면 0.5, 스크롤 중이 아니면 1
        case 1:
            return isScrolling ? 1 : 0.5  /// 다음에 보여질 아이템이 >> 화면 스크롤 중이면 1, 스크롤 중이 아니면 0.5
        case 2:
            return 0.2
        default:
            return 0
        }
    }
}

struct ApprovalViewModelItem: Identifiable {
    let id: String
    var title: String
    var image: UIImage?
    var imageId: String
    var offset: CGFloat
    var nickname: String
    var time: String
    
    init(id: String = UUID().uuidString, title: String, image: UIImage? = nil, imageId: String, offset: CGFloat, nickname: String, time: String) {
        self.id = id
        self.title = title
        self.image = image
        self.imageId = imageId
        self.offset = offset
        self.nickname = nickname
        self.time = time
    }
    
    // TODO: 백 수정 시 time 계산 적용
    init(challenge: Challenge) {
        self.id = challenge.challengeId
        self.title = challenge.quest.missions.first?.title ?? ""
        self.image = nil
        self.imageId = challenge.receiptImageId
        self.offset = 0
        self.nickname = challenge.userNickName
        self.time = "3시간 전"
    }
    
    static var mockData = [
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상1", time: "3시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상2", time: "1시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상3", time: "2시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상4", time: "2시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상5", time: "1시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상6", time: "3시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상7", time: "2시간 전"),
        ApprovalViewModelItem(title: "바닐라라떼마시기", imageId: "IMRE2024061314275774", offset: 0, nickname: "일상8", time: "3시간 전")
    ]
}
