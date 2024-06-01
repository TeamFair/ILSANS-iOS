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
            
            scrollView
        }
        .background(Color.background)
        .sheet(isPresented: $vm.showQuestSheet) {
            questSheetView
                .presentationDetents([.height(540)])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $vm.showSubmitRouterView) {
            SubmitRouterView(selectedQuestId: vm.selectedQuest.id)
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
                        .foregroundColor(status == vm.selectedHeader ? .gray400 : .gray200)
                        .font(.system(size: 21, weight: status == vm.selectedHeader ? .bold : .regular))
                        .frame(height: 30)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var scrollView: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(vm.questList, id: \.missionTitle) { quest in
                    Button {
                        vm.tappedQuestBtn(quest: quest)
                    } label: {
                        QuestItemView(quest: quest)
                    }
                }
            }
            .padding(.top, 17)
        }
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
                        .foregroundStyle(.gray100)
                )
                .padding(.bottom, 15)
            
            Text("퀘스트를 수행하셨나요?\n인증 후 포인트를 적립받으세요")
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.bottom, 26)

            PrimaryButton(title: "퀘스트 인증하기") {
                vm.tappedQuestApprovalBtn()
            }
        }
        .foregroundStyle(.gray400)
        .padding(20)
    }
}

#Preview {
    QuestView()
}
