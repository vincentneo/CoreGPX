//
//  ViewController.swift
//  GPXKit
//
//  Created by vincentneo on 11/05/2018.
//  Copyright (c) 2018 vincentneo. All rights reserved.
//

import UIKit
import CoreGPX

class ViewController: UIViewController {
    
    var tracks = [GPXTrack]()
    var waypoints = [GPXWaypoint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example of parsing a GPX file from a sample URL
        
        let urlString : String = "https://raw.githubusercontent.com/gps-touring/sample-gpx/master/BrittanyJura/Courgenay_Ballon-DAlsace.gpx"
        let url: URL = URL(string: urlString)!
        
        // GPXRoot object that contains all the data parsed from GPXParser.
        let gpx = GPXParser(withURL: url).parsedData()
        /*
        self.tracks = gpx.tracks
        self.waypoints = gpx.waypoints
        
        // This example prints all the waypoints's latitude, longitude and date from the GPX file.
        for waypoint in self.waypoints {
            print("waypoint-latitude: \(waypoint.latitude!)")
            print("waypoint-longitude: \(waypoint.longitude!)")
            print("waypoint-date: \(waypoint.time)")
        }
        
        // This example prints all the trackpoint's latitude, longitude and date from the GPX file.
        for track in self.tracks {
            for tracksegment in track.tracksegments {
                for trackpoint in tracksegment.trackpoints {
                    print("trackpoint-latitude: \(trackpoint.latitude!)")
                    print("trackpoint-longitude: \(trackpoint.longitude!)")
                    print("trackpoint-date: \(trackpoint.time)")
                }
            }
        }
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

