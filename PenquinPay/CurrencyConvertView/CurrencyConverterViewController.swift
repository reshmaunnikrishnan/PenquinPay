//
//  CurrencyConverterViewController.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 03.08.22.
//

import UIKit
import Combine
import iOSDropDown

final class CurrencyConverterViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var countryDropDown: DropDownView!
    @IBOutlet weak var sendMoneyText: UITextField!
    @IBOutlet weak var recieveMoneyText: UITextField!
    @IBOutlet weak var phoneNumberStatusLabel: UILabel!
    @IBOutlet weak var localCurrencyTypeButton: UIButton!
    @IBOutlet weak var recipientCurrencyTypeField: DropDownView!
    
    var viewModel: CurrencyConverterViewModel
    private var bindings = Set<AnyCancellable>()

    //MARK:- Initializers
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func conversionTapped(_ sender: Any) {
        viewModel.convertCurrencyValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        setUpBindings()
        phoneNumberText.textContentType = .telephoneNumber
        self.phoneNumberStatusLabel.numberOfLines = 0
        localCurrencyTypeButton.setTitle(viewModel.localCurrency(), for: .normal)
    }

    //MARK:- Private Methods
    private func setUpBindings() {
        
        func bindViewToViewModel() {
        
            self.countryDropDown.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.country, on: viewModel)
                .store(in: &bindings)
            
            self.phoneNumberText.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.phoneNumber, on:viewModel )
                .store(in: &bindings)
            
            self.sendMoneyText.textPublisher
                .receive(on: RunLoop.main).assign(to: \.moneyToSend, on:viewModel )
                .store(in: &bindings)
            
            
            self.phoneNumberText.textPublisher
                .sink { val in
                    let count  = self.viewModel.getMinimumDigits(for: self.countryDropDown.text ?? "")
                    if val.count > count {
                        self.phoneNumberStatusLabel.text = "Invalid phone number. More than \(count.description)"
                        self.phoneNumberStatusLabel.textColor = .red
                    } else {
                        self.phoneNumberStatusLabel.text = "Requires \(count.description) digits"
                        self.phoneNumberStatusLabel.textColor = .gray
                    }
                }.store(in: &bindings)
            
        }
        
        func bindViewModelToView() {
          
            viewModel.$phoneNumberStatus
                           .receive(on: RunLoop.main)
                           .sink(receiveValue: { [weak self] val in
                               self?.phoneNumberStatusLabel.text = val
                                           })
                           .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }

    private func setupDropDown() {
        countryDropDown.placeholder = "Country"

        // The list of array to display. Can be changed dynamically
        countryDropDown.optionArray = Country.allCases.map {
            $0.rawValue
        }
        
        // Its Id Values and its optional
        countryDropDown.optionIds = [1,2,3,4]
     
        DispatchQueue.main.async {
            
            self.countryDropDown.didSelect{(selectedText , index ,id) in
                let prefix = UILabel()
                prefix.text = Country.allValues.filter{$0.rawValue == selectedText}.map{ return $0.getPhonePrefix()}.first
                // set font, color etc.
                prefix.sizeToFit()
                
                self.phoneNumberText.leftView = prefix
                self.phoneNumberText.leftViewMode = .whileEditing // or .always
                
            }
        }
        
        recipientCurrencyTypeField.placeholder = "Currency"
        recipientCurrencyTypeField.textAlignment = .center


        // The list of array to display. Can be changed dynamically
        recipientCurrencyTypeField.optionArray = Country.allCases.map {
            $0.getCurrencyAbbrevation()
        }
        
        // Its Id Values and its optional
        recipientCurrencyTypeField.optionIds = [1,2,3,4]
     
        DispatchQueue.main.async {
            
            self.recipientCurrencyTypeField.didSelect{(selectedText , index ,id) in
                self.viewModel.recipeintCurrencyType = selectedText
            }
        }
        

    }
    
}

extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return binaryString
    }
}

