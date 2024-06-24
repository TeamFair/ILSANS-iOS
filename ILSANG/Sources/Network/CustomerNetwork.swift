//
//  CustomerNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class CustomerNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "user"))
    
    func getCustomer() async -> Result<CustomerModel,Error> {
        return await Network.requestData(url: url, method: .get, parameters: nil, withToken: true)
    }
    
    func putCustomer(nickname: String) async -> Result<CustomerModel,Error> {
        let parameters: Parameters = ["nickname": nickname]
        return await Network.requestData(url: url, method: .put, parameters: parameters, withToken: true)
    }
    
    func deleteCustomer() {}
    
}
