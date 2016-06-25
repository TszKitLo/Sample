//
//  MedicationVC.swift
//  BowelPrepApp
//
//  Created by Kevin Huang on 4/15/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import EventKit

class MedicationVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var MedicationsList: UIPickerView!
    
    var medications_bloodThinners = ["Aspirin", "Plavix (Clopidogrel)", "Coumadin (Warfarin)", "Lovenox", "Heparin", "Pradaxa (Dabigatran)", "Effient (Prasugrel)", "Xarelto (Rivaroxaban)", "Eliquis (Apixaban)", "Brilinta (Ticagrelor)"]
    
    var medications_pain = ["Advil", "Aleve", "Motrin", "Ibuprofen", "Naproxen", "Naprosyn", "Indocin", "Indomethacin"]
    
    var medications_hardToClean = ["Iron", "Ferrous sulfate", "Polysaccharide iron complex"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.picker.delegate = self
        //self.picker.dataSource = self
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return medications_bloodThinners.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return medications_bloodThinners[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(medications_bloodThinners[row])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}