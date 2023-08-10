//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Ahmed Elsayed on 09/08/2023.
//

import UIKit

class OrderTableViewController: UITableViewController {
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    override func tableView(_ tableView: UITableView,
       numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MenuController.shared.updateUserActivity(with: .order)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
       indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath:
       IndexPath) {
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        
        guard let cell = cell as? MenuItemCell else { return }
        
        cell.itemName = menuItem.name
        cell.price = menuItem.price
        cell.image = nil
        
        imageLoadTasks[indexPath] = Task.init {
            if let image = try? await
               MenuController.shared.fetchImage(from: menuItem.imageURL) {
                if let currentIndexPath = self.tableView.indexPath(for:
                   cell),
                      currentIndexPath == indexPath {
                    cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
                    let img = image.resizeImageWithHeight(newW: 60, newH: 40)
                    cell.image = img
                }
            }
            imageLoadTasks[indexPath] = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!,
           selector: #selector(UITableView.reloadData),
           name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    override func tableView(_ tableView: UITableView,
       canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
       commit editingStyle: UITableViewCell.EditingStyle,
       forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at:
               indexPath.row)
        }
    }
    
    var minutesToPrepareOrder = 0
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissConfirmation" {
                MenuController.shared.order.menuItems.removeAll()
            }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let orderTotal =
               MenuController.shared.order.menuItems.reduce(0.0)
               { (result, menuItem) -> Double in
                return result + menuItem.price
            }
        
            let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        
            let alertController = UIAlertController(title:
               "Confirm Order", message: "You are about to submit your order with a total of \(formattedTotal)", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in self.uploadOrder() }))
        
            alertController.addAction(UIAlertAction(title: "Cancel",
               style: .cancel, handler: nil))
        
            present(alertController, animated: true, completion: nil)
    }
    
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        Task.init {
            do {
                let minutesToPrepare = try await MenuController.shared.submitOrder(forMenuIDs: menuIds)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message:
           error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default,
           handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
