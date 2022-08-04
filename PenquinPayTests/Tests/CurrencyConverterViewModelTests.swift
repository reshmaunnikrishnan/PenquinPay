//
//  CurrencyConversionViewModelTests.swift
//  PenquinPayTests
//
//  Created by Reshma Unnikrishnan on 04.08.22.
//

import Foundation
import XCTest
import Combine
@testable import PenquinPay

class CurrencyConverterViewModelTests: XCTestCase {

    private var subject: CurrencyConverterViewModel!
    private var mockService: MockCurrencyConvertService!
    private var mockValidator: MockCredentialsValidator!
    private var cancellables: Set<AnyCancellable> = []
    
    
    override func setUp() {
        super.setUp()

        mockService = MockCurrencyConvertService()
        mockValidator = MockCredentialsValidator()
        subject = CurrencyConverterViewModel(currencyConverterService: mockService, credentialsValidator: mockValidator)
    }
    
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockService = nil
        mockValidator = nil
        subject = nil

        super.tearDown()
    }
    
    func testGetMinimumDigitsForPhoneNumber_shouldNotCallService() {
           // when
            let digit =  subject.getMinimumDigits(for: "Kenya")

           // then
           XCTAssertEqual(digit, 9)
           XCTAssertEqual(mockService.getCallsCount, 0)
       }
    
    func testConvertCurrencyValue_shouldCallService()  {
        //given
        subject.moneyToSend = "1"
        subject.recipeintCurrencyType = "KES"
        
        let expectation = expectation(description: "test")
        
        // when
        subject.convertCurrencyValue{
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)

        // then
        XCTAssertEqual(mockService.getCallsCount, 1)
        XCTAssertEqual(mockService.getArguments, ["KES"])
    }
    
    func testConvertCurrencyValueGivenServiceCallSucceedsShouldConversionData() {
            // given
        mockService.getResult = .success(Constants.conversion)
            subject.moneyToSend = "1"
            subject.recipeintCurrencyType = "KES"
            let expectation = expectation(description: "test")

            // when
            subject.convertCurrencyValue {
            expectation.fulfill()
            }

            waitForExpectations(timeout: 3)

            // then
            XCTAssertEqual(mockService.getCallsCount, 1)
            subject.$conversionResponse
            .sink { XCTAssertEqual($0, Constants.conversion) }
                .store(in: &cancellables)

            subject.$state
                .sink { XCTAssertEqual($0, .finishedLoading) }
                .store(in: &cancellables)
        }
}

// MARK: - Helpers
extension CurrencyConverterViewModelTests {
    enum Constants {
        static let conversion =
            CurrencyConverter(timestamp: 123, base: "1bacc", rates: ["AED": 3.67302,
                                                                                    "AFN": 90.692242,
                                                                                    "ALL": 115.078526,
                                                                                    "AMD": 406.806873,
                                                                                    "ANG": 1.806306,
                                                                                    "AOA": 431.5918,
                                                                                    "ARS": 132.395518,
                                                                                    "AUD": 1.433155,
                                                                                    "AWG": 1.795,
                                                                                    "AZN": 1.7,
                                                                                    "BAM": 1.92395,
                                                                                    "BBD": 2,
                                                                                    "BDT": 94.936016,
                                                                                    "BGN": 1.91952,
                                                                                    "BHD": 0.376968,
                                                                                    "BIF": 2065.462239,
                                                                                    "BMD": 1,
                                                                                    "BND": 1.383869,
                                                                                    "BOB": 6.890327,
                                                                                    "BRL": 5.2839,
                                                                                    "BSD": 1,
                                                                                    "BTC": 0.000043724472,
                                                                                    "BTN": 79.292834,
                                                                                    "BWP": 12.638729,
                                                                                    "BYN": 2.529621,
                                                                                    "BZD": 2.019073,
                                                                                    "CAD": 1.28345,
                                                                                    "CDF": 2003.507237,
                                                                                    "CHF": 0.959723,
                                                                                    "CLF": 0.033038,
                                                                                    "CLP": 911.62,
                                                                                    "CNH": 6.767577,
                                                                                    "CNY": 6.7588,
                                                                                    "COP": 4323.852958,
                                                                                    "CRC": 669.73632,
                                                                                    "CUC": 1,
                                                                                    "CUP": 25.75,
                                                                                    "CVE": 109.24,
                                                                                    "CZK": 24.196299,
                                                                                    "DJF": 178.416503,
                                                                                    "DKK": 7.305277,
                                                                                    "DOP": 54.603217,
                                                                                    "DZD": 145.49694,
                                                                                    "EGP": 19.1103,
                                                                                    "ERN": 15,
                                                                                    "ETB": 52.754557,
                                                                                    "EUR": 0.981509,
                                                                                    "FJD": 2.1892,
                                                                                    "FKP": 0.821053,
                                                                                    "GBP": 0.821053,
                                                                                    "GEL": 2.735,
                                                                                    "GGP": 0.821053,
                                                                                    "GHS": 8.669123,
                                                                                    "GIP": 0.821053,
                                                                                    "GMD": 54.775,
                                                                                    "GNF": 8667.301255,
                                                                                    "GTQ": 7.752207,
                                                                                    "GYD": 209.790637,
                                                                                    "HKD": 7.849795,
                                                                                    "HNL": 24.658059,
                                                                                    "HRK": 7.3754,
                                                                                    "HTG": 119.767637,
                                                                                    "HUF": 388.962,
                                                                                    "IDR": 14925.086567,
                                                                                    "ILS": 3.353033,
                                                                                    "IMP": 0.821053,
                                                                                    "INR": 79.483755,
                                                                                    "IQD": 1462.774087,
                                                                                    "IRR": 42350,
                                                                                    "ISK": 136.53,
                                                                                    "JEP": 0.821053,
                                                                                    "JMD": 153.33022,
                                                                                    "JOD": 0.709,
                                                                                    "JPY": 134.115,
                                                                                    "KES": 119.2,
                                                                                    "KGS": 83.155852,
                                                                                    "KHR": 4110.140896,
                                                                                    "KMF": 485.499932,
                                                                                    "KPW": 900,
                                                                                    "KRW": 1309.308802,
                                                                                    "KWD": 0.306756,
                                                                                    "KYD": 0.835161,
                                                                                    "KZT": 475.914137,
                                                                                    "LAK": 15238.664247,
                                                                                    "LBP": 1515.551338,
                                                                                    "LKR": 357.774131,
                                                                                    "LRD": 153.549975,
                                                                                    "LSL": 16.78589,
                                                                                    "LYD": 4.861943,
                                                                                    "MAD": 10.312718,
                                                                                    "MDL": 19.29951,
                                                                                    "MGA": 4216.604813,
                                                                                    "MKD": 60.610678,
                                                                                    "MMK": 1855.554715,
                                                                                    "MNT": 3167.584996,
                                                                                    "MOP": 8.103426,
                                                                                    "MRU": 37.684869,
                                                                                    "MUR": 45.544836,
                                                                                    "MVR": 15.4,
                                                                                    "MWK": 1028.71431,
                                                                                    "MXN": 20.427187,
                                                                                    "MYR": 4.458,
                                                                                    "MZN": 63.850001,
                                                                                    "NAD": 16.72,
                                                                                    "NGN": 415.928407,
                                                                                    "NIO": 35.985085,
                                                                                    "NOK": 9.711233,
                                                                                    "NPR": 126.862901,
                                                                                    "NZD": 1.58532,
                                                                                    "OMR": 0.385011,
                                                                                    "PAB": 1,
                                                                                    "PEN": 3.938637,
                                                                                    "PGK": 3.531292,
                                                                                    "PHP": 55.676999,
                                                                                    "PKR": 228.261956,
                                                                                    "PLN": 4.6337,
                                                                                    "PYG": 6878.539281,
                                                                                    "QAR": 3.641,
                                                                                    "RON": 4.835,
                                                                                    "RSD": 115.19379,
                                                                                    "RUB": 60.174996,
                                                                                    "RWF": 1029,
                                                                                    "SAR": 3.757772,
                                                                                    "SBD": 8.244163,
                                                                                    "SCR": 12.794342,
                                                                                    "SDG": 456.5,
                                                                                    "SEK": 10.179594,
                                                                                    "SGD": 1.379196,
                                                                                    "SHP": 0.821053,
                                                                                    "SLL": 13748.9,
                                                                                    "SOS": 569.737327,
                                                                                    "SRD": 24.5725,
                                                                                    "SSP": 130.26,
                                                                                    "STD": 22183.790504,
                                                                                    "STN": 24.35,
                                                                                    "SVC": 8.769686,
                                                                                    "SYP": 2512.53,
                                                                                    "SZL": 16.786484,
                                                                                    "THB": 36.032,
                                                                                    "TJS": 10.267786,
                                                                                    "TMT": 3.5,
                                                                                    "TND": 3.1685,
                                                                                    "TOP": 2.340141,
                                                                                    "TRY": 17.965335,
                                                                                    "TTD": 6.802286,
                                                                                    "TWD": 30.0158,
                                                                                    "TZS": 2332,
                                                                                    "UAH": 36.834097,
                                                                                    "UGX": 3889.078206,
                                                                                    "USD": 1,
                                                                                    "UYU": 41.031651,
                                                                                    "UZS": 10966.890325,
                                                                                    "VES": 5.7903,
                                                                                    "VND": 23397.287196,
                                                                                    "VUV": 117.973513,
                                                                                    "WST": 2.705195,
                                                                                    "XAF": 643.827408,
                                                                                    "XAG": 0.04943032,
                                                                                    "XAU": 0.00056188,
                                                                                    "XCD": 2.70255,
                                                                                    "XDR": 0.734326,
                                                                                    "XOF": 643.827408,
                                                                                    "XPD": 0.00048557,
                                                                                    "XPF": 117.125126,
                                                                                    "XPT": 0.0010953,
                                                                                    "YER": 250.250057,
                                                                                    "ZAR": 16.785113,
                                                                                    "ZMW": 16.069997,
                                                                                    "ZWL": 322] )
    }
}

