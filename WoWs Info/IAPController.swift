//
//  IAPController.swift
//  WoWs Info
//
//  Created by Henry Quan on 18/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import StoreKit

class IAPController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    let proIAP = "com.yihengquan.WoWs_Info.Pro"
    var productList = [SKProduct]()
    var product = SKProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if segue.identifier == "gotoAdvancedInfo" {
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = ["HenryQuan", "2011774448"]
            
            // Change to Asia server
            UserDefaults.standard.set(DataManagement.ServerIndex.Asia, forKey: DataManagement.DataName.Server)
        }
    }
    
    func becomePro() {
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.IsAdvancedUnlocked)
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.IsThereAds)
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
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let myProduct = response.products
        print(myProduct.count)
        for p in myProduct {
            print(p.productIdentifier)
            print(p.localizedTitle)
            print(p.localizedDescription)
            print(p.price)
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
                queue.finishTransaction(t)
            default:
                break
            }
        }
        
    }
    
}
