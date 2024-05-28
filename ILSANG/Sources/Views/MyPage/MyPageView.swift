//
//  MyPageView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct MyPageView: View {
    
    @State var testData: [QuestDetail] = [
        QuestDetail(questTitle: "Title1", questDetail: "Detail1", questXP: 50, status: .QUEST),
        QuestDetail(questTitle: "Title2", questDetail: "Detail2", questXP: 100, status: .ACTIVITY)
       ]
    
    @State var segmenetSelect = 0
    
    var body: some View {
        
        VStack {
            
            //프로필 제목
            HStack {
                Text("내 프로필")
                    .font(.system(size: 21))
                Spacer()
                Image(systemName: "gearshape")
            }
            
            //개인 프로필
            MyPageProfile()
            
            //Segmenet
            MyPageSegment(selectedIndex: $segmenetSelect)
            
            //퀘스트 List
            MyPageList(data: $testData, segmenetSelect: $segmenetSelect)
        }
        .padding(21)
        //MARK: 추후 삭제
        .background(Color.gray100)
    }
}

#Preview {
    MyPageView()
}
