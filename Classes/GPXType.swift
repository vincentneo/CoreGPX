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
    
    func fix(value: String) -> GPXFix {
        
        if value == "2D" {
            return .TwoDimensional
        }
        else if value == "3D" {
            return .ThreeDimensional
        }
        else if value == "dgps" {
            return .Dgps
        }
        else if value == "pps" {
            return .Pps
        }
        else {
            return .none
        }
        
    }
    
    func value(forFix fix: GPXFix) -> String {
        switch fix {
            case .none:             return "none"
            case .TwoDimensional:   return "2D"
            case .ThreeDimensional: return "3D"
            case .Dgps:             return "dgps"
            case .Pps:              return "pps"
        }
    }
    
    /*
    func dateTime(value: String) -> Date {
        var date: Date
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        //date = formatter.date(from: value ?? "")
        if date != nil {
            return date
        }
    }
    */
    
    func value(forDateTime date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        return formatter.string(from: date)
    }
    
    func nonNegativeIntFrom( string: String) -> Int {
        if let i = Int(string) {
            if i >= 0 {
                return i
            }
        }
        return 0
    }
    
    func value(forNonNegativeInt int: Int) -> String {
        if int >= 0 {
            return String(format: "%ld", int)
        }
        return "0"
    }

}

enum GPXFix: Int {
    case none = 0
    case TwoDimensional, ThreeDimensional, Dgps, Pps
}
