//
//  ImageNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/20/24.
//

import Alamofire
import UIKit

final class ImageNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "image/"))
    
    func getImage(imageId: String) async -> Result<UIImage,Error> {
        let url = url + imageId
        return await Network.requestImage(url: url, withToken: true)
    }
    
    func postImage() {
        
    }
}
