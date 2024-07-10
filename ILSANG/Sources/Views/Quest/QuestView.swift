//
//  QuestView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/19/24.
//

import SwiftUI

struct QuestView: View {
    @StateObject var vm: QuestViewModel = QuestViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            
            questListView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background)
        .overlay {
            if vm.isCurrentListEmpty {
                questListEmptyView
            }
        }
        .sheet(isPresented: $vm.showQuestSheet) {
            questSheetView
                .presentationDetents([.height(540)])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $vm.showSubmitRouterView) {
            SubmitRouterView(selectedQuestId: vm.selectedQuest.id)
                .interactiveDismissDisabled()
        }
    }
}

extension QuestView {
    private var headerView: some View {
        HStack(spacing: 15) {
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
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
    
    private var questListView: some View {
        ScrollView {
            VStack(spacing: 12) {
                switch vm.selectedHeader {
                case .ACTIVE:
                    ForEach(vm.activeQuestList, id: \.id) { quest in
                        Button {
                            vm.tappedQuestBtn(quest: quest)
                        } label: {
                            QuestItemView(quest: quest)
                        }
                    }
                case .INACTIVE:
                    ForEach(vm.inactiveQuestList, id: \.id) { quest in
                        QuestItemView(quest: quest)
                    }
                }
            }
            .padding(.top, 6)
            .padding(.bottom, 72)
        }
    }
    
    private var questListEmptyView: some View {
        ErrorView(
            title: vm.selectedHeader.emptyTitle,
            subTitle: vm.selectedHeader.emptySubTitle
        )
    }
    
    private var questSheetView: some View {
        VStack(spacing: 0) {
            Text("퀘스트 정보")
                .font(.system(size: 17, weight: .bold))

            Image(uiImage: vm.selectedQuest.missionImage)
                .resizable()
                .frame(width: 122, height: 122)
                .padding(21)
            
            Text(vm.selectedQuest.missionCompany)
                .font(.system(size: 15, weight: .regular))
                .padding(.bottom, 9)
            
            Text(vm.selectedQuest.missionTitle)
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 22)
            
            Text("+" + String(vm.selectedQuest.reward) + "XP")
                .font(.system(size: 30, weight: .semibold))
                .padding(.horizontal, 38)
                .padding(.vertical, 31)
                .foregroundStyle(.primaryPurple)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(.primary100.opacity(0.5))
                )
                .padding(.bottom, 15)
            
            Text("퀘스트를 수행하셨나요?\n인증 후 포인트를 적립받으세요")
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.bottom, 26)

            PrimaryButton(title: "퀘스트 인증하기") {
                vm.tappedQuestApprovalBtn()
            }
        }
        .foregroundStyle(.gray500)
        .padding(20)
    }
}

#Preview {
    QuestView()
}
