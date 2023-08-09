//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Ahmed Elsayed on 09/08/2023.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet var confirmationLabel: UILabel!
    
    let minutesToPrepare: Int
    
        init?(coder: NSCoder, minutesToPrepare: Int) {
            self.minutesToPrepare = minutesToPrepare
            super.init(coder: coder)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(minutesToPrepare)
        
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
    
}
