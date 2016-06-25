//
//  Notification.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 2/11/16.
//  Copyright Â© 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

struct Notification {
    static func addAllNotifications(appointmentTime : NSDate) {
        //test notification, send notification 15 seconds from now
        let testDate = NSDate(timeIntervalSinceNow: 15)
        self.addNotification("This is a test notification. Remove this later.", fireDate: testDate, category: Constants.generalCategoryIdentifier)
        
        //add notifications for all daily instructions 5 days prior to appointmentTime
        for i in 1...5 {
            self.addNotification("Day \(i) notification content".localized(), fireDate: appointmentTime.setToTimeOnDay(i, hour: Constants.morning), category: Constants.dailyCategoryIdentifier)
            self.addNotification("Day \(i) notification content".localized(), fireDate: appointmentTime.setToTimeOnDay(i, hour: Constants.noon), category: Constants.dailyCategoryIdentifier)
        }
        
        //add special notifications for general instructions
        self.addNotification("Reschedule first warning".localized(), fireDate: appointmentTime.setToTimeOnDay(7, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        self.addNotification("Reschedule last warning".localized(), fireDate: appointmentTime.setToTimeOnDay(3, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        self.addNotification("Driver first warning".localized(), fireDate: appointmentTime.setToTimeOnDay(3, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        self.addNotification("Driver last warning".localized(), fireDate: appointmentTime.setToTimeOnDay(0, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        self.addNotification("Arrive on time first warning".localized(), fireDate: appointmentTime.setToTimeOnDay(1, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        self.addNotification("Arrive on time last warning".localized(), fireDate: appointmentTime.setToTimeOnDay(0, hour: Constants.morning), category: Constants.generalCategoryIdentifier)
        
        //TODO: add drink liquid notifications
        if let appointment = Appointment.load() {
            addNotificationForAppointment(appointment)
        }
    }
    
    static func addNotification(body : String, fireDate : NSDate, category : String) {
        if fireDate.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            //the firedate is before now, so don't add this notification
            return
        }
        //setup notification
        let notification = UILocalNotification()
        notification.alertBody = body
        notification.fireDate = fireDate
		notification.timeZone = NSTimeZone.systemTimeZone()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = category
        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    static func addNotificationForAppointment(appointment: Appointment) {
        let appointmentTime = appointment.time
        let day1_3pm = appointmentTime.setToTimeOnDay(1, hour: Constants.threePM)
        let day1_5pm = appointmentTime.setToTimeOnDay(1, hour: Constants.fivePM)
        let day0_5hr = appointmentTime.setTimeToHourAgo(5)
        switch appointment.methodAsEnum {
        case .MoviPrep:
            self.addNotification("moviprep.day1_3pm".localized(), fireDate: day1_3pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("moviprep.day1_3pm".localized(), fireDate: day1_5pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("moviprep.day0_4pm".localized(), fireDate: day0_5hr, category: Constants.generalCategoryIdentifier)
        case .Nulytely:
            self.addNotification("nuly.day1_3pm".localized(), fireDate: day1_3pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("nuly.day1_3pm".localized(), fireDate: day1_5pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("nuly.day0_4pm".localized(), fireDate: day0_5hr, category: Constants.generalCategoryIdentifier)
        case .Prepopik:
            self.addNotification("prepopid.day1_3pm".localized(), fireDate: day1_3pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("prepopid.day1_3pm".localized(), fireDate: day1_5pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("prepopid.day0_4pm".localized(), fireDate: day0_5hr, category: Constants.generalCategoryIdentifier)
        case .Suprep:
            self.addNotification("suprep.day1_3pm".localized(), fireDate: day1_3pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("suprep.day1_3pm".localized(), fireDate: day1_5pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("suprep.day0_4pm".localized(), fireDate: day0_5hr, category: Constants.generalCategoryIdentifier)
        case .Halflytely:
            self.addNotification("halflytely.day1_3pm".localized(), fireDate: day1_3pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("halflytely.day1_3pm".localized(), fireDate: day1_5pm, category: Constants.generalCategoryIdentifier)
			self.addNotification("halflytely.day0_4pm".localized(), fireDate: day0_5hr, category: Constants.generalCategoryIdentifier)
        case .None:
            break
        }
    }
    
    static func remind(body : String, category : String) {
        //remind in 1 hour (15 sec for testing)
        addNotification(body, fireDate: NSDate(timeIntervalSinceNow: 15), category: category)
    }
    
}


extension NSDate {
    
    func setToTimeOnDay(day: Int, hour: Int, minute: Int=0, second: Int=0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(([.Day, .Month, .Year]), fromDate: self)
        components.hour = hour
        components.minute = minute
        components.second = second
        let tempDate = calendar.dateFromComponents(components)!
        let minusDay = NSDateComponents()
        minusDay.day = -day
        return calendar.dateByAddingComponents(minusDay, toDate: tempDate, options: [])!
    }
    
    func setTimeToHourAgo(hour: Int) -> NSDate{
        return NSCalendar.currentCalendar().dateByAddingUnit(.Hour, value: -hour, toDate: self, options: [])!
    }
    
    
    
}