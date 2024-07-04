//
//  ChallengeNetwork.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Alamofire
import Foundation

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
    
    func getChallenges(page: Int) async -> Result<ResponseWithPage<[Challenge]>, Error> {
        let parameters: Parameters = ["userDataOnly": true, "page": page, "size": "10"]
        return await Network.requestData(url: url+"challenge", method: .get, parameters: parameters, withToken: true)
    }
    
    func postChallenge(questId: String, imageId: String) async -> Result<ResponseWithEmpty, Error> {
        let bodyData: [String: Any] = [
            "questId": questId,
            "receiptImageId": imageId
        ]
        
        guard let jsonData = convertToJsonData(dictionary: bodyData) else {
            return .failure(NetworkError.requestFailed("Fail to convert data"))
        }
        return await Network.requestData(url: url+"challenge", method: .post, parameters: nil, body: jsonData, withToken: true)
    }
    
    /// Dictionary를 JSON 데이터로 변환하는 함수
    func convertToJsonData(dictionary: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return jsonData
        } catch {
            print("JSON Convert Error: \(error.localizedDescription)")
            return nil
        }
    }
}
