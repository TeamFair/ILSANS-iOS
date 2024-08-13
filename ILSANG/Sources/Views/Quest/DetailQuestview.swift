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
    @State var questDelet = false
    
    let QuestData : Challenge
    
    var body: some View {
        
        NavigationTitleView(title: "챌린지 정보", isDeleteButtonHidden: false, QuestDelet: questDelet) {
            dismiss()
        }
        
        ZStack {
            if let missionImage = missionImage {
                Image(uiImage: missionImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ErrorView(title: "챌린지 정보를 불러오지 못했어요", subTitle: "챌린지 정보를 불러오는 데 실패했어요.\n인터넷 연결 상태 확인 후 다시 시도해주세요."){
                    Task {
                        missionImage = await vm.getImage(imageId: QuestData.receiptImageId)
                    }
                }
                    .background(Color.background)
            }
            
            if missionImage != nil {
                VStack {
                    Spacer()
                    
                    HStack() {
                        VStack (alignment: .leading) {
                            Text(QuestData.quest?.missions.first?.title ?? "")
                                .font(.headline)
                                .padding(.bottom, 1)
                            
                            Text("좋아요 \(QuestData.likeCnt)개")
                                .font(.subheadline)
                                .foregroundColor(.gray500)
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text(QuestData.createdAt.timeAgoCreatedAt())
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
        .overlay {
            if questDelet {
                SettingAlertView(
                    alertType: .QuestDelete,
                    onCancel: { questDelet = false },
                    onConfirm: {
                        
                    }
                )
            }
        }
        .task {
            missionImage = await vm.getImage(imageId: QuestData.receiptImageId)
        }
        .navigationBarBackButtonHidden()
    }
}
