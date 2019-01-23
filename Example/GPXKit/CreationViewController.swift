//
//  CreationViewController.swift
//  CoreGPX_Example
//
//  Created by Vincent on 22/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

// This is quite a unreal and bad example; will replace this in near future.

import UIKit
import CoreGPX

class CreationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var typeSwitch: UISegmentedControl!
    @IBOutlet weak var elevationField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    var typeSwitchIndex = Int()
    var waypoints = [GPXWaypoint]()
    var trackpoints = [GPXTrackPoint]()
    var gpxString = String()
    
    @IBAction func insertElementButton(_ sender: Any) {
        switch typeSwitchIndex {
        case 0:
            let latitude = GPXType().latitude(latitudeField.text)
            let longitude = GPXType().longitude(longitudeField.text)
            let elevation = value(from: elevationField.text)
            let waypoint = GPXWaypoint(latitude: latitude, longitude: longitude)
            waypoint.elevation = elevation ?? 0
            waypoint.time = Date()
            waypoints.append(waypoint)
            
            //clear fields
            elevationField.text = ""
            latitudeField.text = ""
            longitudeField.text = ""
        case 1:
            let latitude = GPXType().latitude(latitudeField.text)
            let longitude = GPXType().longitude(longitudeField.text)
            let elevation = value(from: elevationField.text)
            let trackpoint = GPXTrackPoint(latitude: latitude, longitude: longitude)
            trackpoint.elevation = elevation ?? 0
            trackpoint.time = Date()
            trackpoints.append(trackpoint)
            
            //clear fields
            elevationField.text = ""
            latitudeField.text = ""
            longitudeField.text = ""
        default: ()
            
        }
    }
    
    @IBAction func outputFileButton(_ sender: Any) {
        let root = GPXRoot(creator: "example app")
        
        let track = GPXTrack()
        let trackseg = GPXTrackSegment()
        trackseg.add(trackpoints: trackpoints)
        track.add(trackSegment: trackseg)
        
        
        root.add(waypoints: waypoints)
        root.add(track: track)
        
        self.gpxString = root.gpx()
        print(gpxString)
    }
    
    @IBAction func segmentHasChanged(_ sender: UISegmentedControl) {
        typeSwitchIndex = sender.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.text = "current date"
        dateField.isEnabled = false
        
        latitudeField.keyboardType = .decimalPad
        longitudeField.keyboardType = .decimalPad
        elevationField.keyboardType = .decimalPad
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func value(from string: String?) -> CGFloat? {
        if string != nil {
            if let number = NumberFormatter().number(from: string!) {
                return CGFloat(number.doubleValue)
            }
        }
        return nil
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
