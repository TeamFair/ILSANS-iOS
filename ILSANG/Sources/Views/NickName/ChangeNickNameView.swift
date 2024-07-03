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
        ZStack {
            VStack {
                NavigationTitleView(title: "정보 수정") {
                    if name.isEmpty {
                        dismiss()
                    } else {
                        showAlert.toggle()
                    }
                }
                
                VStack (alignment: .leading){
                    //설명
                    Text("새로운 닉네임을 입력하세요")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.gray500)
                    
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
                            .onChange(of: name) { _ in
                                Task {
                                    //중복되는 아이디가 있거나 서버 연결에 문제 있을 경우
                                    if await UserNetwork().putUser(nickname: name) {
                                        isSame = true
                                    } else {
                                        //중복되는 아이디가 없을 경우
                                        isSame = false
                                    }
                                }
                            }
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
                        .onTapGesture {
                            Task {
                                //중복되는 아이디가 있거나 서버 연결에 문제 있을 경우
                                if await UserNetwork().putUser(nickname: name) {
                                    isSame = true
                                    //MARK: 이름 변경되었을때 뷰 확인
                                } else {
                                    //중복되는 아이디가 없을 경우
                                    isSame = false
                                }
                            }
                        }
                        .disabled(!isSame && name.isEmpty)
                }
                .navigationBarBackButtonHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
            }
            if showAlert {
                SettingAlertView(alertType: .NickName,onCancel: {showAlert = false}, onConfirm: {dismiss()})
            }
        }
    }
}
