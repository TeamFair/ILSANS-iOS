//
//  TermsAndPolicyView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI
import PDFKit

struct TermsAndPolicyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isToggle: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "약관 및 정책", isSeparatorHidden: true) {
                dismiss()
            }
            
            List {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("서비스 이용약관")
                            .foregroundColor(.gray500)

                        Text("2024.02.01")
                            .foregroundColor(.gray300)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isToggle.toggle()
                        }
                    } label: {
                        Image(systemName: isToggle ? "chevron.down" : "chevron.up")
                            .foregroundColor(Color.gray200)
                    }
                }
                .frame(height: 48)
                
                if isToggle {
                    Text(contract)
                        .font(Font.custom("Pretendard", size: 15))
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
        }
        .background(Color.background)
        .navigationBarBackButtonHidden()
    }
}

//내부 PDF를 뷰로 변경
struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
    }
}

#Preview {
    TermsAndPolicyView()
}
