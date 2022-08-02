//
//  CurrencyConverter.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

struct CurrencyConverter: Codable {
    let request: Request
    let meta: Meta
    let response: Double
}

struct Meta: Codable {
    let timestamp: Int
    let rate: Double
}

struct Request: Codable {
    let query: String
    let amount: String
    let from: String
    let to: String
}
