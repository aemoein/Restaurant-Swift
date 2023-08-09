//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Ahmed Elsayed on 09/08/2023.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    let category: String
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
