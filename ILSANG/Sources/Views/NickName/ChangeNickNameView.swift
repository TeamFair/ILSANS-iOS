//
//  ChangeNickNameView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct ChangeNickNameView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var isSame : Bool = false
    @State private var isSaved : Bool = false
    @State private var showAlert : Bool = false
    
    var body: some View {
        
        NavigationTitleView(title: "정보 수정") {
            if !isSaved {
                dismiss()
            } else {
                showAlert.toggle()
            }
        }
        
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
                //틀렸을때 테두리
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSame ? Color.red : Color.clear, lineWidth: 3)
                            .cornerRadius(12)
                    )
                
                TextField("닉네임을 입력하세요", text: $name)
                    .padding(14)
            }
            
            Text("입력하신 닉네임은 이미 사용중이에요.\n다른 닉네임을 입력해주세요")
                .opacity(isSame ? 1 : 0)
                .foregroundColor(.red)
            
            Spacer()
            
            Text("변경 완료")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity ,maxHeight: 50)
                .background(Color.accentColor)
                .cornerRadius(12)
                .disabled(!isSame)
            //MARK: 디버깅용 기능
                .onTapGesture { 
                    showAlert.toggle()
                }
        }
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .alert(isPresented: $showAlert) {
            let firstButton = Alert.Button.default(Text("확인")) {
                Task {
                    if await CustomerNetwork().putCustomer(nickname: name) {
                        showAlert = false
                    } else {
                        isSame = false
                        showAlert = false
                    }
                }
            }
            let secondButton = Alert.Button.cancel(Text("취소")) {
                showAlert = false
            }
            return Alert(title: Text("닉네임 변경을 취소할까요?"),
                         message: Text("변경을 완료하지 않으면\n프로필이 저장되지 않습니다."),
                         primaryButton: firstButton, secondaryButton: secondButton)
        }
    }
}
