//
//  ResultViewController.swift
//  PenquinPay
//
//  Created by Reshma Unnikrishnan on 04.08.22.
//

import UIKit

final class ResultViewController: UIViewController{
    
    // MARK: - Properties
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Result"
        self.titleLabel.textColor = .purple
    }
}
