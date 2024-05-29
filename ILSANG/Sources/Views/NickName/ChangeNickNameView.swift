//
//  ChangeNickNameView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct ChangeNickNameView: View {
    
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                //설명
                Text("새로운 닉네임을 입력하세요")
                
                //닉네임 입력란
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity,maxHeight: 50)
                        .background(.gray100)
                        .cornerRadius(12)
                    
                    HStack (alignment: .center){
                        TextField("닉네임을 입력하세요", text: $name)
                    }
                    .padding(14)
                }
                
                Text("입력하신 닉네임은 이미 사용중이에요.\n다른 닉네임을 입력해주세요")
                    .foregroundColor(.red)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("정보 수정")
        .padding(20)
    }
}

#Preview {
    ChangeNickNameView()
}
