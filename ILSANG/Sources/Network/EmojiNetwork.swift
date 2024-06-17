//
//  EmojiNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/16/24.
//

import Alamofire

final class EmojiNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "emoji/"))
    
    func getEmoji(challengeId: String) async -> Result<EmojiModel,Error> {
        let parameters: Parameters = ["challengeId": challengeId]
        return await Network.requestData(url: url + "{challengeId}", method: .get, parameters: parameters, withToken: true)
    }
    
    func postEmoji() {
        
    }
    
    func deleteEmoji() {
        
    }
}
