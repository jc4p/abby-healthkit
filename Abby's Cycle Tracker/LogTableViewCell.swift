//
//  LogTableViewCell.swift
//  Abby's Cycle Tracker
//
//  Created by Kasra Rahjerdi on 9/7/15.
//  Copyright © 2015 Kasra Rahjerdi. All rights reserved.
//

import Foundation
import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setInputLabelText(text: String) {
        inputLabel.text = text;
    }
    
    func setValueLabelText(text: String) {
        valueLabel.text = text
    }
}