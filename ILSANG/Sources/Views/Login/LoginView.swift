//
//  LoginView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    
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
                .background(Color.accentColor)
                .cornerRadius(36)
                .padding(.bottom, 128)
            
            VStack(spacing: 16) {
                KakaoLoginButtonView(buttonAction: kakaoButtonAction)
                GoogleLoginButtonView(buttonAction: googleButtonAction)
                AppleLoginButtonView()
                    //.environmentObject(userService)
                
#if DEBUG
                Button {
                    Task { 
                        //await userService.loginWithTest()
                    }
                } label: {
                    Text("테스트 로그인")
                }
#endif
            }
            .padding(.bottom, 25)
            
            Button {
                isVisitor = true
            } label: {
                Text("로그인 없이 둘러보기")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .underline()
            }
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

#Preview {
    LoginView()
}
