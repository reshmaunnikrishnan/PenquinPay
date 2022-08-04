//
//  CurrencyConverterAPI.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

enum CurrencyConverterAPI {
    case convert(id: String)
}

extension CurrencyConverterAPI: Endpoint {
    
    var path: String {
        switch self {
        case .convert:
            return "/api/latest.json"
        }
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .convert(id: let appId):
            return [URLQueryItem(name: "app_id", value: appId)]
        }
    }
    
    var header: [String: String]? {
         // Access Token to use in Bearer header
         
         switch self {
         case .convert:
             return [
                 "Content-Type": "application/json;charset=utf-8"
             ]
         }
     }
    
}
