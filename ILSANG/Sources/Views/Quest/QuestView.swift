//
//  QuestView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/19/24.
//

import SwiftUI

struct QuestView: View {
    @StateObject var vm: QuestViewModel = QuestViewModel(questNetwork: QuestNetwork())
    @Namespace private var namespace

    var body: some View {
        VStack(spacing: 0) {
            headerView
                
            if vm.selectedHeader == .default || vm.selectedHeader == .repeat {
                subHeaderView
            }
            
            switch vm.viewStatus {
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                questListView
            case .error:
                networkErrorView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .sheet(isPresented: $vm.showQuestSheet) {
            QuestDetailView(quest: vm.selectedQuest) {
                vm.tappedQuestApprovalBtn()
            }
            .presentationDetents([.height(464)])
            .presentationDragIndicator(.hidden)
        }
        .fullScreenCover(isPresented: $vm.showSubmitRouterView) {
            SubmitRouterView(selectedQuest: vm.selectedQuest)
                .interactiveDismissDisabled()
        }
    }
}

extension QuestView {
    private var headerView: some View {
        HStack(spacing: 16) {
            ForEach(QuestStatus.allCases, id: \.headerText) { status in
                Button {
                    vm.selectedHeader = status
                } label: {
                    Text(status.headerText)
                        .foregroundColor(status == vm.selectedHeader ? .gray500 : .gray300)
                        .font(.system(size: 21, weight: .bold))
                        .frame(height: 30)
                }
            }
            Spacer()
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
    
    private var subHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(XpStat.allCases, id: \.headerText) { xpStat in
                Button {
                    withAnimation(.easeInOut) {
                        vm.selectedXpStat = xpStat
                    }
                } label: {
                    Text(xpStat.headerText)
                        .foregroundColor(xpStat == vm.selectedXpStat ? .gray500 : .gray300)
                        .font(.system(size: 14, weight: xpStat == vm.selectedXpStat ? .semibold : .medium))
                        .frame(height: 40)
                }
                .padding(.horizontal, 6)
                .overlay(alignment: .bottom) {
                    if xpStat == vm.selectedXpStat {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(.primaryPurple)
                            .matchedGeometryEffect(id: "XpStat", in: namespace)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray100)
        }
    }
    
    private var questListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                switch vm.selectedHeader {
                case .default:
                    ForEach(vm.filteredDefaultQuestListByXpStat, id: \.id) { quest in
                        QuestItemView(
                            style: .uncompleted,
                            quest: quest,
                            tagTitle: String(quest.totalRewardXP())+"XP",
                            action: {
                                vm.tappedQuestBtn(quest: quest)
                            }
                        )
                    }
                case .repeat:
                    ForEach(vm.filteredRepeatQuestListByXpStat, id: \.id) { quest in
                        QuestItemView(
                            style: .repeatable(vm.selectedRepeatType),
                            quest: quest,
                            tagTitle: vm.selectedRepeatType.description,
                            action: {
                                vm.tappedQuestBtn(quest: quest)
                            }
                        )
                    }
                case .completed:
                    ForEach(vm.itemListByStatus[.completed, default: []], id: \.id) { quest in
                        QuestItemView(
                            style: .completed,
                            quest: quest,
                            tagTitle: String(quest.totalRewardXP())+"XP",
                            action: { }
                        )
                    }
                    if vm.hasMorePage(status: .completed) {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await vm.completedPaginationManager.loadData(isRefreshing: false)
                                }
                            }
                    }
                }
            }
            .padding(.top, vm.selectedHeader == .default || vm.selectedHeader == .repeat ? 70 : 0)
            .overlay(alignment: .top) {
                Group {
                    if (vm.selectedHeader == .default) {
                        filterPickerDefaultView
                    } else if (vm.selectedHeader == .repeat) {
                        HStack(alignment: .top, spacing: 8) {
                            filterPickerRepeatView
                            filterPickerDefaultView
                        }
                    }
                }
                .padding(.top, 13)
                .padding(.bottom, 16)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.bottom, 72)
        }
        .refreshable {
            await vm.refreshData()
        }
        .frame(maxWidth: .infinity)
        .overlay {
            if vm.isCurrentListEmpty {
                questListEmptyView
            }
        }
    }
    
    private var filterPickerDefaultView: some View {
        PickerView<QuestFilter>(selection: $vm.selectedFilter, width: 150)
    }
    
    private var filterPickerRepeatView: some View {
        PickerView<RepeatType>(selection: $vm.selectedRepeatType, width: 85)
    }
    
    private var questListEmptyView: some View {
        ErrorView(
            title: vm.selectedHeader.emptyTitle,
            subTitle: vm.selectedHeader.emptySubTitle,
            showButton: false
        )
    }
    
    private var networkErrorView: some View {
        ErrorView(
            systemImageName: "wifi.exclamationmark",
            title: "네트워크 연결 상태를 확인해주세요",
            subTitle: "네트워크 연결 상태가 좋지 않아\n퀘스트를 불러올 수 없어요 ",
            emoticon: "🥲"
        ) {
            Task { await vm.loadInitialData() }
        }
    }
}

#Preview {
    QuestView(vm: QuestViewModel(questNetwork: QuestNetwork()))
}
