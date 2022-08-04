//
//  CurrencyConverterService.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation

protocol CurrencyConverterServiceable {
    func convert(id: String, details: ConversionDetail) async -> Result<CurrencyConverter, RequestError>
}

struct CurrencyConverterService: HTTPClient, CurrencyConverterServiceable {

    func convert(id: String, details: ConversionDetail) async -> Result<CurrencyConverter, RequestError> {
        
        return await sendRequest(endpoint: CurrencyConverterAPI.convert(id: id, value: details.value, from: details.fromCurrencyType, to: details
            .toCurrencyType), type: CurrencyConverter.self)
    }
    
}
