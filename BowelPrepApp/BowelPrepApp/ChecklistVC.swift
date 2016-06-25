//
//  ChecklistVC.swift
//  BowelPrepApp
//
//  Created by Kevin Huang on 4/24/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

class ChecklistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var medCheckList = [String]()
    var medCheckListChecker = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // use card.xib for custom cells
        let nib = UINib(nibName: "CheckCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "checkCell")
        
        dateLabel.text = "You have no appointment"
        
        if let appointment = Appointment.load() {
            
            let strHead = "You have an appointment in \n"
            let strTail = strHead + "\(appointment.getDaysBeforeProcedure())" + "\n days, \n on "
            let attrString = NSMutableAttributedString(string: "You have an appointment in \n \(appointment.getDaysBeforeProcedure()) days, \n on \(appointment.getDateString()!)")
            let range1 = NSRange(location: strHead.characters.count, length: " \(appointment.getDaysBeforeProcedure()) days".characters.count)
            let range2 = NSRange(location: strTail.characters.count, length: appointment.getDateString()!.characters.count)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1), range: range1)
            attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1), range: range2)
            dateLabel.attributedText = attrString
            
            if let checklist = Checklist.getChecklist(appointment.getDaysBeforeProcedure()) {
                medCheckList = checklist
            }
            
            if let checker = Checklist.getChecklistChecker(appointment.getDaysBeforeProcedure()) {
                medCheckListChecker = checker
            } else {
                medCheckListChecker = [Bool](count: medCheckList.count, repeatedValue: false)
            }
        }
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //dynamic height
        //        tableView.estimatedRowHeight = 94.0
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
    }
    
    // Table View Data Source Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medCheckList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("checkCell", forIndexPath: indexPath) as! CheckCell
        
        cell.check.on = medCheckListChecker[indexPath.row]
        cell.label.text = medCheckList[indexPath.row].localized()
        
        // background color when cell is selected
        let bgView = UIView()
        bgView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! CheckCell
        
        selectedCell.check.setOn(true, animated: true)
        
        medCheckListChecker[indexPath.row] = true
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let deselectedCell = tableView.cellForRowAtIndexPath(indexPath) as! CheckCell
        deselectedCell.check.setOn(false, animated: true)
        medCheckListChecker[indexPath.row] = false
    }
    
}