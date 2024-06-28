//
//  LoginView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLogin : Bool
        
    var kakaoButtonAction: () -> Void {
        {
            //MARK: 로그인 기능 구현
        }
    }
    
    var googleButtonAction: () -> Void {
        {
            //MARK: 로그인 기능 구현
        }
    }
    
    var body: some View {
        VStack(spacing: 84) {
            Image(.loginLogo)
            
            VStack(spacing: 16) {
                KakaoLoginButtonView(buttonAction: kakaoButtonAction)
                GoogleLoginButtonView(buttonAction: googleButtonAction)
                AppleLoginButtonView()
                //.environmentObject(userService)
                
                //MARK: 실제 로그인이 아니고 뷰만 이동합니다.
                //await userService.loginWithTest()
                Text("테스트 로그인")
                    .onTapGesture { isLogin.toggle() }
            }
        }
        .padding(.top, 90)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView(isLogin: .constant(false))
}
