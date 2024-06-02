//
//  DeleteAccountView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss

    @State private var isChecked = false
    @State private var delAlert = false
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavigationTitleView(title: "회원 탈퇴") {
                    dismiss()
                }
                
                VStack(alignment: .center, spacing: 10){
                    
                    Spacer()
                    
                    Text("🚨")
                        .font(.system(size: 50))
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 92, height: 92)
                        .cornerRadius(26)
                    
                    Text("일상 탈퇴 전 확인하세요!")
                        .foregroundColor(.black)
                        .padding(.bottom, 11)

                    Text("탈퇴하시면 모든 데이터는 복구가 불가능합니다.")
                        .foregroundColor(Color.gray400)
                        .padding(.bottom, 35)

                    
                    Text("• 진행 및 완료된 모든 퀘스트 내용이 삭제됩니다.\n• 사장님이 관리하는 단골 데이터에서 삭제됩니다.")
                        .foregroundColor(Color.gray400)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 15)
                        .background(Rectangle().foregroundColor(.gray100))
                        .cornerRadius(12)
                    
                    Spacer()
         
                    Button {
                        isChecked.toggle()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .scaledToFit()
                            Text("안내사항을 모두 확인하였으며, 이에 동의합니다.")
                                .foregroundColor(Color.gray400)
                        }
                    }
                    .padding(.bottom, 20)
                
                    Button {
                        print("pushed")
                        delAlert.toggle()
                    } label: {
                        Text("탈퇴하기")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(isChecked ? Color.accentColor : Color.gray300)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20).padding(.bottom, 42)
                    .disabled(!isChecked)
                    .alert(Text("회원탈퇴에 실패했습니다"), isPresented: $showErrorAlert) {
                        Button("확인") {
                            showErrorAlert.toggle()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    DeleteAccountView()
}
