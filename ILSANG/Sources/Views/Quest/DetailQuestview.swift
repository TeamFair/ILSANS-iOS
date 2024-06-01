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
                Text("이미지를 불러오는 중...")
                    .onAppear {
                        // 이미지가 없을 시 재시도 로직
                    }
            }
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(QuestData.questTitle)
                        .font(.headline)
                        .padding(.bottom, 1)
                    
                    HStack {
                        Text(QuestData.questDetail)
                        Spacer()
                        Text(QuestData.questDate)
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(QuestData.questLike) 개")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
