//
//  CurrencyConverterViewModel.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 02.08.22.
//

import Foundation
import Combine
import SwiftUI

enum ConverterViewModelState: Equatable {
    case loading
    case finishedLoading
    case error
}

enum PhoneNumberError: Error {
    case invalid
}

final class CurrencyConverterViewModel {
    // MARK: - Properties
    @Published private(set) var state: ConverterViewModelState = .loading
    @Published private(set) var conversionResponse: CurrencyConverter?
    
    @Published var country: String = ""
    @Published var phoneNumber: String = ""
    @Published var phoneNumberStatus: String = ""
    @Published var moneyToSend: String = ""
    @Published var recipeintCurrencyType: String = ""

    let validationResult = PassthroughSubject<Void, Error>()
    
    internal let currencyConverterService: CurrencyConverterServiceable
    private var bindings = Set<AnyCancellable>()
    private var currentConversionQuery: String = " "
    private let credentialsValidator: CredentialsValidatorProtocol

    // MARK: - Initilaizer
    init(currencyConverterService: CurrencyConverterServiceable = CurrencyConverterService(), credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
        self.currencyConverterService = currencyConverterService
        self.credentialsValidator = credentialsValidator
    }
    
    // MARK: - Methods
    func getMinimumDigits(for place: String) -> Int {
        let country = Country.allCases.filter{$0.rawValue == place}.first
        guard let country = country else {return 0}
        let number = country.getNumberOfDigitsAfterPrefix()
        return number
    }
    
    func convertCurrencyValue(completion: @escaping () -> Void) {
        let localCurrency = localCurrency()
        let integerMoney = moneyToSend.binaryToInt

        if recipeintCurrencyType.isEmpty || moneyToSend.isEmpty {
            return
        }
        
        let detail = ConversionDetail(fromCurrencyType: localCurrency , toCurrencyType: recipeintCurrencyType, value: integerMoney)
        fetchData(data: detail) {[weak self] result in
            guard let self = self else { return }
            switch result {
              case .failure(let error):
                print(error)
                self.state = .error
              case .success(let response):
                self.conversionResponse = response
                self.state = .finishedLoading
                completion()
            }
        }
    }
    
    func binaryRecipientValue() -> String {
        let value = self.conversionResponse?.rates.filter{ $0.key == recipeintCurrencyType }
        let doubleMoney = moneyToSend.binaryToDouble

        let generatedAmount = Double(value?.first?.value ?? 0) * doubleMoney
        let generatedAmountInteger = Int(generatedAmount)
        let binaryAmount = generatedAmountInteger.binaryString
        return binaryAmount
    }
    
    func localCurrency() -> String {
        let locale = Locale.current
        let localCurrencySymbol = locale.currencyCode!
        return localCurrencySymbol
    }
    
     func fetchData(data: ConversionDetail, completion: @escaping (Result<CurrencyConverter, RequestError>) -> Void) {
        Task(priority: .background) {
            let id = "cd9bc7a433ee48c0b97db5ba76ae1705"
            let result = await currencyConverterService.convert(id: id, details: data)
            completion(result)
        }
    }
}

// MARK: - CredentialsValidatorProtocol

protocol CredentialsValidatorProtocol {
    func validateCredentials(phoneNumber: String, country: String, completion: @escaping (Result<(), PhoneNumberError>) -> Void)
}

/// This class acts as an example of asynchronous credentials validation

final class CredentialsValidator: CredentialsValidatorProtocol {
    
    func validateCredentials(phoneNumber: String, country: String, completion: @escaping (Result<(), PhoneNumberError>) -> Void) {
        
        let country =  Country.allCases.filter{$0.rawValue == country}.first
        
        if  phoneNumber.count == country?.getNumberOfDigitsAfterPrefix() {
            completion(.success(()))
        } else {
            completion(.failure(.invalid))
        }
    }
    
}
