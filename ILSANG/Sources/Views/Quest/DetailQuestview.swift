//
//  DetailQuestview.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/31/24.
//

import SwiftUI

struct DetailQuestview: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: MypageViewModel = MypageViewModel(userNetwork: UserNetwork(),xpNetwork: XPNetwork(), questNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork())
    
    @State private var missionImage: UIImage? = nil
    
    let QuestData : Challenge
    
    var body: some View {
        
        NavigationTitleView(title: "챌린지 정보") {
            dismiss()
        }
        
        ZStack {
            if let missionImage = missionImage {
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
                        .foregroundColor(.gray400)
                    
                    Spacer()
                        .frame(height: 35)
                    
                    PrimaryButton(title: "다시 시도",
                                  action: {
                        Task {
                            missionImage = await vm.getImage(imageId: QuestData.receiptImageId)
                        }
                    })
                        .frame(width: 151)
                    
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(Color.background)
            }
            
            if missionImage != nil {
                VStack {
                    Spacer()
                    
                    HStack() {
                        VStack (alignment: .leading) {
                            Text(QuestData.quest.missionTitle)
                                .font(.headline)
                                .padding(.bottom, 1)
                            
                            Text("좋아요 \(QuestData.likeCnt)개")
                                .font(.subheadline)
                                .foregroundColor(.gray500)
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text(QuestData.createdAt)
                                .font(.subheadline)
                                .foregroundColor(.gray400)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .background(Color(.gray300))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
            } 
        }
        .task {
            missionImage = await vm.getImage(imageId: QuestData.receiptImageId)
        }
        .navigationBarBackButtonHidden()
    }
}
