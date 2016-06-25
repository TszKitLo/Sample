//
//  DisclaimerVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 5/27/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

class DisclaimerVC: UIViewController {
    let disclaimerAcceptedKey = "bowelprep.disclaimer.accepted"
    
    @IBOutlet weak var disclaimer: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefault = NSUserDefaults.standardUserDefaults()
        let accepted = userDefault.boolForKey(disclaimerAcceptedKey)
//        if accepted {
//            accept()
//        }
        disclaimer.text = "disclaimer".localized()
    }
    
    @IBAction func accept() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setBool(true, forKey: disclaimerAcceptedKey)
        self.performSegueWithIdentifier("acceptDisclaimer", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? UITabBarController {
            dest.selectedIndex = 1
        }
    }
}