//
//  CurrencyConverterViewController.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 03.08.22.
//

import UIKit
import Combine

final class CurrencyConverterViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var countryDropDown: DropDownView!
    @IBOutlet weak var sendMoneyText: UITextField!
    @IBOutlet weak var recieveMoneyText: UITextField!
    @IBOutlet weak var phoneNumberStatusLabel: UILabel!
    @IBOutlet weak var localCurrencyTypeButton: UIButton!
    @IBOutlet weak var recipientCurrencyTypeField: DropDownView!
    @IBOutlet weak var sendButton: UIButton!
    
    var viewModel: CurrencyConverterViewModel
    private var bindings = Set<AnyCancellable>()

    //MARK: - Initializers
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func sendMoneyButtonTapped(_ sender: Any) {
        let resultVC = ResultViewController()
        self.present(resultVC, animated: true)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDown()
        setUpBindings()
        setupUI()
    }

    //MARK: - Private Methods
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
            
            self.sendMoneyText.textPublisher
                .sink { val in
                    if !val.isEmpty {
                        self.viewModel.convertCurrencyValue{ 
                            print("conversion successfull")
                        }
                    }
                }.store(in: &bindings)
            
            self.phoneNumberText.textPublisher
                .sink { val in
                    let count  = self.viewModel.getMinimumDigits(for: self.countryDropDown.text ?? "")
                    if val.count > count {
                        self.phoneNumberStatusLabel.text = "Invalid phone number. More than \(count.description) digits"
                        self.phoneNumberStatusLabel.textColor = .red
                    } else {
                        self.phoneNumberStatusLabel.text = "Requires \(count.description) digits"
                        self.phoneNumberStatusLabel.textColor = .gray
                    }
                }.store(in: &bindings)
            
        }
        
        func bindViewModelToView(){
          
            viewModel.$phoneNumberStatus
                           .receive(on: RunLoop.main)
                           .sink(receiveValue: { [weak self] val in
                               self?.phoneNumberStatusLabel.text = val
                                           })
                           .store(in: &bindings)
            
            
            let stateValueHandler: (ConverterViewModelState) -> Void = { [weak self] state in
                           switch state {
                           case .error:
                               self?.showError()
                           case .finishedLoading:
                               self?.recieveMoneyText.text = self?.viewModel.binaryRecipientValue()
                               self?.sendButton.isEnabled = true
                               self?.sendButton.alpha = 1.0
                           default: break
                           }
                       }
            
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
                       
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    private func setupUI() {
        phoneNumberText.textContentType = .telephoneNumber
        self.phoneNumberStatusLabel.numberOfLines = 0
        localCurrencyTypeButton.setTitle(viewModel.localCurrency(), for: .normal)
        localCurrencyTypeButton.isSelected = false
        sendButton.isEnabled = false
        sendButton.alpha = 0.3
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
                
                let count  = self.viewModel.getMinimumDigits(for: selectedText)
                    self.phoneNumberStatusLabel.text = "Requires \(count.description) digits"
                    self.phoneNumberStatusLabel.textColor = .gray
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
                self.viewModel.convertCurrencyValue {
                    print("convesion successfull")
                }
            }
        }

    }
    
    func showError() {
        let alert = UIAlertController(title: "Failed Request", message: "Some Technical issues. Please try again!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: { (_) in
             }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

