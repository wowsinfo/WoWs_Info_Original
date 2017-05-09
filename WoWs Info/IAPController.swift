//
//  IAPController.swift
//  WoWs Info
//
//  Created by Henry Quan on 18/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import StoreKit

class IAPController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var IAPTable: UITableView!
    
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    let proIAP = "com.yihengquan.WoWsInfo.Pro"
    var productList = [SKProduct]()
    var product = SKProduct()
    let descriptionString = [NSLocalizedString("IAP_NOADS", comment: "Remove ads"), NSLocalizedString("IAP_DASHBOARD", comment: "Dashboard"), NSLocalizedString("IAP_FRIENDLIST", comment: "Friend list"), NSLocalizedString("IAP_BETTERSTAT", comment: "Better stat"), NSLocalizedString("IAP_RATING", comment: "PR"), NSLocalizedString("IAP_CHARTS", comment: "Charts"), NSLocalizedString("IAP_RANK", comment: "Rank")]
    let iconImage = [#imageLiteral(resourceName: "NoAds"),#imageLiteral(resourceName: "Dashboard"),#imageLiteral(resourceName: "List"),#imageLiteral(resourceName: "SearchIcon"),#imageLiteral(resourceName: "Number"),#imageLiteral(resourceName: "Graphs"),#imageLiteral(resourceName: "Rank")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAPTable.delegate = self
        IAPTable.dataSource = self
        IAPTable.separatorColor = UIColor.clear
        
        SKPaymentQueue.default().add(self)
        
        if SKPaymentQueue.canMakePayments() {
            let productID = NSSet(object: proIAP)
            let request = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
            print("Preparing for purchase")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "gotoAdvancedInfo" {
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = ["HenryQuan", "2011774448"]
            destination.isPreview = true
            
            // Change to Asia server
            UserDefaults.standard.set(DataManagement.ServerIndex.Asia, forKey: DataManagement.DataName.Server)
        }
    }
    
    func becomePro() {
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.IsAdvancedUnlocked)
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.IsThereAds)
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.hasPurchased)
        // Thank you
        let alert = UIAlertController(title: NSLocalizedString("PURCHASE_TITLE", comment: "Title"), message: NSLocalizedString("PURCHASE_MESSAGE", comment: "Message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("PURCHASE_OK", comment: "OK"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func buyProduct() {
        print("Purchasing Pro verison")
        let payment = SKPayment(product: self.product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func purchaseBtnPressed(_ sender: UIButton) {
        
        // Make a request if user is not paid customer
        if !isProVersion {
            // Check if can make payment
            print(productList)
            for p in productList {
                if p.productIdentifier == proIAP {
                    self.product = p
                    buyProduct()
                }
            }
        }
        
    }

    @IBAction func restoreBtnPressed(_ sender: UIButton) {
        
        if !isProVersion {
            if (SKPaymentQueue.canMakePayments()) {
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().restoreCompletedTransactions()
            }
        }
        
    }
    
    // MARK: Proudct request
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let myProduct = response.products
        print(myProduct.count)
        for p in myProduct {
            print(p.productIdentifier)
            print(p.localizedTitle)
            print(p.localizedDescription)
            print(p.price)
            
            // Get localised price
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = p.priceLocale
            self.priceLabel.text = "\(formatter.string(from: p.price)!)"
            productList.append(p)
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        // Become Pro verison here
        becomePro()
        print("It is now Pro version!")
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            let t = transaction
            
            switch t.transactionState {
            case .purchased:
                // Thank you
                becomePro()
                print("Success!")
                queue.finishTransaction(t)
            case .failed:
                print("Failed")
                let pro = UIAlertController(title: ">_<", message: NSLocalizedString("IAP_FAILED", comment: "Message"), preferredStyle: .alert)
                pro.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(pro, animated: true, completion: nil)
                queue.finishTransaction(t)
            default:
                break
            }
        }
        
    }
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IAPTable.dequeueReusableCell(withIdentifier: "IAPCell", for: indexPath) as! IAPCell
        cell.descriptionLabel.text = descriptionString[indexPath.row]
        cell.iconImage.image = iconImage[indexPath.row]
        return cell
    }
    
}
