//
//  CustomerServiceView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI
import UIKit

struct CustomerServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "고객센터", isSeparatorHidden: true) {
                dismiss()
            }
            
            HStack {
                Text("인스타그램")
                    .font(.system(size: 17).bold())
                    .foregroundColor(.gray400)
                
                Spacer()
                
                Text("1sang.official")
                    .underline()
                    .font(.system(size: 17))
                    .foregroundColor(.gray200)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 26)
            .background(.white)
            .onTapGesture {
                openInstagram()
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        //MARK: 색상 변경시 수정
        .background(Color.background)
        .navigationBarBackButtonHidden()
    }
}

private func openInstagram() {
    //고객센터 인스타 URL
    let appURL = URL(string: "instagram://user?username=1sang.official")!
    let webURL = URL(string: "https://www.instagram.com/1sang.official?igsh=MXM3YTB1ZXp5aDFzOQ%3D%3D&utm_source=qr")!
    
    if UIApplication.shared.canOpenURL(appURL) {
          UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.open(webURL)
    }
}

#Preview {
    CustomerServiceView()
}
