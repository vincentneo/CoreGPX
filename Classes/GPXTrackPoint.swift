//
//  GPXTrackPoint.swift
//  GPXKit
//
//  Created by Vincent on 9/12/18.
//

import UIKit

open class GPXTrackPoint: GPXWaypoint {
    
    public required init() {
        super.init()
    }
    
    // MARK:- Instance
    
    public override init(latitude: CGFloat, longitude: CGFloat) {
        super.init()
    }
    
    public override init(dictionary: [String : String]) {
        //self.formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //self.formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        //self.time = formatter.date(from: dictionary["time"] ?? "") ?? Date()
        super.init()
        self.elevation = number(from: dictionary["ele"])
        self.latitude = number(from: dictionary["lat"])
        self.longitude = number(from: dictionary["lon"])
    }
    
    
    func number(from string: String?) -> CGFloat {
        /*
        if let number = NumberFormatter().number(from: string ?? "") {
            return CGFloat(number.doubleValue)
        }
 */
        return CGFloat(Double(string ?? "") ?? 0)
    }
    
    // MARK:- Tag
    
    override func tagName() -> String! {
        return "trkpt"
    }

}
