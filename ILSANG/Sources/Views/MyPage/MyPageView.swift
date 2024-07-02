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
    
    @StateObject var vm: MypageViewModel = MypageViewModel(userNetwork: UserNetwork(), questNetwork: QuestNetwork())
    @State var segmenetSelect = 0
    @State private var isSettingsViewActive = false
    @State var QuestList: [AWSQuest]
    
    var body: some View {
        NavigationView {
            VStack {
                
                //프로필 제목
                HStack {
                    Text("내 프로필")
                        .font(.system(size: 21))
                        .fontWeight(.bold)
                        .foregroundColor(.gray400)
                    Spacer()
                    
                    NavigationLink(destination: SettingView()) {
                        Image("Setting")
                    }
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
            .background(Color.background)
        }
        .onAppear{
            switch segmenetSelect {
            case 0:
                QuestList = vm.q
            case 1:
                
            case 2:
                
            }
        }
    }
}

#Preview {
    MyPageView()
}
