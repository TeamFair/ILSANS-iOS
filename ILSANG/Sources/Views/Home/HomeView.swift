//
//  HomeView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/21/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel()
    @EnvironmentObject var sharedState: SharedState
    @Namespace private var namespace
    
    let gridItem = [GridItem(), GridItem()]
    
    var body: some View {
        VStack(spacing: 23) {
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
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 36) {
                    // 메인 배너 영역
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 360)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 2)
                    
                    // 인기퀘스트 영역
                    TitleWithContentView(
                        title: "이번달 인기 퀘스트 모음",
                        content:
                            LazyHGrid(rows: gridItem, alignment: .top, spacing: 9) {
                                ForEach(vm.polularQuestList, id: \.id) { quest in
                                    QuestItemView(
                                        quest: quest, style: PopularStyle(repeatType: RepeatType(rawValue: quest.target.lowercased()) ?? RepeatType.daily),
                                        tagTitle: String(quest.totalRewardXP())+"XP") {
                                            vm.tappedQuestBtn(quest: quest)
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                    )
                        
                    // 추천 퀘스트 영역
                    TitleWithContentView(
                        title: "\(vm.userNickname)님을 위한 추천 퀘스트",
                        content:
                            ScrollView(.horizontal) {
                                HStack(spacing: 12) {
                                    ForEach(vm.recommendQuestList, id: \.id) { quest in
                                        QuestItemView(
                                            quest: quest, 
                                            style: RecommendStyle()) {
                                                vm.tappedQuestBtn(quest: quest)
                                            }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .scrollIndicators(.hidden)
                    )
                    
                    
                    // 큰 보상 퀘스트 영역
                    TitleWithContentView(
                        title: "큰 보상 퀘스트",
                        seeAll: (
                            .label("전체 보기"),
                            .bottomTrailing,
                            {
                                sharedState.selectedXpStat = vm.selectedXpStat
                                sharedState.selectedTab = .quest /// 퀘스트 탭(선택된 스탯)으로 이동
                            }
                        ),
                        content:
                            VStack(spacing: 12) {
                                questStatHeaderView
                                
                                ForEach(vm.largestRewardQuestList[vm.selectedXpStat, default: []].prefix(3), id: \.id) { quest in
                                    QuestItemView(
                                        quest: quest,
                                        style: UncompletedStyle(),
                                        tagTitle: String(quest.totalRewardXP())+"XP"
                                    ) {
                                        vm.tappedQuestBtn(quest: quest)
                                    }
                                }
                            }
                    )
                    
                    
                    // 유저 랭킹
                    TitleWithContentView(
                        title: "유저 랭킹",
                        seeAll: (
                            .icon,
                            .topTrailing,
                            {
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
                                .padding(.horizontal, 20)
                            }
                            .scrollIndicators(.never)
                    )
                }
            }
        }
        .background(Color.background)
    }
    
    private var questStatHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(XpStat.allCases, id: \.headerText) { xpStat in
                Button {
                    vm.selectedXpStat = xpStat
                } label: {
                    Text(xpStat.headerText)
                        .foregroundColor(xpStat == vm.selectedXpStat ? .gray500 : .gray300)
                        .font(.system(size: 14, weight: xpStat == vm.selectedXpStat ? .semibold : .medium))
                        .frame(height: 30)
                }
                .padding(.horizontal, 7)
                .overlay(alignment: .bottom) {
                    if xpStat == vm.selectedXpStat {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(.primaryPurple)
                            .matchedGeometryEffect(id: "XpStat", in: namespace)
                    }
                }
                .animation(.easeInOut, value: vm.selectedXpStat)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    HomeView()
}
