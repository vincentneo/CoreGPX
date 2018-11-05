//
//  GPXType.swift
//  GPXKit
//
//  Created by Vincent on 2/11/18.
//

import UIKit

class GPXType: NSObject {
    
   open func latitude(_ value: String?) -> CGFloat {
        
        let f = CGFloat(Float(value ?? "") ?? 0.0)
        if -90.0 <= f && f <= 90.0 {
            return f
        }
        else {
           return 0.0
        }
        
    }
    
    func value(forLatitude latitude: CGFloat) -> String {
        if -90.0 <= latitude && latitude <= 90.0 {
            return String(format: "%f", latitude)
        }
        else {
            return "0"
        }
    }
    
    func longitude(_ value: String?) -> CGFloat {
        
        let f = CGFloat(Float(value ?? "") ?? 0.0)
        if -180.0 <= f && f <= 180.0 {
            return f
        }
        else {
            return 0.0
        }
        
    }
    
    func value(forLongitude longitude: CGFloat) -> String {
        if -180.0 <= longitude && longitude <= 180.0 {
            return String(format: "%f", longitude)
        }
        else {
            return "0"
        }
    }
    
    func degrees(_ value: String?) -> CGFloat {
        
        let f = CGFloat(Float(value ?? "") ?? 0.0)
        if 0 <= f && f <= 360.0 {
            return f
        }
        else {
            return 0.0
        }
    }
    
    func value(forDegrees degrees: CGFloat) -> String {
        if 0 <= degrees && degrees <= 360 {
            return String(format: "%f", degrees)
        }
        else {
            return "0"
        }
    }
    
    

}
