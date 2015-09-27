//
//  ViewController.swift
//  Abby's Cycle Tracker
//
//  Created by Kasra Rahjerdi on 9/7/15.
//  Copyright © 2015 Kasra Rahjerdi. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {

    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        initHealthStore(appDelegate.hkStore!)
        
        logButton.backgroundColor =  UIColor(red:1.0, green:0.25, blue:0.51, alpha:1.0)
        logButton.layer.cornerRadius = logButton.bounds.width / 4
        logButton.layer.borderWidth = 0
        
        if (appDelegate.didJustSave == true) {
            topLabel.text = "Alright, got it!\nCome back next month, I guess?"
            appDelegate.didJustSave = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initHealthStore(hkStore: HKHealthStore) {
        let sampleTypes = HKSampleType.categoryTypeForIdentifier(HKCategoryTypeIdentifierMenstrualFlow)!
        
        hkStore.requestAuthorizationToShareTypes([sampleTypes], readTypes: nil) {
            (success: Bool, error: NSError?) -> Void in
            if (!success || error != nil) {
                let alertController = UIAlertController(title: "Error initializing HealthKit", message: error == nil ? "Unknown error :(" : error!.localizedDescription, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Try again?", style: .Default, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

