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
        
        let testStr = """
<?xml version="1.0"?>
        <gpx version="1.1" creator="Xcode">
            <trk>
                <extensions>
                    <gpxx:TrackExtension>
                        <gpxx:DisplayColor>DarkGray</gpxx:DisplayColor>
                    </gpxx:TrackExtension>
                </extensions>
                <trkseg>
                    <trkpt lat="37.331705" lon="-122.030237">
                        <ele>10</ele>
                        <time>2014-09-24T14:55:37Z</time>
                    </trkpt>
                </trkseg>
            <trk>
        </gpx>
"""
        
        // GPXRoot object that contains all the data parsed from GPXParser.
        //guard let gpx = GPXParser(withURL: url)?.parsedData() else { return }
        guard let gpx = GPXParser(withRawString: testStr)?.parsedData() else { return }
        
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

