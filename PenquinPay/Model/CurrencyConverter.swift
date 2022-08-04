//
//  CurrencyConverter.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

struct CurrencyConverter: Decodable, Equatable {
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
