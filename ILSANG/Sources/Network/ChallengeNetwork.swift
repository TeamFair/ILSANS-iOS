//
//  ChallengeNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Alamofire

final class ChallengeNetwork {
    private let network: Network
    private let url: String

    init(network: Network = Network(), url: String =  APIManager.makeURL(CustomerTarget(path: ""))) {
        self.network = network
        self.url = url
    }
    
    func getRandomChallenges(page: Int) async -> Result<RandomChallengeList, Error> {
        let parameters: Parameters = ["page": page, "size": "10"]
        return await Network.requestData(url: url+"randomChallenge", method: .get, parameters: parameters, withToken: true)
    }
    
    func postChallenge(questId: String, imageId: String) async -> Bool {
       return true
    }
    
    func getChallenges(page: Int) async -> Result<ResponseWithPage<[Challenge]>, Error> {
        let parameters: Parameters = ["userDataOnly": true, "page": page, "size": "10"]
        return await Network.requestData(url: url+"challenge", method: .get, parameters: parameters, withToken: true)
    }
}
