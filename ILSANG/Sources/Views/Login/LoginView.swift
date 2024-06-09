//
//  LoginView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLogin : Bool
    
    @State var isVisitor: Bool = false
    
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
        VStack(spacing: 0) {
            Image("MainLogo")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fit)
                .frame(width: 124, height: 124)
                .background(Color.accent)
                .cornerRadius(36)
                .padding(.bottom, 128)
            
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
            .padding(.bottom, 25)
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.white)
        .accentColor(.black)
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $isVisitor) {
            //TabbarView(isVisitor: $isVisitor)
        }
    }
}

