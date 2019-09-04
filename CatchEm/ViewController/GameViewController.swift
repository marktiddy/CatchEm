//
//  GameViewController.swift
//  CatchEm
//
//  Created by Mark Tiddy on 25/08/2019.
//  Copyright © 2019 Mark Tiddy. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import StoreKit

//Here is the adfreecode
//Add free code needs to go into the gamescene so it doesn't try and display if there is a purchase
//Use Userdefaults
//ID
//catchEmAdFree

class GameViewController: UIViewController, GADBannerViewDelegate, SKPaymentTransactionObserver {
   
    
    
    let productID = "catchEmAdFree"
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
    
        
        //Banner view stuff
        
        bannerView.adUnitID = "ca-app-pub-8080686117362027/7937587237"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        if UserDefaults.standard.bool(forKey: "isPurchased") == true {
            //don't show ads
            removeAds()
        } else {
            //show ads
        }
        
        if let view = self.view as! SKView? {
            //Load the SKScene
            
            let scene = MenuScene(size: view.bounds.size)
            
            //set scale mode
                scene.scaleMode = .aspectFill
                
                //present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            
        }
}
    func removeAds() {
        bannerView.isHidden = true
        restorePurchaseButton.isHidden = true
        purchaseButton.isHidden = true
      
        //if we need to we set the user defaults
        if UserDefaults.standard.bool(forKey: "isPurchased") == false {
            UserDefaults.standard.set(true, forKey: "isPurchased")
        }
        
    }
    
    //MARK: In app payment methods
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successful
                print("Transaction Successful")
                removeAds()
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //Payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed with error \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)

            } else if transaction.transactionState == .restored {
                removeAds()
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    
    func goAdFree() {
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            //Can't make payments
        }
        
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        print("Restore Button Pressed")
       SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        print("Purchase Button Pressed")
        goAdFree()
     
    }

}
