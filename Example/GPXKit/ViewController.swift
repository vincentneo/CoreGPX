//
//  ViewController.swift
//  GPXKit
//
//  Created by vincentneo on 11/05/2018.
//  Copyright (c) 2018 vincentneo. All rights reserved.
//

import UIKit
import GPXKit

class ViewController: UIViewController {
    
    var tracks = [GPXTrack]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //let url:String="https://gist.githubusercontent.com/cly/bab1a4f982d43bcc53ff32d4708b8a77/raw////68f4f73aa30a7bdc4100395e8bf18bf81e1f6377/sample.gpx"
        let urlTrack : String = "https://raw.githubusercontent.com/gps-touring/sample-gpx/master/BrittanyJura/Courgenay_Ballon-DAlsace.gpx"
        
        //let urlpath     = Bundle.main.path(forResource: "test", ofType: "gpx")
        let urlToSend: URL = URL(string: urlTrack)!
        
        self.tracks = GPXParser(withURL: urlToSend).parsedData().tracks
        for track in self.tracks {
            for tracksegment in track.tracksegments {
                for trackpoint in tracksegment.trackpoints {
                    print(trackpoint.latitude)
                }
            }
        }
        
        /*
        for waypoint in self.waypoints {
            print(waypoint.latitude)
        }
        */
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

