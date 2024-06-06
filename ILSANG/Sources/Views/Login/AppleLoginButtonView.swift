//
//  AppleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginButtonView: View {
    
    //@EnvironmentObject var userService: UserService
            
    var body: some View {
        SignInWithAppleButton { (request) in
            request.requestedScopes = [.email]
            request.nonce = sha256(randomNonceString())
        } onCompletion: { (result) in
            switch result {
            case .success(let user):
                Task {
                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                        print("error with credential")
                        return
                    }
                    //await userService.login(appleCredential: credential, email: userService.userEmail)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .frame(width: 270, height: 50)
        
        .overlay {
            HStack {
                Image(LoginButton.apple.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                Spacer()
                Text(LoginButton.apple.labelText)
                    .foregroundColor(LoginButton.apple.accentColor)
                    .font(.custom("SFProDisplay-Medium", size: 14))
                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(width: 270, height: 50)
            .background(LoginButton.apple.backgroundColor)
            .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
