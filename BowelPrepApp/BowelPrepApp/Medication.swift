//
//  Medication.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 4/13/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation

class Medication {
    
    static let bloodThinners = ["Aspirin", "Plavix (Clopidogrel)", "Coumadin (Warfarin)", "Lovenox", "Heparin", "Pradaxa", "Effient (Prasugrel)", "Xarelto (Rivaroxaban)", "Eliquis (Apixaban)", "Brilinta (Ticagrelor)"]
    
    static let painRelievers = ["Advil", "Aleve", "Motrin", "Ibuprofen", "Naproxen", "Naprosyn", "Indocin", "Indomethacin"]
    
    static let clean = ["Iron", "Ferrous Sulfate", "Polysaccharide iron complex", "Multivitamin"]
    
    static let fibers = ["Metamucil", "Citrucel", "Benefiber", "Other Similar"]
    
    enum MedicationType: Int {
        case bloodThinner = 0
        case painReliever = 1
        case clean = 2
        case fibers = 3
    }
    
    static func getMedicationList(type: Int) -> [String]{
        switch type {
        case MedicationType.bloodThinner.rawValue:
            return bloodThinners
        case MedicationType.painReliever.rawValue:
            return painRelievers
        case MedicationType.clean.rawValue:
            return clean
        case MedicationType.fibers.rawValue:
            return fibers
        default:
            return bloodThinners
        }
    }
}