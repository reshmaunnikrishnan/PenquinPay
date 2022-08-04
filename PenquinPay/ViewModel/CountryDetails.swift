//
//  Count.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 04.08.22.
//

import Foundation

enum Country: String, CaseIterable {
    case Kenya
    case Nigeria
    case Tanzania
    case Uganda
    
    static let allValues = [Kenya, Nigeria, Tanzania, Uganda]

}

extension Country {
    func getCurrencyAbbrevation() -> String {
        switch self {
        case .Kenya:
            return "KES"
        case .Nigeria:
            return "NGN"
        case .Tanzania:
            return "TZS"
        case .Uganda:
            return "UGX"
        }
    }
    
    func getPhonePrefix() -> String {
        switch self {
        case .Kenya: return "+254"
        case .Nigeria: return "+234"
        case .Tanzania: return "+255"
        case .Uganda: return "+256"
        }
    }
    
    func getNumberOfDigitsAfterPrefix() -> Int {
        switch self {
        case .Kenya, .Tanzania: return 9
        case .Nigeria, .Uganda: return 7
        }
    }
    
}
