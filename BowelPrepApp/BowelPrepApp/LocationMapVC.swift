//
//  LocationMapVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 4/1/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import UIKit
import MapKit

class LocationMapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locations = Location.locations
    let regionRadius = 1000
    let latitudeDelta = 0.5
    let longitudeDelta = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        addLocationsToMap()
        
        setInitialLocation()

    }
    
    func setInitialLocation() {
//        let location = locations.first!
//        let geoCoder = CLGeocoder()
        let latitude: CLLocationDegrees = 38.6857
        let longitude: CLLocationDegrees = -121.3722
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.mapView.setRegion(region, animated: true)
//        geoCoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
//            if error != nil {
//                print(error)
//            }
//            
//            if let placemark = placemarks?.first {
//                let latitude = placemark.location?.coordinate.latitude
//                let longitude = placemark.location?.coordinate.longitude
//                let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//                
//                let span = MKCoordinateSpan(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
//                
//                let region = MKCoordinateRegion(center: center, span: span)
//                
//                self.mapView.setRegion(region, animated: true)
//            }
//        })
        
    }
    
    func addLocationsToMap() {
        for location in locations {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                }
                
                if let placemark = placemarks?.first {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (placemark.location?.coordinate)!
                    annotation.title = location
                    self.mapView.addAnnotation(annotation)
                }
            })
        }
    }
    
    
    // add callout accessory to pinviews
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .ContactAdd) as UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // on pinview clicked
    func mapView(MapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let locationString = annotationView.annotation?.title!
            userDefault.setObject(locationString, forKey: "bowel.tempLocationPicked")
            userDefault.synchronize()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("bowel.tempLocationPicked")
        userDefault.synchronize()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}
