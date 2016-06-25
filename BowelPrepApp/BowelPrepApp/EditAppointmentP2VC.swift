//
//  EditAppointmentP2VC.swift
//  BowelPrepApp
//
//  Created by Keith Lo on 15/4/2016.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class EditAppointmentP2VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var bloodThinnerSwitch: BEMCheckBox!
    @IBOutlet weak var painRelieverSwitch: BEMCheckBox!
    @IBOutlet weak var hardToCleanSwitch: BEMCheckBox!
    @IBOutlet weak var diabetesSwitch: BEMCheckBox!
    @IBOutlet weak var fiberSwitch: BEMCheckBox!
    
    @IBOutlet weak var textField: UITextField!
    
    var pickerView = UIPickerView()
    
    var appointment = Appointment()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createPickerView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        initView()
    }
    
    func initView() {
        bloodThinnerSwitch.on = appointment.bloodThinner
        painRelieverSwitch.on = appointment.painReliever
        hardToCleanSwitch.on = appointment.hardToCleanOut
        diabetesSwitch.on = appointment.diabetes
        fiberSwitch.on = appointment.fibers
    }
    
    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func next(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showPage3", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPage3" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let page3 = navController.viewControllers.first as? EditAppointmentP3VC {
                    appointment.bloodThinner = bloodThinnerSwitch.on
                    appointment.painReliever = painRelieverSwitch.on
                    appointment.hardToCleanOut = hardToCleanSwitch.on
                    appointment.diabetes = diabetesSwitch.on
                    appointment.fibers = fiberSwitch.on
                    page3.appointment = appointment
                }
            }
        }
        
    }

    
    @IBAction func bloodThinnerButton(sender: AnyObject) {
        showPickerView(0)
    }
    
    @IBAction func painRelieverButton(sender: AnyObject) {
        showPickerView(1)
    }
    
    @IBAction func cleanButton(sender: AnyObject) {
        showPickerView(2)
    }
    
    @IBAction func fibersButton(sender: AnyObject) {
        showPickerView(3)
    }
    
    func showPickerView(tag: Int) {
        pickerView.tag = tag
        pickerView.reloadAllComponents()
        textField.becomeFirstResponder()
    }
    
    func createPickerView() {
        pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = createToolBarForPicker()
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }

    func createToolBarForPicker() -> UIToolbar {
        
        // create tool bar with done and cancel button for picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditAppointmentP2VC.pickerSelected))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditAppointmentP2VC.pickerCancel))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        return toolBar
    }
    
    func pickerSelected() {
        switch pickerView.tag {
        case 0:
            bloodThinnerSwitch.setOn(true, animated: true)
        case 1:
            painRelieverSwitch.setOn(true, animated: true)
        case 2:
            hardToCleanSwitch.setOn(true, animated: true)
        case 3:
            fiberSwitch.setOn(true, animated: true)
        default:
            return
        }
        textField.resignFirstResponder()
        print("selected")
    }
    
    func pickerCancel() {
        textField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Medication.getMedicationList(pickerView.tag).count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Medication.getMedicationList(pickerView.tag)[row]
    }
    
    
}
