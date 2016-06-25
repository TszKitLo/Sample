//
//  AppointmentVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/19/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class AppointmentVC: UIViewController {
    
    
    @IBOutlet weak var addAppointmentConstraints: NSLayoutConstraint!
    
    // no appointment ui
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var addAppointmentBtn: CustomButton!
    
    @IBOutlet weak var appNameLbl: UILabel!
    
    // has appointment ui
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var instructionBtn: CustomButton!
    @IBOutlet weak var editAppointmentBtn: CustomButton!
    @IBOutlet weak var bottomButtonView: UIView!
    
    @IBOutlet weak var locationBtn: CustomButton!
    @IBOutlet weak var timeBtn: CustomButton!
    @IBOutlet weak var medBtn: CustomButton!
    
    var animEngine: AnimationEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animEngine = AnimationEngine(constraints: [addAppointmentConstraints])
    }
    
    override func viewDidAppear(animated: Bool) {
        if let appointment = Appointment.load() {
            hideNoAppointmentUI(true)
            hideAppointmentUI(false)
            
            showAppointmentInfo(appointment)
            
        } else {
            hideAppointmentUI(true)
            hideNoAppointmentUI(false)
            // delay 0.5 sec, then animate on screen
            animEngine.animateOnScreen(0.5)
        }
    }
    
    func showAppointmentInfo(appointment: Appointment) {
        let days = appointment.getDaysBeforeProcedure()
        if days < 0 {
            hideAppointmentUI(true)
            hideNoAppointmentUI(false)
            animEngine.animateOnScreen(0.5)
        } else {
            
            daysLbl.text = String(appointment.getDaysBeforeProcedure()) + " Days".localized() + ", \non " + appointment.getDateString()!
        }
        locationBtn.setTitle(appointment.location.localized(), forState: .Normal)
        timeBtn.setTitle(appointment.getTimeString(), forState: .Normal)
        if let medConflict = appointment.getMedicationConflict() {
            medBtn.setImage(UIImage(named: "medical_red_small_30"), forState: .Normal)
            let medString = Util.flattenStringArray(medConflict, separator: ", ")
            medBtn.setTitle(medString, forState: .Normal)
        } else {
            medBtn.setImage(UIImage(named: "medical_blue_small_30"), forState: .Normal)
            medBtn.setTitle("No Medication Conflict", forState: .Normal)
        }
    }
    
    func hideNoAppointmentUI(hide: Bool) {
        logo.hidden = hide
        addAppointmentBtn.hidden = hide
        appNameLbl.hidden = hide
    }
    
    func hideAppointmentUI(hide: Bool) {
        todayLbl.hidden = hide
        daysLbl.hidden = hide
        
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
        
        locationBtn.hidden = hide
        timeBtn.hidden = hide
        medBtn.hidden = hide
        instructionBtn.hidden = hide
        editAppointmentBtn.hidden = hide
        bottomButtonView.hidden = hide
    }
    
    @IBAction func showInstruction(sender: AnyObject) {
        // this is triggered by "today's instruction" button, which only shows when there is an appointment
        // thus force unwrap appointment here should not cause nil exception
        if Instruction.hasInstructionToday(Appointment.load()!.getDaysBeforeProcedure()) {
            self.tabBarController?.selectedIndex = 2
        } else {
            // inform the user that there is no specific instruction for today.
            let alert = UIAlertController(title: "Today's Instruction", message: "There is no specific instruction for today. Would you like to see all instructions?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "See All Instructions", style: .Default, handler: { (_) -> Void in
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onLocationClicked() {
        let alert = UIAlertController(title: "Select Action", message: "\(locationBtn.currentTitle!)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Get Direction", style: .Default, handler: { (action) -> Void in
            
            // open map app to get direction with appointment location
            let location = Appointment.load()!.location
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                }
                
                if let placemark = placemarks?.first {
                    let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMapsWithLaunchOptions(options)
                }
            })
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTimeClicked() {
        let alert = UIAlertController(title: "Select Action", message: "\(timeBtn.currentTitle!)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Add to Calendar", style: .Default, handler: { (action) -> Void in
            
            let eventStore = EKEventStore()
            if EKEventStore.authorizationStatusForEntityType(.Event) != .Authorized{
                eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
                    if !granted {
                        // permission not granted, alert user and abort action
                        let failAlert = UIAlertController(title: "Add to Calendar failed", message: "Permission not granted by user. Please go to settings -> bowel prep helper -> calendar to allow access to Calendar.", preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    }
                })
            } else {
                // add appointment date to Calendar.
                let appointment = Appointment.load()!
                let startDate = appointment.time
                let procedureDuration: NSTimeInterval = 30 * 60 // 30 mins
                let endDate = startDate.dateByAddingTimeInterval(procedureDuration)
                let location = appointment.location
                self.createEvent(eventStore, title: "Colonoscopy", startDate: startDate, endDate: endDate, location: location)
                
                // TODO: add all important instruction to Calendar
                
                // alert user save successful
                let successAlert = UIAlertController(title: "Event Added to Calendar", message: "", preferredStyle: .Alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Remove from Calendar", style: .Destructive, handler: { (action) in
            let eventStore = EKEventStore()
            if EKEventStore.authorizationStatusForEntityType(.Event) != .Authorized{
                eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
                    if !granted {
                        // permission not granted, alert user and abort action
                        let failAlert = UIAlertController(title: "Add to Calendar failed", message: "Permission not granted by user. Please go to settings -> bowel prep helper -> calendar to allow access to Calendar.", preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    }
                })
            } else {
                // remove appointment date to Calendar.
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let eventIds = userDefaults.stringArrayForKey("bowel.eventIds")
                if eventIds != nil {
                    for eventId in eventIds! {
                        self.removeEvent(eventStore, eventIdentifier: eventId)
                    }
                } else {
                    let failAlert = UIAlertController(title: "No removable events", message: "", preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: true, completion: nil)
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onMedClicked() {
        var msg: String
        let appointment = Appointment.load()!
        if let _ = appointment.getMedicationConflict() {
            msg = "Based on the information you provided, you have the following conflict(s): \(medBtn.currentTitle!). Please check the faq first. If it is not answered there, ask your doctor for advice."
        } else {
            msg = "Based on the information you provided, you don't have any medication conflict."
        }
        
        let alert = UIAlertController(title: "Medication Conflict", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Go to FAQ", style: .Default, handler: { (action) -> Void in
            self.tabBarController?.selectedIndex = 3
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onEditAppointmentClicked() {
        self.performSegueWithIdentifier("editAppointment", sender: nil)
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate, allDay: Bool = false, location: String) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.allDay = allDay
        event.location = location
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            // save the event's id, so it can be removed if necessary
            let userDefault = NSUserDefaults.standardUserDefaults()
            var eventIds = userDefault.stringArrayForKey("bowel.eventIds")
            if eventIds == nil {
                eventIds = [event.eventIdentifier]
            } else {
                eventIds?.append(event.eventIdentifier)
            }
            userDefault.setObject(eventIds, forKey: "bowel.eventIds")
            // don't need to synchronize it right away cuz we don't need it right away, I think
            // userDefault.synchronize()
        } catch {
            print("Creat event failed")
        }
    }
    
    func removeEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let event = eventStore.eventWithIdentifier(eventIdentifier)
        if let event = event {
            do {
                try eventStore.removeEvent(event, span: .ThisEvent)
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.removeObjectForKey("bowel.eventIds")
                // alert user save successful
                let successAlert = UIAlertController(title: "Event Removed from Calendar", message: "", preferredStyle: .Alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
            } catch {
                print("remove event failed")
            }
        }
    }
}
