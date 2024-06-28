//
//  SettingAlertView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/27/24.
//

import SwiftUI

struct SettingAlertView: View {
    
    var AlertTitle: String
    var AlertSubTitle: String?
    
    var AlertDisagree: String
    var AlertAgree: String
    
    var body: some View {
        VStack (alignment: .center, spacing: 6) {
            Text(AlertTitle)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            if (AlertSubTitle != nil) {
                Text(AlertSubTitle ?? "")
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 16)
            }
            
            HStack (spacing: 10) {
                Text(AlertDisagree)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: 140, maxHeight: 50)
                    .background(.gray100)
                    .cornerRadius(12)
                
                Text(AlertAgree)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 140, maxHeight: 50)
                    .background(.accent)
                    .cornerRadius(12)
                
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 16)
        .padding(.top, 28)
        .padding(.bottom, 16)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    VStack{
        SettingAlertView(AlertTitle: "닉네임 변경을 취소할까요?", AlertSubTitle: "변경을 완료하지 않으면\n프로필이 저장되지 않습니다.",AlertDisagree: "취소",AlertAgree: "확인")
        SettingAlertView(AlertTitle: "로그아웃 하시겠어요?", AlertSubTitle: nil,AlertDisagree: "아니요",AlertAgree: "예")
        SettingAlertView(AlertTitle: "정말 탈퇴하시겠어요?", AlertSubTitle: "확인 시 일상 계정이 영구적으로 삭제되며,\n모든 데이터는 복구가 불가능합니다.",AlertDisagree: "취소",AlertAgree: "확인")
    }
}
