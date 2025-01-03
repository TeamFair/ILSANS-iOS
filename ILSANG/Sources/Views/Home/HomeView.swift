//
//  HomeView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/21/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel(questNetwork: QuestNetwork())
    @EnvironmentObject var sharedState: SharedState
    @Environment(\.redactionReasons) var redactionReasons
    
    private let gridItem = [GridItem(), GridItem()]
    private let horizontalPadding: CGFloat = 20
    private let sectionSpacing: CGFloat = 36
    
    var body: some View {
        VStack(spacing: 23) {
            ScrollView {
                header
                content
            }
            .refreshable {
                await vm.loadInitialData()
            }
        }
        .disabled(vm.viewStatus == .loading)
        .background(Color.background)
        .sheet(isPresented: $vm.showQuestSheet) {
            QuestDetailView(quest: vm.selectedQuest) {
                vm.onQuestApprovalTapped()
            }
            .presentationDetents([.height(464)])
            .presentationDragIndicator(.hidden)
        }
        .fullScreenCover(isPresented: $vm.showSubmitRouterView) {
            SubmitRouterView(selectedQuest: vm.selectedQuest)
                .interactiveDismissDisabled()
        }
    }
    
    private var header: some View {
        HStack(alignment: .bottom) {
            Image(.logoWithAlpha)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                sharedState.selectedTab = .mypage /// 마이 탭으로 이동
            } label: {
                Image(.profileCircle)
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    private var content: some View {
        LazyVStack(spacing: sectionSpacing) {
            // TODO: 메인 배너 섹션
            popularQuestSection
            recommendQuestSection
            largestRewardQuestSection
            userRankingSection
        }
        .redacted(reason: vm.viewStatus == .loading ? .placeholder : [])
        .foregroundStyle(redactionReasons.contains(.placeholder) ? .clear: Color.gray500)
    }
    
    private var popularQuestSection: some View {
        TitleWithContentView(
            title: "이번 달 인기 퀘스트 모음",
            content:
                VStack(spacing: 26) {
                    TabView(selection: $vm.selectedPopularTabIndex) {
                        ForEach(Array(vm.popularQuestList.chunks(of: vm.popularChunkSize).enumerated()), id: \.offset) { idx, chunk in
                            LazyHGrid(rows: gridItem, alignment: .top, spacing: 9) {
                                ForEach(chunk) { quest in
                                    QuestItemView(
                                        quest: quest,
                                        style: PopularStyle(repeatType: RepeatType(rawValue: quest.target.lowercased()) ?? RepeatType.daily),
                                        tagTitle: String(quest.totalRewardXP()) + "XP"
                                    ) {
                                        vm.onQuestTapped(quest: quest)
                                    }
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            .tag(idx)
                        }
                    }
                    .frame(height: 450)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    HStack(spacing: 4) {
                        let pageCount = Int(vm.popularQuestList.count / vm.popularChunkSize)
                        if pageCount >= 2 {
                            ForEach(0..<Int(pageCount), id: \.self) { circleIdx in
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(circleIdx == vm.selectedPopularTabIndex ? Color.gray500 : Color.gray100)
                                    .animation(.default, value: circleIdx)
                            }
                        }
                    }
                }
        )
    }
    
    private var recommendQuestSection: some View {
        TitleWithContentView(
            title: vm.recommendQuestTitle,
            content:
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(vm.recommendQuestList, id: \.id) { quest in
                            QuestItemView(
                                quest: quest,
                                style: RecommendStyle()) {
                                    vm.onQuestTapped(quest: quest)
                                }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                .scrollIndicators(.hidden)
        )
    }
    
    private var largestRewardQuestSection: some View {
        TitleWithContentView(
            title: "큰 보상 퀘스트",
            seeAll: (
                .label("전체 보기"),
                .bottomTrailing, {
                    sharedState.selectedXpStat = vm.selectedXpStat
                    sharedState.selectedTab = .quest /// 퀘스트 탭(선택된 스탯)으로 이동
                }
            ),
            content:
                Group {
                    StatHeaderView(
                        selectedXpStat: $vm.selectedXpStat,
                        horizontalPadding: horizontalPadding,
                        height: 30,
                        hasBottomLine: false
                    )
                    // TODO: (디자인 대기 중) 퀘스트 타입에 따라 다르게 보여줘야함
                    ForEach(vm.largestRewardQuestList[vm.selectedXpStat, default: []].prefix(3), id: \.id) { quest in
                        QuestItemView(
                            quest: quest,
                            style: UncompletedStyle(),
                            tagTitle: String(quest.totalRewardXP())+"XP"
                        ) {
                            vm.onQuestTapped(quest: quest)
                        }
                    }
                }
        )
    }
    
    private var userRankingSection: some View {
        TitleWithContentView(
            title: "유저 랭킹",
            seeAll: (
                .icon,
                .topTrailing, {
                    sharedState.selectedTab = .ranking /// 랭킹탭 이동
                }
            ),
            content:
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(vm.userRankList.enumerated()), id: \.offset) { idx, rank in
                            RankingItemView(idx: idx + 1, rank: rank, style: .vertical)
                        }
                    }
                    .padding(.bottom, 72)
                    .padding(.horizontal, horizontalPadding)
                }
                .scrollIndicators(.never)
        )
    }
}

#Preview {
    HomeView()
}

extension Array {
    func chunks(of chunkSize: Int) -> [[Element]] {
        stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, count)])
        }
    }
}
