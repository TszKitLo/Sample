//
//  FAQ.swift
//  BowelPrep
//
//  Created by Keith Lo on 10/5/2016.
//  Copyright © 2016 bowelprep. All rights reserved.
//

import Foundation

class FAQ {
    
    enum faqCategory: String {
        case dateOfProcedure = "Day of Procedure"
        case bowelPrepLiquid = "Bowel Prep Liquid"
        case foodAndDrink = "Food and Drink"
        case medication = "Medication"
        case aboutColonoscopy = "About Colonoscopy"
        case addressDirectionCancellation = "Address, Direction, Cancellation"
    }
    
    static let faqKeys: [String : Int] = [
        "dop": 6,
        "bpl": 13,
        "fad": 11,
        "med": 7,
        "acc": 2,
        "adc": 3
    ]
    
    static func createModel(category: faqCategory, question: String, answer: String) -> FAQModel {
        let faqModel = FAQModel()
        faqModel.category = category.rawValue
        faqModel.question = question
        faqModel.answer = answer
        return faqModel
    }
    
    static func getAllFAQs() -> [FAQModel]{
        
        var faqs = [FAQModel]()
        
        for (key, count) in faqKeys {
            for i in 1...count {
                faqs.append(generateModel(key, suffix: i, faqs: faqs))
                
            }
        }
        
        return faqs
    }
    
    static func generateModel(prefix: String, suffix: Int, faqs: [FAQModel]) -> FAQModel{
        var category: faqCategory
        switch prefix {
        case "dop":
            category = .dateOfProcedure
        case "bpl":
            category = .bowelPrepLiquid
        case "fad":
            category = .foodAndDrink
        case "med":
            category = .medication
        case "acc":
            category = .aboutColonoscopy
        case "adc":
            category = .addressDirectionCancellation
        default:
            category = .dateOfProcedure
        }
        let question = "\(prefix).question\(suffix)"
        let answer = "\(prefix).answer\(suffix)"
        return FAQ.createModel(category, question: question, answer: answer)
    }
    
    
    static func totalFaqs() -> Int {
        var total = 0
        for (_, count) in faqKeys {
            total += count
        }
        return total
    }
}
