//
//  MyPageView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct MyPageView: View {
    
    @State var testData: [QuestDetail] = [
        QuestDetail(questTitle: "Title1", questImage: nil, questDetail: "Detail1", questLike: 50, questDate: "2023.03.03",questXP: 3,status: .QUEST),
        QuestDetail(questTitle: "Title2", questImage: nil, questDetail: "Detail2", questLike: 100, questDate: "2023.03.06",questXP: 3,status: .QUEST)
       ]
    
    @State var segmentSelect = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 프로필 제목
                HStack {
                    Text("내 프로필")
                        .font(.system(size: 21))
                        .fontWeight(.bold)
                        .foregroundColor(.gray500)
                    Spacer()
                    NavigationLink(destination: SettingView()) {
                        Image("Setting")
                            .foregroundColor(.gray500)
                    }
                }
                .frame(height: 50)
                .padding(.bottom, 5)
                
                // 개인 프로필
                MyPageProfile()
                
                // 퀘스트/활동/뱃지 세그먼트
                MyPageSegment(selectedIndex: $segmentSelect)
                
                // 퀘스트/활동/뱃지 리스트
                MyPageList(data: $testData, segmentSelect: $segmentSelect)
            }
            .padding(.horizontal, 20)
            .background(Color.background)
        }
    }
}

#Preview {
    MyPageView()
}
