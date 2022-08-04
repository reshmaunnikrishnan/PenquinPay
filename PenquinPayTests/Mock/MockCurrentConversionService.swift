//
//  MockCurrentConversionService.swift
//  PenquinPayTests
//
//  Created by Reshma Unnikrishnan on 04.08.22.
//

import Foundation
import Combine
@testable import PenquinPay

final class MockCurrencyConvertService: CurrencyConverterServiceable {
    var getArguments: [String?] = []
    var getCallsCount: Int = 0
    var getResult: Result<CurrencyConverter, RequestError> = .success(CurrencyConverter(timestamp: 123, base: "abcd", rates: [:]))

    func convert(id: String, details: ConversionDetail) async -> Result<CurrencyConverter, RequestError> {
        getArguments.append(details.toCurrencyType)
        getCallsCount += 1
        return getResult
    }
    
}
