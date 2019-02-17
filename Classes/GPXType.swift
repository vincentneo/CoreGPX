//
//  GPXType.swift
//  GPXKit
//
//  Created by Vincent on 2/11/18.
//
//

import Foundation

class GPXType: NSObject {
    
    @available(*, deprecated, message: "function no longer used and will be unsupported in future")
    func value(forLatitude latitude: Double) -> String {
        if -90.0 <= latitude && latitude <= 90.0 {
            return String(format: "%f", latitude)
        }
        else {
            return "0"
        }
    }
    
    @available(*, deprecated, message: "function no longer used and will be unsupported in future")
    func value(forLongitude longitude: Double) -> String {
        if -180.0 <= longitude && longitude <= 180.0 {
            return String(format: "%f", longitude)
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
    
    func dgpsStation(_ value: String?) -> Int {
        let i = Int(value ?? "") ?? 0
        if 0 <= i && i <= 1023 {
            return i
        }
        else {
            return 0
        }
    }
    
    func value(forDgpsStation dgpsStation: Int) -> String {
        if 0 <= dgpsStation && dgpsStation <= 360 {
            return String(format: "%ld", Int32(dgpsStation))
        }
        else {
            return "0"
        }
    }
    
    
    func dateTime(value: String) -> Date? {
      //  var date: Date
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        if let date = formatter.date(from: value) {
            return date
        }
        
        // dateTime（YYYY-MM-DDThh:mm:ss.SSSZ）
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        if let date = formatter.date(from: value) {
            return date
        }
        
        // dateTime（YYYY-MM-DDThh:mm:sszzzzzz)
        if value.count >= 22 {
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'sszzzz"
            let v = (value as NSString).replacingOccurrences(of: ":", with: "", options: [], range: NSMakeRange(22, 1))
            if let date = formatter.date(from: v) {
                return date
            }
        }
        
        // date
        formatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = formatter.date(from: value) {
            return date
        }
        
        // gYearMonth
        formatter.dateFormat = "yyyy'-'MM'"
        if let date = formatter.date(from: value) {
            return date
        }
        
        // gYear
        formatter.dateFormat = "yyyy'"
        if let date = formatter.date(from: value) {
            return date
        }
        
        return nil
        
    }
    
    func value(forDateTime date: Date?) -> String? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        guard let validDate = date else {
            return nil
        }
        
        return formatter.string(from: validDate)
    }
    
    func nonNegativeInt(_ string: String) -> Int {
        if let i = Int(string) {
            if i >= 0 {
                return i
            }
        }
        return 0
    }
    
    func value(forNonNegativeInt int: Int) -> String {
        if int >= 0 {
            return String(format: "%ld", Int32(int))
        }
        return "0"
    }

}

enum GPXFix: Int {
    case none = 0
    case TwoDimensional, ThreeDimensional, Dgps, Pps
}
