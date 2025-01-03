//
//  HomeViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/28/24.
//

import UIKit

enum ViewStatus {
    case error
    case loading
    case loaded
}

final class HomeViewModel: ObservableObject {
    @Published var viewStatus: ViewStatus = .loading
    var recommendQuestTitle: String {
        if let nickname = UserService.shared.currentUser?.nickname {
            return nickname + "님을 위한 추천 퀘스트"
        } else {
            return "추천 퀘스트"
        }
    }
    @Published var userRankList: [Rank] = [
        .init(xpType: "", xpPoint: 1220, customerId: "", nickname: "유저ABC"),
        .init(xpType: "", xpPoint: 20, customerId: "", nickname: "유저123456"),
        .init(xpType: "",xpPoint: 700, customerId: "", nickname: "일상999"),
        .init(xpType: "", xpPoint: 50, customerId: "", nickname: "유저939393"),
        .init(xpType: "", xpPoint: 20, customerId: "", nickname: "일상0213493")
    ] // 10개
    @Published var largestRewardQuestList: [XpStat: [QuestViewModelItem]] = [:] // 3*5개
    @Published var recommendQuestList: [QuestViewModelItem] = [] //QuestViewModelItem.mockQuestList // 10개
    @Published var popularQuestList: [QuestViewModelItem] = QuestViewModelItem.mockQuestList // 4n개
    
    @Published var selectedXpStat: XpStat = .strength

    @Published var showQuestSheet: Bool = false
    @Published var selectedQuest: QuestViewModelItem = .mockData
    @Published var selectedPopularTabIndex: Int = 0
    let popularChunkSize: Int = 4
    
    @Published var showSubmitRouterView: Bool = false {
        didSet {
            // TODO: 해당 섹션 데이터만 다시 불러오도록 수정
            if showSubmitRouterView == false {
                Task {
                    await loadInitialData()
                }
            }
        }
    }
    
    private let questNetwork: QuestNetwork
    
    init(questNetwork: QuestNetwork) {
        self.questNetwork = questNetwork
        Task {
            await loadInitialData()
        }
    }
    
    func loadInitialData() async {
        await changeViewStatus(.loading)
        await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                do {
                    try await self.loadPopularQuestList()
                } catch {
                    Log("Failed to load popular quests: \(error.localizedDescription)")
                }
            }
            group.addTask {
                do {
                    try await self.loadRecommendQuestList()
                } catch {
                    Log("Failed to load recommend quests: \(error.localizedDescription)")
                }
            }
            group.addTask {
                do {
                    try await self.loadLargeRewardQuestList()
                } catch {
                    Log("Failed to load large reward quests: \(error.localizedDescription)")
                }
            }
        }
        await changeViewStatus(.loaded)
    }
    
    @MainActor
    func loadPopularQuestList() async throws {
        let res = await questNetwork.getPopularQuest()
        
        switch res {
        case .success(let response):
            self.popularQuestList = response.data.map { QuestViewModelItem(quest: $0) }
            await cacheImages(for: &popularQuestList, getMainImage: true)
        case .failure(let error):
            throw error
        }
    }
    
    @MainActor
    func loadRecommendQuestList() async throws {
        let res = await questNetwork.getUncompletedTotalQuest()
        
        switch res {
        case .success(let response):
            self.recommendQuestList = response.data.map { QuestViewModelItem(quest: $0) }
            await cacheImages(for: &recommendQuestList, getWriterImage: true)
        case .failure(let error):
            throw error
        }
    }
    
    @MainActor
    func loadLargeRewardQuestList() async throws {
        let res = await questNetwork.getLargeRewardQuestsByAllXpStats()
        
        switch res {
        case .success(let questByStat):
            for (stat, quests) in questByStat {
                self.largestRewardQuestList[stat] = quests.map { QuestViewModelItem(quest: $0) }
                await cacheImages(for: &largestRewardQuestList[stat, default: []], getWriterImage: true)
            }
        case .failure(let error):
            throw error
        }
    }
    
    /// getWriterImage, getMainImage 중 가져올 이미지 타입을 true로 설정
    func cacheImages(for quests: inout [QuestViewModelItem], getWriterImage: Bool = false, getMainImage: Bool = false) async {
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, quest) in quests.enumerated() {
                group.addTask {
                    let imageId: String
                    if getWriterImage {
                        guard let writerImageId = quest.imageId else { return (index, nil) }
                        imageId = writerImageId
                    } else if getMainImage {
                        guard let mainImageId = quest.mainImageId else { return (index, nil) }
                        imageId = mainImageId
                    } else {
                        fatalError("getWriterImage, getMainImage 중 하나의 값은 true이어야 함")
                    }
                    let image = await ImageCacheService.shared.loadImageAsync(imageId: imageId)
                    return (index, image)
                }
            }
            
            for await (index, image) in group {
                if let image = image {
                    quests[index].image = image
                }
            }
        }
    }
    
    @MainActor
    func changeViewStatus(_ viewStatus: ViewStatus) {
        self.viewStatus = viewStatus
    }
    
    func onQuestTapped(quest: QuestViewModelItem) {
        selectedQuest = quest
        showQuestSheet.toggle()
    }
    
    func onQuestApprovalTapped() {
        showSubmitRouterView.toggle()
        showQuestSheet.toggle()
    }
}
