//
//  DetailQuestview.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/31/24.
//

import SwiftUI

struct DetailQuestview: View {
    
    @Environment(\.dismiss) var dismiss
    
    let QuestData : QuestDetail
    
    var body: some View {
        
        NavigationTitleView(title: "퀘스트 정보") {
            dismiss()
        }
        
        ZStack {
            if let missionImage = QuestData.questImage {
                Image(uiImage: missionImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack (alignment: .center,spacing: 6) {
                    Text("챌린지 정보를 불러오지 못했어요")
                        .font(.system(size: 21, weight: .bold))
                    
                    Text("챌린지 정보를 불러오는 데 실패했어요.\n인터넷 연결 상태 확인 후 다시 시도해주세요.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer()
                        .frame(height: 35)
                    
                    PrimaryButton(title: "다시 시도", action: {print("tapped")})
                        .frame(width: 151)
                    
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(Color.background)
            }
            
            VStack {
                Spacer()
                
                HStack() {
                    VStack (alignment: .leading) {
                        Text(QuestData.questTitle)
                            .font(.headline)
                            .padding(.bottom, 1)
                        
//                        Text("조회수 \((QuestData.questXP).description.formatNumberInText())회 | 좋아요 \(QuestData.questLike)개")
                        Text("좋아요 \(QuestData.questLike)개")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text(QuestData.questDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
