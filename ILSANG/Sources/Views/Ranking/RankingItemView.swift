//
//  RankingItemView.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import SwiftUI

struct RankingItemView: View {
    
    var nickName: String
    var stat: String
    var point: Int
    
    var body: some View {
        HStack (spacing: 17) {
            RankingProfile(profileImage: nil, level: 1)
            
            VStack (alignment: .leading, spacing: 3) {
                Text(nickName)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                Text("\(stat): \(point)p")
                    .font(.system(size: 13))
                    .foregroundColor(.gray400)
            }
            
            Spacer()
        }
        .padding(.horizontal, 19)
        .padding(.vertical, 21)
        .frame(width: 353, alignment: .topLeading)
        .background(.white)
        .cornerRadius(16)
    }
}

struct RankingProfile: View {
    var ProfileImage: UIImage?
    var Level: Int
    
    init(profileImage: UIImage? = nil, level: Int) {
        self.ProfileImage = profileImage
        self.Level = level
    }
    
    var body: some View {
        // 프로필 이미지
        ZStack {
            VStack {
                //커스텀 이미지가 존재할 경우
                if (ProfileImage != nil) {
                    Image(uiImage: ProfileImage!)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                } else {
                    //커스텀 이미지가 존재하지 않을 경우
                    Image("profile.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
            }
            
            VStack {
                Text("1st")
                    .font(.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .offset(x: 15)
                Spacer()
            }
            
        }
        .frame(height: 68)
    }
}

#Preview {
    RankingItemView(nickName: "닉네임1", stat: "체력", point: 1298349027148)
}
