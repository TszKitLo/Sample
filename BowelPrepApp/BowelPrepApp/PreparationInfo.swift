//
//  PreparationInfo.swift
//  BowelPrepApp
//
//  Created by Kevin Huang on 5/19/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit

class PreparationInfo: UIViewController {
    var appointment = Appointment()
    
    @IBOutlet weak var preparationText: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkPreparationMethod()
    }
    
    //methods = ["Moveiprep ©", "Nulytely ®/ GoLYTLELY ®/ Colyte ®", "Prepopik™","SUPREP ®", "Halflytely"]
    func checkPreparationMethod(){
        if Method.methods[self.appointment.method] == "MoviPrep ©" {
   
            self.preparationText.text = "general".localized() + "\n\n" + "moviprep.5pm".localized() + "\n\n" + "moviprep.procedureTime".localized() + "\n\n" + "additionalInfo".localized()
            
        } // end if
        
        else if Method.methods[self.appointment.method] == "Nulytely ®/ GoLYTLELY ®/ Colyte ®" {
        
            self.preparationText.text = "general".localized() + "\n\n" + "nuly.general".localized() + "\n\n" + "nuly.5pm".localized() + "\n\n" + "nuly.procedureTime".localized() + "\n\n" + "additionalInfo".localized()
        } // end else if
        
        else if Method.methods[self.appointment.method] == "Prepopik™" {
            self.preparationText.text = "general".localized() + "\n\n" + "prepopik.5pm".localized() + "\n\n" + "prepopik.procedureTime".localized() + "\n\n" + "additionalInfo".localized()
            
        } // end else if
        
        else if Method.methods[self.appointment.method] == "SUPREP ®" {
            self.preparationText.text = "general".localized() + "\n\n" + "suprep.5pm".localized() + "\n\n" + "suprep.procedureTime".localized() + "\n\n" + "additionalInfo".localized()
            
        } // end else if
            
        else if Method.methods[self.appointment.method] == "Halflytely" {
            self.preparationText.text = "general".localized() + "\n\n" + "halflytely.noon".localized() + "\n\n" + "halflytely.5pm".localized() + "\n\n" + "halflytely.procedureTime".localized() + "\n\n" + "additionalInfo".localized()
            
        } // end else if
        
        else{
            self.preparationText.text = "Please go back and select a valid preparation method."
        }

    } // end checkPreparationMethod()
}