//
//  SubmitViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/27/24.
//

import SwiftUI

@MainActor
class SubmitRouterViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showSubmitAlertView: Bool = false

    let selectedQuestId: String
    
    init(selectedImage: UIImage? = nil, selectedQuestId: String) {
        self.selectedImage = selectedImage
        self.selectedQuestId = selectedQuestId
    }
    
    func clearSelectedImage() {
        self.showSubmitAlertView = false
        self.selectedImage = nil
    }
    
    func submit() {
        self.showSubmitAlertView = true
    }
}
