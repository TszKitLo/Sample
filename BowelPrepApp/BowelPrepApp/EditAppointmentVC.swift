//
//  EditAppointmentVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/19/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import UIKit

class EditAppointmentVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var locationTextField: CustomTextField!
    @IBOutlet weak var timeTextField: CustomTextField!

    var appointment = Appointment()
    
    var medicationType = Medication.MedicationType.bloodThinner
    
    var pickerView: UIPickerView!
    var datePicker: UIDatePicker!
    
    var isPickingLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createLocationPicker()
        
        initView()
    }
    
    override func viewDidAppear(animated: Bool) {
        if isPickingLocation {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let locationString = userDefault.stringForKey("bowel.tempLocationPicked")
            locationTextField.text = locationString
            isPickingLocation = false
        }
    }
    
    func initView() {
        if let appointment = Appointment.load() {
            locationTextField.text = appointment.location
            timeTextField.text = appointment.getTimeString()
            self.appointment = appointment

        }
    }
    
    /**  Pickers for selecting location and time **/
    func createLocationPicker() {
        pickerView = UIPickerView(frame: CGRectMake(0, 200, view.frame.width, 300))
        pickerView.backgroundColor = .whiteColor()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = createToolBarForPicker("Location")
        
        locationTextField.inputView = pickerView
        locationTextField.inputAccessoryView = toolBar
    }
    
    func createDatePicker() {
        datePicker = UIDatePicker(frame: CGRectMake(0, 200, view.frame.width, 300))
        datePicker.datePickerMode = .DateAndTime
        datePicker.backgroundColor = .whiteColor()
        
        let toolBar = createToolBarForPicker("Time")
        
        timeTextField.inputView = datePicker
        timeTextField.inputAccessoryView = toolBar
    }
    
    func createToolBarForPicker(pickerType: String) -> UIToolbar {
        var actionWhenDone = ""
        var actionWhenCancel = ""
        if pickerType == "Location" {
            actionWhenDone = "onLocationPicked"
            actionWhenCancel = "onLocationCanceled"
        } else {
            actionWhenDone = "onTimePicked"
            actionWhenCancel = "onTimeCanceled"
        }
        
        // create tool bar with done and cancel button for picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionWhenDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(actionWhenCancel))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        return toolBar
    }
    
    func onTimePicked() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        timeTextField.text = dateFormatter.stringFromDate(datePicker.date)
        
        timeTextField.resignFirstResponder()
    }
    
    func onTimeCanceled() {
        timeTextField.resignFirstResponder()
    }
    
    func onLocationPicked() {
        locationTextField.text = Location.locations[pickerView.selectedRowInComponent(0)]
        locationTextField.resignFirstResponder()
    }
    
    func onLocationCanceled() {
        locationTextField.resignFirstResponder()
    }
    
    // MARK: PickerView datasource and delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Location.locations.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.text = Location.locations[row]
        label.font = label.font.fontWithSize(20)
        return label
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    // MARK: Buttons onClicks

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func next(sender: AnyObject) {
        if locationTextField.text == "" || timeTextField.text == "" {
            let alert = UIAlertController(title: "Information Required", message: "One or both of your appointment location and time is missing.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("showPage2", sender: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPage2" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let page2 = navController.viewControllers.first as? EditAppointmentP2VC {
                    //get time string and convert to date
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateStyle = .MediumStyle
                    dateFormatter.timeStyle = .ShortStyle
                    let time = dateFormatter.dateFromString(timeTextField.text!)!
                    
                    appointment.time = time
                    appointment.location = locationTextField.text!
                    page2.appointment = appointment
                } 
            }
        }
        
        
    }

    
    
    
    
    
}
