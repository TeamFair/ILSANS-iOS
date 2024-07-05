//
//  QuestNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/2/24.
//

import Foundation
import Alamofire

final class QuestNetwork {
    private let uncompletedUrl: String
    private let completedUrl: String
    
    init(uncompletedUrl: String = APIManager.makeURL(CustomerTarget(path: "")), completedUrl: String = APIManager.makeURL(CustomerTarget(path: ""))) {
        self.uncompletedUrl = uncompletedUrl
        self.completedUrl = completedUrl
    }
    
    //미완료 Quest
    func getUncompletedQuest(page: Int) async ->  Result<AWSQuest, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: uncompletedUrl+"uncompletedQuest", method: .get, parameters: parameters, withToken: true)
    }
    
    //완료 Quest
    func getCompletedQuest(page: Int) async ->  Result<AWSQuest, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: completedUrl+"completedQuest", method: .get, parameters: parameters, withToken: true)
    }
}
