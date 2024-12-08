//
//  QuestNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/2/24.
//

import Foundation
import Alamofire

final class QuestNetwork {
    
    private let questUrl: String
    
    init(questUrl: String = APIManager.makeURL(CustomerTarget(path: ""))) {
        self.questUrl = questUrl
    }
    
    func getDefaultQuest(page: Int, size: Int) async -> Result<ResponseWithPage<[Quest]>, Error> {
        let parameters: Parameters = ["page": page, "size": size]
        return await Network.requestData(url: questUrl+"uncompletedQuest", method: .get, parameters: parameters, withToken: true)
    } 
    
    func getRepeatQuest(status: RepeatType, page: Int, size: Int) async -> Result<ResponseWithPage<[Quest]>, Error> {
        let parameters: Parameters = ["status": status.toParam(), "page": page, "size": size]
        return await Network.requestData(url: questUrl+"uncompletedRepeatQuest", method: .get, parameters: parameters, withToken: true)
    }
    
    func getCompletedQuest(page: Int, size: Int) async -> Result<ResponseWithPage<[Quest]>, Error> {
        let parameters: Parameters = ["page": page, "size": size]
        return await Network.requestData(url: questUrl+"completedQuest", method: .get, parameters: parameters, withToken: true)
    }
}
