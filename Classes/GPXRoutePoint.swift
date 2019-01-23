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
    
    public override init(latitude: CGFloat, longitude: CGFloat) {
        super.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK:- Tag
    
    override func tagName() -> String! {
        return "rtept"
    }
}
