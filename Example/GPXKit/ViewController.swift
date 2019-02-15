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
        guard let gpx = GPXParser(withURL: url)?.parsedData() else { return }
        
        self.tracks = gpx.tracks
        self.waypoints = gpx.waypoints
        
        // This example prints all the waypoints's latitude, longitude and date from the GPX file.
        for waypoint in self.waypoints {
            print("waypoint-latitude: \(waypoint.latitude ?? 0)")
            print("waypoint-longitude: \(waypoint.longitude ?? 0)")
            print("waypoint-date: \(waypoint.time ?? Date())")
        }
        
        // This example prints all the trackpoint's latitude, longitude and date from the GPX file.
        for track in self.tracks {
            for tracksegment in track.tracksegments {
                for trackpoint in tracksegment.trackpoints {
                    print("trackpoint-latitude: \(trackpoint.latitude ?? 0)")
                    print("trackpoint-longitude: \(trackpoint.longitude ?? 0)")
                    print("trackpoint-date: \(trackpoint.time ?? Date())")
                }
            }
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

