//
//  SummaryVC.swift
//  BowelPrepApp
//
//  Created by Keith Lo on 16/4/2016.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

class SummaryVC: UIViewController {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bloodThinnerLbl: UILabel!
    @IBOutlet weak var painRelieverLbl: UILabel!
    @IBOutlet weak var hardToCleanLbl: UILabel!
    @IBOutlet weak var diabetesLbl: UILabel!
    @IBOutlet weak var fibersLbl: UILabel!
    @IBOutlet weak var preparationLbl: UILabel!
    
	var appointment = Appointment()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupInitialLabels()
    }
	
    func setupInitialLabels(){
        self.locationLbl.text = appointment.location
        self.dateLbl.text = appointment.getDateString()
        self.bloodThinnerLbl.text = appointment.bloodThinner ? "Yes" : "No"
        self.painRelieverLbl.text = appointment.painReliever ? "Yes" : "No"
        self.hardToCleanLbl.text = appointment.hardToCleanOut ? "Yes" : "No"
        self.diabetesLbl.text = appointment.diabetes ? "Yes" : "No"
        self.fibersLbl.text = appointment.fibers ? "Yes" : "No"
        self.preparationLbl.text = Method.methods[self.appointment.method]
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func confirm(sender: AnyObject) {
        appointment.save()
        Instruction.addPrepMethodInstructions(appointment.methodAsEnum)
        
        if let currentSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
            if currentSettings.types == .None {
                //no permission, ask pre-permission for notification
                let alert = UIAlertController(title: "Permission for notification", message: "We would like your permission to send you notifications. It will remind you when you have new instructions for preparation. This is a very crucial part of this app. Please allow!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Not Now", style: UIAlertActionStyle.Default, handler:nil))
                alert.addAction(UIAlertAction(title: "Allow", style: UIAlertActionStyle.Default, handler: { action in
                    //set up actions
                    let showDaily = UIMutableUserNotificationAction()
                    showDaily.identifier = "ShowDaily"
                    showDaily.title = "Show Daily Detail"
                    showDaily.activationMode = .Foreground
                    showDaily.destructive = true
                    showDaily.authenticationRequired = false
                    
                    let showGeneral = UIMutableUserNotificationAction()
                    showGeneral.identifier = "ShowGeneral"
                    showGeneral.title = "Show Detail"
                    showGeneral.activationMode = .Foreground
                    showGeneral.destructive = true
                    showGeneral.authenticationRequired = false
                    
                    let remind = UIMutableUserNotificationAction()
                    remind.identifier = "Remind"
                    remind.title = "Remind in 1 hour"
                    remind.activationMode = .Background
                    remind.destructive = false
                    remind.authenticationRequired = false
                    
                    //set up categories
                    let dailyCategory = UIMutableUserNotificationCategory()
                    dailyCategory.identifier = Constants.dailyCategoryIdentifier
                    dailyCategory.setActions([showDaily, remind], forContext: .Default)
                    dailyCategory.setActions([showDaily, remind], forContext: .Minimal)
                    
                    let generalCategory = UIMutableUserNotificationCategory()
                    generalCategory.identifier = Constants.generalCategoryIdentifier
                    generalCategory.setActions([showGeneral, remind], forContext: .Default)
                    generalCategory.setActions([showGeneral, remind], forContext: .Minimal)
                    
                    
                    //register notification settings / ask real permission
                    let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: [dailyCategory, generalCategory])
                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                    
                    //add all notifications
                    Notification.addAllNotifications(self.appointment.time)
                    
                    //return to previous screen
                    self.performSegueWithIdentifier("returnToTabs", sender: nil)
                }))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                //already have permission. Cancel all previous notification, and add all new ones
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                Notification.addAllNotifications(appointment.time)
                //return to previous screen
                self.performSegueWithIdentifier("returnToTabs", sender: nil)
            }
        }

    }

}