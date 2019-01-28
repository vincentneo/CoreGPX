//
//  GPXRoutePoint.swift
//  GPXKit
//
//  Created by Vincent on 19/11/18.
//

import UIKit

open class GPXRoutePoint: GPXWaypoint {
    
    public required init() {
        super.init()
    }
    
    // MARK:- Instance
    
    func routePoint(with latitude: CGFloat, longitude: CGFloat) -> GPXRoutePoint {
        let routePoint = GPXRoutePoint()
        routePoint.latitude = latitude
        routePoint.longitude = longitude
        
        return routePoint
    }
    
    public override init(dictionary: [String : String]) {
        super.init()
        //self.time = formatter.date(from: dictionary["time"] ?? "")
        self.time = ISO8601DateParser.parse(dictionary ["time"] ?? "")
        self.elevation = GPXType().decimal(dictionary["ele"])
        self.latitude = GPXType().decimal(dictionary["lat"])
        self.longitude = GPXType().decimal(dictionary["lon"])
        //self.time = GPXType().dateTime(value: dictionary["time"]!)
    }
    
    // MARK:- Tag
    
    override func tagName() -> String! {
        return "rtept"
    }
}
