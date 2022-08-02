//
//  CurrencyConverterAPI.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

enum CurrencyConverterAPI {
    case convert(id: String, value: String, from: String, to: String)
}

extension CurrencyConverterAPI: Endpoint {
    
    var path: String {
        switch self {
        case .convert(id: _ ,value: let value, from: let currrencyA, to: let currencyB):
            return "api/convert/\(value)/\(currrencyA)/\(currencyB)"
        }
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var headers: [String : String]? {
        switch self {
        case .convert(id: let api):
            return ["app_id": api.id,
                    "prettyprint" : "true"]
        }
    }
    
    var body: [String : String]? {
        return nil
    }
    
    
}
