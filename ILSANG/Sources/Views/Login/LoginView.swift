//
//  LoginView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/6/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm: LoginViewModel
    
    var body: some View {
        VStack(spacing: 84) {
            Image(.loginLogo)
            
            VStack(spacing: 16) {
                KakaoLoginButtonView(buttonAction: vm.kakaoButtonAction)
                GoogleLoginButtonView(buttonAction: vm.googleButtonAction)
                
                AppleLoginButtonView(vm: vm)
                
#if DEBUG
                Text("테스트 로그인")
                    .onTapGesture { vm.testLogin() }
#endif
            }
        }
        .padding(.top, 90)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView(vm: LoginViewModel())
}
