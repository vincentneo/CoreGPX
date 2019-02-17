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
            let latitude = Double(latitudeField.text ?? "")
            let longitude = Double(longitudeField.text ?? "")
            let elevation = value(from: elevationField.text)
            let waypoint = GPXWaypoint(latitude: latitude ?? 0, longitude: longitude ?? 0)
            waypoint.elevation = elevation ?? 0
            waypoint.time = Date()
            waypoints.append(waypoint)
            
            //clear fields
            elevationField.text = ""
            latitudeField.text = ""
            longitudeField.text = ""
        case 1:
            let latitude = Double(latitudeField.text ?? "")
            let longitude = Double(longitudeField.text ?? "")
            let elevation = value(from: elevationField.text)
            let trackpoint = GPXTrackPoint(latitude: latitude ?? 0, longitude: longitude ?? 0)
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
        let root = GPXRoot(creator: "example app, output as String")
        
        let track = GPXTrack()
        let trackseg = GPXTrackSegment()
        trackseg.add(trackpoints: trackpoints)
        track.add(trackSegment: trackseg)
        
        
        root.add(waypoints: waypoints)
        root.add(track: track)
        
        self.gpxString = root.gpx()
        print(gpxString)
    }
    
    @IBAction func outputAsFileButton(_ sender: Any) {
        let root = GPXRoot(creator: "example app, output as File")
        
        let track = GPXTrack()
        let trackseg = GPXTrackSegment()
        trackseg.add(trackpoints: trackpoints)
        track.add(trackSegment: trackseg)
        
        
        root.add(waypoints: waypoints)
        root.add(track: track)
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        do {
            try root.outputToFile(saveAt: url, fileName: "test")
        }
        catch {
            print(error)
        }
        let file = url.appendingPathComponent("test.gpx")
        
        let activityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        /*
        do {
            try FileManager().removeItem(at: file)
        }
        catch {
            print(error)
        }
 */
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
    
    func value(from string: String?) -> Double? {
        if let validStr = string {
            return Double(validStr)
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
