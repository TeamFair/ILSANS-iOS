//
//  MyPageList.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/22/24.
//

import SwiftUI
//MARK: 색상 폰트 변경 요청
struct MyPageList: View {
    
    @Binding var data: [QuestDetail]
    @Binding var segmenetSelect : Int
    
    var body: some View {
        
        let item = data.filter{$0.status == convertStatus(idx: segmenetSelect)}
        
        if item.isEmpty {
            VStack {
                Text("Coming Soon!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .refreshable {
                        // 데이터 리프레시
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(alignment: .leading) {
                Text("최근 활동 순")
                    .foregroundColor(Color.gray)
                
                // Data List
                ScrollView {
                    ForEach(item, id: \.self) { Data in
                        NavigationLink(destination: DetailQuestview()) {
                            ListStruct(title: Data.questTitle, detail: Data.questDetail, point: Data.questXP)
                        }
                    }
                }
                .refreshable {
                    // 데이터 리프레시
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ListStruct: View {
    
    let title: String
    let detail: String
    let point: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text(detail)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("+\(point)XP")
                .foregroundColor(Color.blue)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
        )
    }
}

extension MyPageList {
    //Status로 변경
    private func convertStatus(idx: Int) -> SegmenetStatus{
        switch idx {
        case 0:
            return .QUEST
        case 1:
            return .ACTIVITY
        case 2:
            return .BADGE
        default:
            return .QUEST
        }
    }
}
