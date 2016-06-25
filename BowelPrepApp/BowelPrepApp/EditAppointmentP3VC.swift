//
//  EditAppointmentP3VC.swift
//  BowelPrepApp
//
//  Created by Keith Lo on 15/4/2016.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

class EditAppointmentP3VC: UITableViewController{
    
    var appointment = Appointment()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        
        initView()
    }
    
    func initView() {
        
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func next(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showSummary", sender: nil)
        
    }
    
    /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSummary" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let summaryView = navController.viewControllers.first as? SummaryVC {
                    summaryView.appointment = appointment
                } // end if
            } // end if
        } // end if
        
        else if segue.identifier == "showPreparationInfo" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let preparationInfoView = navController.viewControllers.first as? PreparationInfo {
                    preparationInfoView.appointment = appointment
                } // end if
            } // end if
        } // end if
        
    } */
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Method.methods.count

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("methodCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = Method.methods[indexPath.row]
        
        if indexPath.row != appointment.method{
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        appointment.method = indexPath.row
        tableView.reloadData()
        
        self.performSegueWithIdentifier("showPreparationInfo", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSummary" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let summaryView = navController.viewControllers.first as? SummaryVC {
                    summaryView.appointment = appointment
                } // end if
            } // end if
        } // end if
            
        else if segue.identifier == "showPreparationInfo" {
            print("showPreparationInfo seg executed")
//            if let navController = segue.destinationViewController as? UINavigationController {
//                if let preparationInfoView = navController.viewControllers.first as? PreparationInfo {
//                    print("In here \(appointment.method)")
//                    preparationInfoView.appointment = appointment
//                } // end if
//            } // end if
            

            if let controller = segue.destinationViewController as? PreparationInfo{
                controller.appointment = appointment
            }


            
        } // end if
        
    }
    
}