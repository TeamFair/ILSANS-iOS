//
//  SubmitRouterView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/29/24.
//

import SwiftUI
import Photos

struct SubmitRouterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showPhotoLibraryAlert = false
    @State var selectedImage: Image?
    
    let selectedQuestId: String
    
    var body: some View {
        Group {
            if let myImage = selectedImage {
                myImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 90)
                    .overlay(alignment: .bottom) {
                        buttonView
                    }
                    .ignoresSafeArea(edges: .bottom)
            } else {
                CameraView(selectedImage: $selectedImage)
            }
        }
        .background(Color.white)
    }
}

extension SubmitRouterView {
    private var buttonView: some View {
        HStack(spacing: 12) {
            Button {
                selectedImage = nil
            } label: {
                Text("다시찍기")
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray400)
            .background(Color.gray100)
            .cornerRadius(12)
            
            PrimaryButton(title: "제출하기") {
                Task { await submitImage() }
            }
        }
        .padding([.bottom,.horizontal], 20)
        .frame(height: 110)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
    }
    
    private func submitImage() async {
        // TODO: 에러처리 및 SubmitAlertView 띄우기
        guard let selectedImage = selectedImage else { return }
        Task {
            await postChallengeWithImage(selectedImage)
            dismiss()
        }
    }

    private func postChallengeWithImage(_ selectedImage: Image) async {
        // TODO: 퀘스트 인증 이미지 POST
    }
}
