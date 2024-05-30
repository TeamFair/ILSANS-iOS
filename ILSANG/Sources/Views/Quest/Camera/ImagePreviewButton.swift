//
//  ImagePreviewButton.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/29/24.
//

import SwiftUI
import PhotosUI

struct ImagePreviewButton: View {
    private let imageSize = 50.0
    
    enum PreviewLoadState {
        case unknown, loading, loaded, failed
    }
    
    @State private var previewImage : UIImage?
    @State private var loadState = PreviewLoadState.unknown
    
    @State var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: Image?

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images,photoLibrary: .shared()) {
            switch loadState {
            case .loaded:
                if let previewImage = previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                        .cornerRadius(10)
                }
            case .loading:
                ProgressView()
            case .unknown, .failed:
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(.grayDD)
            }
        }
        .task {
            setPreviewImage()
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let image = try? await newItem?.loadTransferable(type: Image.self) {
                    selectedImage = image
                }
            }
        }
    }
    
    @MainActor
    private func setPreviewImage() {
        loadState = .loading

        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
            PHImageManager().requestImage(for: photo, targetSize: CGSize(width: imageSize, height: imageSize), contentMode: .aspectFill, options: .none) { image, _ in
                self.previewImage = image
                loadState = .loaded
            }
        } else {
            loadState = .failed
        }
    }
}

#Preview {
    ImagePreviewButton(selectedImage: .constant(Image(.arrowDown)))
}
