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

struct ConversionDetail {
    let fromCurrencyType: String
    let toCurrencyType: String
    let value: Int
}

protocol CurrencyConverterViewModelInput : AnyObject{
    var state: ConverterViewModelState {get}
    var conversionResponse: CurrencyConverter? {get}
    var currencyConverterService:CurrencyConverterServiceable {get}
    var country: String { get }
    var phoneNumber: String { get }
    var phoneNumberStatus: String { get }
    var validationResult :PassthroughSubject<Void, Error> { get }
    
    func convertValue(detail: ConversionDetail)
    func validateCredentials()
}



final class CurrencyConverterViewModel {
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

    init(currencyConverterService: CurrencyConverterServiceable = CurrencyConverterService(), credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
        self.currencyConverterService = currencyConverterService
        self.credentialsValidator = credentialsValidator
    }
    
    // MARK: Methods

    func getMinimumDigits(for place: String) -> Int {
        let country = Country.allCases.filter{$0.rawValue == place}.first
        guard let country = country else {return 0}
        let number = country.getNumberOfDigitsAfterPrefix()
        return number
    }

    
    func convertCurrencyValue() {
        let localCurrency = localCurrency()
        let integerMoney = moneyToSend.binaryToInt
        let detail = ConversionDetail(fromCurrencyType: localCurrency , toCurrencyType: recipeintCurrencyType, value: integerMoney)
        fetchData(data: detail) {[weak self] result in
            guard let self = self else { return }
            switch result {
              case .failure(let error):
                self.showErrorAlert(error: error)
                self.state = .error
              case .success(let response):
                self.conversionResponse = response
                self.state = .finishedLoading
            }
        }
    }
    
    func localCurrency() -> String {
        let locale = Locale.current
        let localCurrencySymbol = locale.currencyCode!
        return localCurrencySymbol
    }
    
    private func fetchData(data: ConversionDetail, completion: @escaping (Result<CurrencyConverter, RequestError>) -> Void) {
        Task(priority: .background) {
            let id = "cd9bc7a433ee48c0b97db5ba76ae1705"
            let result = await currencyConverterService.convert(id: id, details: data)
            completion(result)
        }
    }
    
    private func showErrorAlert(error: Error) {
        
    }
}


enum PhoneNumberError: Error {
    case invalid
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
