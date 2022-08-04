//
//  MockCredentialsValidator.swift
//  PenquinPayTests
//
//  Created by Reshma Unnikrishnan on 04.08.22.
//

import Foundation
@testable import PenquinPay

final class MockCredentialsValidator: CredentialsValidatorProtocol {
  
    
    // MARK: - validateCredentials
    var validateCredentialsCalled = false
    var validateCredentialsClosure: ((@escaping (Result<(), PhoneNumberError>) -> Void) -> Void)?
    
    func validateCredentials(phoneNumber: String, country: String, completion: @escaping (Result<(), PhoneNumberError>) -> Void) {
        
        validateCredentialsCalled = true
        validateCredentialsClosure?(completion)
    }
}
