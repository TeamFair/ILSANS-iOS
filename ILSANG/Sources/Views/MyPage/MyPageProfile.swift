//
//  MyPageProfile.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/23/24.
//

import SwiftUI

struct MyPageProfile: View {
    
    @ObservedObject var vm: MypageViewModel
    
    var body: some View {
        NavigationLink(destination: ChangeNickNameView()) {
            VStack {
                //기본 프로필
                HStack {
                    //프로필
                    ProfileImageView(ProfileImage: nil)
                    
                    // 프로필 상세
                    VStack (alignment: .leading, spacing: 4) {
                        //유저 이름
                        Text(vm.userData?.nickname ?? "일상73079405")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.gray500)
                            .multilineTextAlignment(.leading)
                        
                        Text("Lv. \(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9))")
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(Color.accent)
                            .padding(.horizontal, 14.5)
                            .padding(.vertical, 4)
                            .background(.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .stroke(.accent, lineWidth: 1)
                            )
                    }
                    
                    Spacer()
                }
            }
            .cornerRadius(12)
        }
    }
}

struct ProfileImageView: View {
    var ProfileImage: UIImage?
    
    init(ProfileImage: UIImage? = nil) {
        self.ProfileImage = ProfileImage
    }
    
    var body: some View {
        // 프로필 이미지
        ZStack {
            VStack {
                //커스텀 이미지가 존재할 경우
                if (ProfileImage != nil) {
                    Image(uiImage: ProfileImage!)
                        .resizable()
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                } else {
                    //커스텀 이미지가 존재하지 않을 경우
                    Image("profile.circle")
                        .resizable()
                        .frame(width: 57, height: 57)
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Image("profileEdit")
                    .padding(3)
                    .frame(width: 18, height: 18, alignment: .center)
                    .background(.black)
                    .cornerRadius(1000)
                    .offset(x: 20, y: -5)
            }
        }
        .frame(height: 68)
    }
}

#Preview {
    MyPageProfile(vm: MypageViewModel(userNetwork: UserNetwork(), challengeNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork(), xpNetwork: XPNetwork()))
}
