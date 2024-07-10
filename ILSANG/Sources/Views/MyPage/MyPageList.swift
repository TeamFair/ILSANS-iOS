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
    @Binding var segmentSelect : Int
    
    var body: some View {
        
        let item = data.filter{$0.status == convertStatus(idx: segmentSelect)}
        
        if item.isEmpty {
            VStack {
                Text("Coming Soon!")
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                    .multilineTextAlignment(.center)
                    .refreshable {
                        // 데이터 리프레시
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(alignment: .leading) {
                Text("최근 활동 순")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                
                // Data List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(item) { Data in
                            NavigationLink(destination: DetailQuestview(QuestData: Data)) {
                                ListStruct(title: Data.questTitle, detail: Data.questDetail, point: Data.questXP)
                            }
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
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                Text(detail)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray500)
            }
            
            Spacer()
            
            Text("+\(point)XP")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color.accentColor)
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
