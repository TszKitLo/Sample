//
//  InstructionVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/20/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class InstructionVC: UITableViewController {
    
    @IBOutlet weak var segmentHeader: UILabel!
    var selectedInstructionDictonaryIndex = "Today"
    var appointment = Appointment()
    var instructions = [String]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.removeShadow()
        
        // load appointment info
        if let appt = Appointment.load() {
            appointment = appt
        }
        
        // use card.xib for custom cells
        let nib = UINib(nibName: "BulletCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "customCardCell")
        
        // hide extra empty cells
        tableView.tableFooterView = UIView()
        
        // make drop down menu
        createDropDownMenu()
        
    }
    
    var menuView: BTNavigationDropdownMenu!
    
    func createDropDownMenu() {
        let items = ["Today", "General", "5th - 2nd Day before", "1 day before", "Day of Procedure"]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items[0], items: items)
        self.segmentHeader.text = "Instructions for today"
        menuView.cellHeight = 50
        menuView.menuTitleColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellBackgroundColor = UIColor.primaryBlueColor()
        menuView.keepSelectedCellColor = true
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch indexPath {
            case 0:
                
                self.instructions = Instruction.getInstructionForDay(self.appointment.getDaysBeforeProcedure(), method: self.appointment.methodAsEnum)!
                self.segmentHeader.text = "Instructions for today"
            case 1:
                self.instructions = Instruction.getInstructionForDay(6, method: self.appointment.methodAsEnum)
                self.segmentHeader.text = "General Instructions for Colonoscopy"
            case 2:
                self.instructions = Instruction.getInstructionForDay(2, method: self.appointment.methodAsEnum)
                self.segmentHeader.text = "Instructions starting 5 days before your procedure"
            case 3:
                self.instructions = Instruction.getInstructionForDay(1, method: self.appointment.methodAsEnum)
                self.segmentHeader.text = "Instructions for the days before your procedure"
            case 4:
                self.instructions = Instruction.getInstructionForDay(0, method: self.appointment.methodAsEnum)
                self.segmentHeader.text = "Instructions for the day of your procedure"
            default:
                self.instructions = Instruction.getInstructionForDay(6, method: self.appointment.methodAsEnum)
                self.segmentHeader.text = "General Instructions for Colonoscopy"
            }
            self.tableView.reloadData()
        }
        self.navigationItem.titleView = menuView
    }
    
    override func viewWillAppear(animated: Bool) {
        createDropDownMenu()
        self.instructions = Instruction.getInstructionForDay(self.appointment.getDaysBeforeProcedure(), method: self.appointment.methodAsEnum)!
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = instructions {
            return instructions!.count
        } else {
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customCardCell", forIndexPath: indexPath) as? BulletCell
        
        cell?.instructionLbl.text = instructions![indexPath.row].localized()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
