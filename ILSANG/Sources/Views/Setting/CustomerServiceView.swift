//
//  CustomerServiceView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI

struct CustomerServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "고객센터") {
                dismiss()
            }
            
            List {
                NavigationLink {
                    //
                } label: {
                    Text("자주 묻는 질문")
                }
                
                Text("이메일주소: findtastyquest@gmail.com")
            }
            .listRowBackground(Color.white)
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CustomerServiceView()
}
