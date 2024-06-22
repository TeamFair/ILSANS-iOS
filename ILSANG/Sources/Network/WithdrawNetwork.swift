//
//  WithdrawNetwork.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/22/24.
//

import Foundation
import Alamofire

final class WithdrawNetwork {
    private let url = APIManager.makeURL(CustomerTarget(path: "withdraw"))
    
    func getWithdraw() async -> Result<Withdraw, Error> {
        
        return await Network.requestData(url: url, method: .get, parameters: nil, withToken: true)
    }
    
    func postWithdraw() {}
    
    func deletewithdraw() {}
    
}
