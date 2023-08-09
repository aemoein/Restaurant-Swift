//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Ahmed Elsayed on 09/08/2023.
//

import UIKit

@MainActor
class MenuItemDetailViewController: UIViewController {
    
    let menuItem: MenuItem
    
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
