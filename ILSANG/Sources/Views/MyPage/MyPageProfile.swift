//
//  MyPageProfile.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/23/24.
//

import SwiftUI

struct MyPageProfile: View {
    
    
    
    var body: some View {
        HStack {
            //프로필
            ProfileImageView(profileImage: nil, level: 3)
            
            // 프로필 상세
            VStack (alignment: .leading) {
                HStack {
                    //유저 이름
                    Text("Name")
                    
                    // 이름 수정 버튼
                    Image(systemName: "pencil.circle")
                        .foregroundColor(Color.accentColor)
                }
                
                HStack {
                    // 프로그레스 바
                    ProgressBar(userXP: 40, levelXP: 100)
                        .frame(height: 10)
                    
                    // 경험치 Text
                    Text("1000XP")
                }
        
                Text("다음 레벨까지 1050XP 남았어요!")            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.white)
        )
    }
}

struct ProfileImageView: View {
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
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                } else {
                    //커스텀 이미지가 존재하지 않을 경우
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 57, height: 57)
                        .foregroundColor(Color.accentColor)
                }
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                Text("LEVEL \(Level)")
                    .font(.system(size: 11))
                    .fontWeight(.bold)
                    .foregroundColor(Color.accentColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                //TODO: 색상 변경 요청
                    .background(Color(red: 0.95, green: 0.91, blue: 0.99))
                    .cornerRadius(6)
            }
        }
        .frame(height: 68)
    }
}

//MARK: 공용으로 이동
struct ProgressBar: View {
    
    var userXP : Int
    var levelXP : Int
    
    //소수 2자리로 변경합니다.
    private var progress: CGFloat {
        CGFloat(userXP) / CGFloat(levelXP)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray100)
                
                Rectangle()
                    .frame(
                        width: min(progress * geometry.size.width,
                                   geometry.size.width),
                        height: 10
                    )
                //MARK: 게이지 별 디자인 요청
                    .foregroundColor(.accentColor)
            }
        }
    }
}


#Preview {
    MyPageProfile()
}
