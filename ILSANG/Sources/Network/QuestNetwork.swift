//
//  QuestNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/2/24.
//

import Foundation
import Alamofire

final class QuestNetwork {
    private let UncompletedUrl: String
    private let CompletedUrl: String
    
    init(UncompletedUrl: String = APIManager.makeURL(CustomerTarget(path: "")), CompletedUrl: String = APIManager.makeURL(CustomerTarget(path: ""))) {
        self.UncompletedUrl = UncompletedUrl
        self.CompletedUrl = CompletedUrl
    }
    
    //미완료 Quest
    func getUncompletedQuest(page: Int) async ->  Result<AWSQuest, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: UncompletedUrl+"uncompletedQuest", method: .get, parameters: parameters, withToken: true)
    }
    
    //완료 Quest
    func getCompletedQuest(page: Int) async ->  Result<AWSQuest, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: CompletedUrl+"completedQuest", method: .get, parameters: parameters, withToken: true)
    }
}
