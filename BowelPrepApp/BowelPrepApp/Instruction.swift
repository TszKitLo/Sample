//
//  Instruction.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/20/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation

class Instruction {
    
    static var instructions = [
        "Day 0": [],
        "Day 1": ["Day 1 Instruction 1", "Day 1 Instruction 2", "Day 1 Instruction 3", "Day 1 Instruction 4", "Day 1 Instruction 5", "Day 1 Instruction 6"],
        "Day 2": ["Day 2 Instruction 1", "Day 2 Instruction 2", "Day 2 Instruction 3"],
        "General": ["General Instruction 1", "General Instruction 2", "General Instruction 3"]
    ]
    
    static var instructionsBackup = [
        "Day 0": [],
        "Day 1": ["Day 1 Instruction 1", "Day 1 Instruction 2", "Day 1 Instruction 3", "Day 1 Instruction 4", "Day 1 Instruction 5", "Day 1 Instruction 6"],
        "Day 2": ["Day 2 Instruction 1", "Day 2 Instruction 2", "Day 2 Instruction 3"],
        "General": ["General Instruction 1", "General Instruction 2", "General Instruction 3"]
    ]
    
    static func getInstructionForIndex(index: String, method: PrepMethods) -> [String]! {
        addPrepMethodInstructions(method)
        return instructions[index]
    }
    
    static func getInstructionForDay(day: Int, method: PrepMethods) -> [String]? {
        addPrepMethodInstructions(method)
        if day == 0{
            return instructions["Day 0"]
        }else if day == 1{
            return instructions["Day 1"]
        } else if day <= 5 && day >= 2 {
            //day 2, 3, 4, 5 correspond to day 2
            return instructions["Day 2"]
        } else {
            //show general by default
            return instructions["General"]
        }
    }
    
    static func getInstructionIndexForDay(day: Int) -> String! {
        if day < 3 && day > 0{
            //day 1, 2 correspond to Day 1, Day 2 in instruction dictionary
            return "Day \(day)"
        } else if day <= 5 && day >= 3 {
            //day 3, 4, 5 correspond to day 2
            return "Day 2"
        } else {
            //show general by default
            return "General"
        }
    }
    
    static func hasInstructionToday(day: Int) -> Bool {
        return day > 0 && day <= 5
    }
    
    
    enum PrepMethods {
        case MoviPrep
        case Nulytely
        case Prepopik
        case Suprep
        case Halflytely
        case None
    }
    
    static func addPrepMethodInstructions(method: PrepMethods) {
        instructions = instructionsBackup
        switch method {
        case .MoviPrep:
            instructions["Day 1"]?.append("moviprep.5pm".localized())
            instructions["Day 0"]?.append("moviprep.procedureTime".localized())
        case .Nulytely:
            instructions["Day 1"]?.append("nuly.5pm".localized())
            instructions["Day 0"]?.append("nuly.procedureTime".localized())
        case .Prepopik:
            instructions["Day 1"]?.append("prepopik.5pm".localized())
            instructions["Day 0"]?.append("prepopik.procedureTime".localized())
        case .Suprep:
            instructions["Day 1"]?.append("suprep.5pm".localized())
            instructions["Day 0"]?.append("suprep.procedureTime".localized())
        case .Halflytely:
            instructions["Day 1"]?.append("halflytely.5pm".localized())
            instructions["Day 0"]?.append("halflytely.procedureTime".localized())
        case .None:
            break
        }
        
    }
}