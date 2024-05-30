//
//  TermsAndPolicyView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI
import PDFKit

struct TermsAndPolicyView: View {
    
    let pdfUrl = Bundle.main.url(forResource: "24.06_일상_이용약관", withExtension: "pdf")!
    
    var body: some View {
        NavigationView {
            PDFKitView(url: pdfUrl)
        }
        .navigationTitle("약관 및 정책")
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
