//
//  EndPoint.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var scheme: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var header: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "openexchangerates.org"
    }
}
