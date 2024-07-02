//
//  SubmitAlertViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/27/24.
//

import UIKit

class SubmitAlertViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var submitStatus: SubmitStatus = .submit
    @Published var showSubmitAlertView: Bool
    
    private let imageNetwork: ImageNetwork

    let selectedQuestId: String
    
    init(selectedImage: UIImage? = nil, selectedQuestId: String, imageNetwork: ImageNetwork, showSubmitAlertView: Bool) {
        self.selectedImage = selectedImage
        self.selectedQuestId = selectedQuestId
        self.imageNetwork = imageNetwork
        self.showSubmitAlertView = showSubmitAlertView
    }
    
    @MainActor
    func postChallengeWithImage() async {
        submitStatus = .submit

        // 이미지 POST
        guard let imageId = await postImage() else {
            submitStatus = .fail
            return
        }
        
        print(imageId)
        
        // 도전내역 POST
        let isPostChallengeSuccessful = await postChallenge(imageId: imageId)
        if isPostChallengeSuccessful {
            submitStatus = .complete
        } else {
            submitStatus = .fail
        }
    }
    
    private func postImage() async -> String? {
        guard let selectedImage = selectedImage else { return nil }
        let res = await imageNetwork.postImage(image: selectedImage)
        switch res {
        case .success(let success):
            return success.imageId
        case .failure:
            return nil
        }
    }
    
    private func postChallenge(imageId: String) async -> Bool {
        // TODO: 도전내역 POST API 연결
        return true
    }
}
