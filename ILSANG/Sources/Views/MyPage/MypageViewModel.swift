//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import Foundation

class MypageViewModel: ObservableObject {
    @Published var CustomerData: Customer?
    
    private let customerNetwork: CustomerNetwork
    
    init(CustomerData: Customer? = nil, customerNetwork: CustomerNetwork) {
        self.CustomerData = CustomerData
        self.customerNetwork = customerNetwork
    }
    
    @MainActor
    func getCustomer() async {
        let res = await customerNetwork.getCustomer()
        
        switch res {
        case .success(let model):
            self.CustomerData = model.data
            Log(model.data)
            
        case .failure:
            self.CustomerData = nil
        }
    }
}

struct MypageViewModelItem: Identifiable {
    var id: UUID
    var status: String
    var nickname: String
    var couponCount: Int
    var completeChallengeCount: Int
    var xpPoint: Int
}
