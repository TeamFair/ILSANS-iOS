//
//  DetailQuestview.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/31/24.
//

import SwiftUI

struct DetailQuestview: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var uiImage: UIImage? = nil
    @Binding var QuestData : Quest
    
    var body: some View {
        
        NavigationTitleView(title: "퀘스트 정보") {
            dismiss()
        }
        
        ZStack {
           // if let missionImage = QuestData.missionImage {
                if let missionImage = uiImage {
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
                    Text(QuestData.missionTitle)
                        .font(.headline)
                        .padding(.bottom, 1)
                    
                    HStack {
                        Text("조회수 1,302회")
                        Spacer()
                        Text("좋아요 12개")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("2024.05.06")
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
