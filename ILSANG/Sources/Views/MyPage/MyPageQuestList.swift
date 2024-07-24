//
//  MyPageQuestList.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/22/24.
//

import SwiftUI
//MARK: 색상 폰트 변경 요청
struct MyPageQuestList: View {
    
    @ObservedObject var vm: MypageViewModel = MypageViewModel(userNetwork: UserNetwork(),xpNetwork: XPNetwork(), questNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork())
    
    @Binding var questData: [Challenge]
    
    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                Text("수행한 챌린지")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                
                Spacer()
            }
            // Data List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(questData, id: \.challengeId) { Data in
                        NavigationLink(destination: DetailQuestview(QuestData: Data)) {
                            ListStruct(title: Data.quest.missions.first?.title ?? "챌린지명", detail: Data.createdAt, point: nil)
                        }
                    }
                }
            }
            .refreshable {
                await vm.getQuest(page: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ListStruct: View {
    
    let title: String
    let detail: String
    let point: Int?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                Text(detail)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray500)
            }
            
            Spacer()
            
            if (point != nil) {
                Text("+\(point ?? 0)XP")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.accentColor)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
        )
    }
}