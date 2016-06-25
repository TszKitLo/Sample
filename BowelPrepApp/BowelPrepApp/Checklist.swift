//
//  Checklist.swift
//  BowelPrepApp
//
//  Created by Kevin Lee on 4/24/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation

class Checklist {
    static let OneToTwoWeeksBefore = ["1to2wks.item1","1to2wks.item2","1to2wks.item3","1to2wks.item4","1to2wks.item5","1to2wks.item6","1to2wks.item7"]
    static let FiveDaysBefore = ["5daysbefore.item1","5daysbefore.item2"]
    static let OneDayBefore = ["1daybefore.item1","1daybefore.item2"]
    static let DayOfProcedure = ["dayof.item1","dayof.item2","dayof.item3","dayof.item4"]
    var OneToTwoWeeksBeforeChecker = [Bool]()
    var FiveDaysBeforeChecker = [Bool]()
    var OneDayBeforeChecker = [Bool]()
    var DayOfProcedureChecker = [Bool]()
    
    static func getChecklist(today: Int) -> [String]? {
        if(today > 5){
            return OneToTwoWeeksBefore
        }else if (today >= 2 && today <= 5){
            return FiveDaysBefore
        }else if(today == 1){
            return OneDayBefore
        }else if(today == 0){
            return DayOfProcedure
        }else{
            return nil
        }
    }
    
    func saveChecklist(){
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(OneToTwoWeeksBeforeChecker, forKey: "bowel.oneToTwoWeeksChecklist")
        userDefault.setObject(FiveDaysBeforeChecker, forKey: "bowel.fiveDaysBeforeChecklist")
        userDefault.setObject(OneDayBeforeChecker, forKey: "bowel.oneDayBeforeChecklist")
        userDefault.setObject(DayOfProcedureChecker, forKey: "bowel.dayOfProcedureChecklist")
        userDefault.synchronize()
    }
    
    static func getChecklistChecker(today:Int) -> [Bool]?{
        let userDefault = NSUserDefaults.standardUserDefaults()
        if(today > 5){
            return userDefault.arrayForKey("bowel.oneToTwoWeeksChecklist") as? [Bool]
        }else if (today >= 2 && today <= 5){
            return userDefault.arrayForKey("bowel.fiveDaysBeforeChecklist") as? [Bool]
        }else if(today == 1){
            return userDefault.arrayForKey("bowel.oneDayBeforeChecklist") as? [Bool]
        }else if(today == 0){
            return userDefault.arrayForKey("bowel.dayOfProcedureChecklist") as? [Bool]
        }else{
            return nil
        }
    }

}