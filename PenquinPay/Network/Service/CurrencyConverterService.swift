//
//  CurrencyConverterService.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

protocol CurrencyConverterServiceable {
    func convert(id: String, value: String, from: String, to: String) async -> Result<CurrencyConverter, RequestError>
}


struct CurrencyConverterService: HTTPClient, CurrencyConverterServiceable {

    
    func convert(id: String, value: String, from: String, to: String) async -> Result<CurrencyConverter, RequestError> {
        
        return await sendRequest(endpoint: CurrencyConverterAPI.convert(id: id, value: value, from: from, to: to), type: CurrencyConverter.self)
    }
    
}
