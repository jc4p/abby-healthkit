//
//  LogViewController.swift
//  Abby's Cycle Tracker
//
//  Created by Kasra Rahjerdi on 9/7/15.
//  Copyright © 2015 Kasra Rahjerdi. All rights reserved.
//

import UIKit
import HealthKit

class LogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var timePickerView: UIDatePicker?
    var flowPickerView: UIPickerView?
    var lastSelectedIndexPath: NSIndexPath?
    
    var time: NSDate?
    var timeFormatter = NSDateFormatter()
    
    let flowOptions = ["---", "Light", "Medium", "Heavy"]
    var flowSelection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        timePickerView = UIDatePicker()
        timePickerView!.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        timePickerView!.backgroundColor = UIColor(red:0.27, green:0.35, blue:0.39, alpha:1.0)
        timePickerView!.frame = CGRectMake(0, 0, view.frame.width, timePickerView!.frame.height)
        timePickerView!.addTarget(self, action: "timePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        time = NSDate()
        timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        timeFormatter.timeStyle = .ShortStyle
        
        flowPickerView = UIPickerView()
        flowPickerView!.dataSource = self
        flowPickerView!.delegate = self
        flowPickerView!.frame = CGRectMake(0, 0, view.frame.width, flowPickerView!.frame.height)
        flowPickerView!.backgroundColor = UIColor(red:0.27, green:0.35, blue:0.39, alpha:1.0)
        
        flowSelection = 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("logCell") as! LogTableViewCell
        
        if (indexPath.indexAtPosition(1) == 0) {
            cell.inputLabel.text = "Time"
            cell.valueLabel.text = timeFormatter.stringFromDate(time!)
        }
        else {
            cell.inputLabel.text = "Flow"
            cell.valueLabel.text = flowOptions[flowSelection!]
        }
        
        cell.inputLabel.highlightedTextColor = UIColor.blackColor()
        cell.valueLabel.highlightedTextColor = UIColor.blackColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.indexAtPosition(1) == 0) {
            if (flowPickerView?.superview != nil) {
                hideFlowPicker()
            }
            
            if (lastSelectedIndexPath == indexPath) {
                hideTimePicker()
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                showTimePicker()
            }
        } else {
            if (timePickerView?.superview != nil) {
                hideTimePicker()
            }
            
            if (lastSelectedIndexPath == indexPath) {
                hideFlowPicker()
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                showFlowPicker()
            }
        }
        
        lastSelectedIndexPath = tableView.indexPathForSelectedRow
    }
    
    func showTimePicker() {
        timePickerView!.frame.origin.y = view.bounds.height;
        view.addSubview(timePickerView!)
        timePickerView!.window!.layer.zPosition = 1
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.timePickerView!.frame.origin.y = self.view.bounds.height - self.timePickerView!.frame.height
        }
    }
    
    func hideTimePicker() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.timePickerView!.frame.origin.y = self.view.bounds.height
            }) { (_) -> Void in
                self.timePickerView!.removeFromSuperview()
        }
    }
    
    func showFlowPicker() {
        flowPickerView!.frame.origin.y = view.bounds.height;
        view.addSubview(flowPickerView!)
        flowPickerView!.window!.layer.zPosition = 1
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.flowPickerView!.frame.origin.y = self.view.bounds.height - self.flowPickerView!.frame.height
        }
    }
    
    func hideFlowPicker() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.flowPickerView!.frame.origin.y = self.view.bounds.height
            }) { (_) -> Void in
                self.flowPickerView!.removeFromSuperview()
        }
    }
    
    func timePickerValueChanged(sender: UIDatePicker) {
        time = sender.date
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flowOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: flowOptions[row], attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        flowSelection = row
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    }

    @IBAction func saveButtonHit(sender: UIButton) {
        let delegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let hkStore = delegate.hkStore
        
        let sampleType = HKObjectType.categoryTypeForIdentifier(HKCategoryTypeIdentifierMenstrualFlow)
        
        var value: HKCategoryValueMenstrualFlow
        switch(flowSelection!) {
        case 0:
            value = HKCategoryValueMenstrualFlow.Unspecified
            break
        case 1:
            value = HKCategoryValueMenstrualFlow.Light
            break
        case 2:
            value = HKCategoryValueMenstrualFlow.Medium
            break
        default:
            value = HKCategoryValueMenstrualFlow.Heavy
            break
        }
        
        let sample = HKCategorySample(type: sampleType!, value: value.rawValue, startDate: time!, endDate: time!, metadata: [HKMetadataKeyMenstrualCycleStart: true])
        
        hkStore?.saveObject(sample, withCompletion: { (saved: Bool, error: NSError?) -> Void in
            if (!saved && error == nil) {
                let alertController = UIAlertController(title: "Oh oh", message: "Unable to save record", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Try again?", style: .Default, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else if (error != nil) {
                let alertController = UIAlertController(title: "Unable to save record", message: error?.localizedDescription, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Try again?", style: .Default, handler: nil)
                alertController.addAction(action)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                delegate.didJustSave = true
                self.performSegueWithIdentifier("backwardsSegue", sender: sender)
            }
        })
        
    }
}
