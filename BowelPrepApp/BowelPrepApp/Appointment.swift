//
//  Appointment.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/20/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation

class Appointment {
    var location = ""
    var time = NSDate()
    var bloodThinner = false
    var painReliever = false
    var hardToCleanOut = false
    var fibers = false
    var method = -1
    var diabetes = false
    
    static let LOCATION_KEY = "bowel.location"
    static let TIME_KEY = "bowel.time"
    static let bloodThinner_KEY = "bowel.bloodThinner"
    static let painReliever_KEY = "bowel.painReliever"
    static let hardToCleanOut_KEY = "bowel.hardToCleanOut"
    static let fibers_KEY = "bowel.fibers"
    static let diabetes_KEY = "bowel.diabetes"
    static let METHOD_KEY = "bowel.method"
    
    init() {
        //default
    }
    
    init(location: String, time: NSDate, m1: Bool, m2: Bool, m3: Bool, m4: Bool, m5: Bool) {
        self.location = location
        self.time = time
        self.bloodThinner = m1
        self.painReliever = m2
        self.hardToCleanOut = m3
        self.diabetes = m4
        self.fibers = m5
    }
    
    static func save(location: String, time: NSDate, m1: Bool, m2: Bool, m3: Bool, m4: Bool, m5: Bool) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(location, forKey: LOCATION_KEY)
        userDefault.setObject(time, forKey: TIME_KEY)
        userDefault.setBool(m1, forKey: bloodThinner_KEY)
        userDefault.setBool(m2, forKey: painReliever_KEY)
        userDefault.setBool(m3, forKey: hardToCleanOut_KEY)
        userDefault.setBool(m4, forKey: diabetes_KEY)
        userDefault.setBool(m5, forKey: fibers_KEY)
        userDefault.synchronize()
    }
    
    func save() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(location, forKey: Appointment.LOCATION_KEY)
        userDefault.setObject(time, forKey: Appointment.TIME_KEY)
        userDefault.setBool(bloodThinner, forKey: Appointment.bloodThinner_KEY)
        userDefault.setBool(painReliever, forKey: Appointment.painReliever_KEY)
        userDefault.setBool(hardToCleanOut, forKey: Appointment.hardToCleanOut_KEY)
        userDefault.setBool(diabetes, forKey: Appointment.diabetes_KEY)
        userDefault.setBool(fibers, forKey: Appointment.fibers_KEY)
        userDefault.setInteger(method, forKey: Appointment.METHOD_KEY)
        userDefault.synchronize()
    }
    
    static func load() -> Appointment? {
        let appointment = Appointment()
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        guard let savedLocation = userDefault.stringForKey(LOCATION_KEY) else{
            return nil
        }
        
        guard let savedTime = userDefault.objectForKey(TIME_KEY) as? NSDate else{
            return nil
        }
        
        appointment.location = savedLocation
        appointment.time = savedTime
        appointment.bloodThinner = userDefault.boolForKey(bloodThinner_KEY)
        appointment.painReliever = userDefault.boolForKey(painReliever_KEY)
        appointment.hardToCleanOut = userDefault.boolForKey(hardToCleanOut_KEY)
        appointment.diabetes = userDefault.boolForKey(diabetes_KEY)
        appointment.fibers = userDefault.boolForKey(fibers_KEY)
        appointment.method = userDefault.integerForKey(METHOD_KEY)
        
        return appointment
    }
    
    func getTimeString() -> String?{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(time)
    }
    
    func getDateString() -> String?{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(time)
    }
    
    func getDaysBeforeProcedure() -> Int {
        let calendar = NSCalendar.currentCalendar()
        
        //get the beginning of two dates, ignore time
        let fromDate = calendar.startOfDayForDate(NSDate())
        let toDate = calendar.startOfDayForDate(time)
        
        let difference = calendar.components(.Day, fromDate: fromDate, toDate: toDate, options: [])
        
        return difference.day
    }
    
    static func remove() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey(LOCATION_KEY)
        userDefault.removeObjectForKey(TIME_KEY)
        userDefault.removeObjectForKey(bloodThinner_KEY)
        userDefault.removeObjectForKey(painReliever_KEY)
        userDefault.removeObjectForKey(hardToCleanOut_KEY)
        userDefault.removeObjectForKey(diabetes_KEY)
        userDefault.removeObjectForKey(fibers_KEY)
        userDefault.synchronize()
    }
    
    func getMedicationConflict() -> [String]? {
        var meds = [String]()
        if bloodThinner {
            meds.append("Blood Thinner")
        }
        if painReliever {
            meds.append("Pain Reliever")
        }
        if hardToCleanOut {
            meds.append("Hard To Clean Out")
        }
        if diabetes{
            meds.append("Diabetes Medication")
        }
        if fibers{
            meds.append("Fibers")
        }
        
        if meds.count == 0 {
            return nil
        } else {
            return meds
        }
    }
    
    func takingHardToClean() -> Bool {
        return hardToCleanOut
    }
    
    var methodAsEnum: Instruction.PrepMethods {
        get {
            switch method {
            case 0:
                return Instruction.PrepMethods.MoviPrep
            case 1:
                return Instruction.PrepMethods.Nulytely
            case 2:
                return Instruction.PrepMethods.Prepopik
            case 3:
                return Instruction.PrepMethods.Suprep
            default:
                return .None
            }
        }
    }
    
}
