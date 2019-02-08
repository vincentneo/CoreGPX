//
//  GPXTrackPoint.swift
//  GPXKit
//
//  Created by Vincent on 9/12/18.
//

import Foundation

open class GPXTrackPoint: GPXWaypoint {
    
    public required init() {
        super.init()
    }
    
    // MARK:- Instance
    
    public override init(latitude: Double, longitude: Double) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public override init(dictionary: [String : String]) {
        super.init()
        self.time = ISO8601DateParser.parse(dictionary ["time"])
        waypointProcess.async(flags: .barrier) {
            self.elevation = self.number(from: dictionary["ele"])
            self.latitude = self.number(from: dictionary["lat"])
            self.longitude = self.number(from: dictionary["lon"])
            self.magneticVariation = self.number(from: dictionary["magvar"])
            self.geoidHeight = self.number(from: dictionary["geoidheight"])
            self.name = dictionary["name"]
            self.comment = dictionary["cmt"]
            self.desc = dictionary["desc"]
            self.source = dictionary["src"]
            self.symbol = dictionary["sym"]
            self.type = dictionary["type"]
            self.fix = self.integer(from: dictionary["fix"])
            self.satellites = self.integer(from: dictionary["sat"])
            self.horizontalDilution = self.number(from: dictionary["hdop"])
            self.verticalDilution = self.number(from: dictionary["vdop"])
            self.positionDilution = self.number(from: dictionary["pdop"])
            self.DGPSid = self.integer(from: dictionary["dgpsid"])
        }
    }
    
    // MARK:- Tag
    
    override func tagName() -> String! {
        return "trkpt"
    }
    
}
