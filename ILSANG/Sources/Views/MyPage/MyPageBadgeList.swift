//
//  MyPageBadgeList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageBadgeList: View {
    
    @ObservedObject var vm: MypageViewModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4){
                Text("총 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                Text("\(String(vm.userData?.xpPoint ?? 150).formatNumberInText())XP")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray500)
                
                // 프로그레스 바
                vm.ProgressBar(userXP: vm.userData?.xpPoint ?? 0)
                    .frame(height: 10)
                    .padding(.top, 10)
                
                HStack {
                    Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.gray200)
                    
                    Spacer()
                    
                    Text("다음 레벨까지 \(vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50))XP 남았어요!")
                        .font(.system(size: 13))
                        .foregroundColor(.gray500)
                    
                    Spacer()
                    
                    Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9)+1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accent)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 24){
                Text("능력별 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                vm.PentagonGraph(xpStats: vm.xpStats, width: 185, mainColor: .primaryPurple, subColor: .gray300, maxValue: Double(50 + vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 0)))
                
                ShareLink(
                    item: ShareImage,
                    preview: SharePreview("프로필 공유", image: ShareImage)
                ) {
                    PrimaryButton(title: "공유하기", action: {Log("공유하기 버튼")})
                }
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 18)
            .background(.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    //공유하기 기능 구현
    private var ShareImage: TransferableUIImage {
        return .init(uiimage: ProfileShareImage, caption: "개인 프로파일 공유하기")
    }
    
    private var ProfileShareImage: UIImage {
        let renderer = ImageRenderer(content:  MyPageBadgeList(vm:MypageViewModel(userNetwork: UserNetwork(), challengeNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork(), xpNetwork: XPNetwork())).frame(width: 300))
        
        renderer.scale = 3.0
        return renderer.uiImage ?? .init()
    }
}

#Preview {
    MyPageBadgeList(vm:MypageViewModel(userNetwork: UserNetwork(), challengeNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork(), xpNetwork: XPNetwork()))
}
