//
//  APITarget.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/16/24.
//

protocol APITarget {
    var type: String { get }
    var path: String { get }
}

final class OpenTarget: APITarget {
    let type = "open"
    var path: String
    
    init(path: String) {
        self.path = path
    }
}

final class CustomerTarget: APITarget {
    let type = "customer"
    var path: String
    
    init(path: String) {
        self.path = path
    }
}
