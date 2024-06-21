//
//  CustomerNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation
import Alamofire

final class CustomerNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "user/"))
    
    func getCustomer(userId: String) async -> Result<CustomerModel,Error> {
        let parameters: Parameters = ["userId": userId]
        return await Network.requestData(url: url + userId, method: .get, parameters: parameters, withToken: true)
    }
    
    func putCustomer() {
        
    }
    
    func deleteCustomer() {
        
    }
    
}
