//
//  Util.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/21/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String{
        return NSLocalizedString(self, comment: "")
    }
}

class Util {
    static func flattenStringArray(stringArray: [String], separator: String) -> String {
        var flattenString = ""
        for str in stringArray {
            flattenString += str.localized()
            if str != stringArray.last {
                flattenString += separator
            }
        }
        return flattenString
    }
}

extension UIColor {
    static func primaryBlueColor() -> UIColor {
        return UIColor(red: 74 / 255, green: 144/255, blue: 226/255, alpha: 1)
    }
    
    static func translucentBlueColor() -> UIColor {
        return UIColor(red: 40 / 255, green: 123/255, blue: 221/255, alpha: 1)
    }
}

extension UINavigationBar {
    
    func removeShadow() {
        if let view = removeShadowFromView(self) {
            view.removeFromSuperview()
        }
    }
    func removeShadowFromView(view: UIView) -> UIImageView? {
        if (view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            if let imageView = removeShadowFromView(subView as UIView) {
                return imageView
            }
        }
        return nil
    }
}

struct Constants {
    static let appointmentKey = "bowel.appointment"
    static let patientInfoKey = "bowel.patient"
    static let morning = 8
    static let noon = 12
    static let threePM = 15
    static let fivePM = 17
    static let dailyCategoryIdentifier = "DailyCategory"
    static let generalCategoryIdentifier = "GeneralCategory"
    static let showGeneralKey = "bowel.showGeneral"
}