//
//  KakaoLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI

struct KakaoLoginButtonView: View {
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            HStack {
                Image(LoginButton.kakao.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                Spacer()
                Text(LoginButton.kakao.labelText)
                    .foregroundColor(LoginButton.kakao.accentColor)
                    .font(.custom(LoginButton.kakao.fontName, size: 14))
                
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(width: 270, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LoginButton.kakao.backgroundColor)
            )
        }
    }
}

struct KakaoLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginButtonView(buttonAction: {})
    }
}
