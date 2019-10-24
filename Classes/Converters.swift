//
//  Conversions.swift
//  CoreGPX
//
//  Created by Vincent on 21/3/19.
//

import Foundation

/// Provides conversions, when required.
///
/// Meant for internal conversions use only. 
internal final class Convert {
    
    // MARK:- Number conversion
    
    /// For conversion from optional `String` type to optional `Int` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Int` that will be nil if input `String` is nil.
    ///
    static func toInt(from string: String?) -> Int? {
        guard let NonNilString = string else {
            return nil
        }
        return Int(NonNilString)
    }
    
    /// For conversion from optional `String` type to optional `Double` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Double` that will be nil if input `String` is nil.
    ///
    static func toDouble(from string: String?) -> Double? {
        guard let NonNilString = string else {
            return nil
        }
        return Double(NonNilString)
    }
    
    
    
    // MARK:- Date & Time Formatting

    /// Immutable date formatter (UTC Time) for consistency within CoreGPX.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        // Timezone should be 0 as GPX uses UTC time, not local time.
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        return formatter
    }()
    
    /// For conversion from optional `Date` to optional `String`
    ///
    /// - Parameters:
    ///     - date: can be of any date and time, which will be converted to a formatted ISO8601 date and time string.
    ///
    /// - Returns:
    ///     Formatted string according to ISO8601, which is of **"yyyy-MM-ddTHH:mm:ssZ"**
    ///
    /// This method is currently heavily used for generating of GPX files / formatted string, as the native `Date` type must be converted to a `String` first.
    ///
    static func toString(from dateTime: Date?) -> String? {
        
        guard let validDate = dateTime else {
            return nil
        }
        
        return dateFormatter.string(from: validDate)
    }
    
    /// Immutable year formatter (UTC Time) for consistency within CoreGPX.
    private static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        // Timezone should be 0 as GPX uses UTC time, not local time.
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // dateTime（YYYY-MM-DDThh:mm:ssZ）
        formatter.dateFormat = "yyyy"
        
        return formatter
    }()
    
    /// For conversion from optional year `Date` to optional `String`
    ///
    /// - Parameters:
    ///     - date: can be of any year, which will be converted to a string representing the year.
    ///
    /// - Returns:
    ///     Formatted string as per: "yyyy", a year.
    ///
    /// This method is used for generating of GPX files / formatted string if `GPXCopyright` is used. Represents the year of copyright.
    ///
    static func toString(fromYear year: Date?) -> String? {
        
        guard let validYear = year else {
            return nil
        }
        
        return yearFormatter.string(from: validYear)
    }
    
    /// Calculates distance between two coordinate points, returns in metres (m).
    ///
    /// Code from https://github.com/raywenderlich/swift-algorithm-club/tree/master/HaversineDistance
    /// Licensed under MIT license
    static func haversineDistance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double {
        
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        // Converts from degrees to radians
        let dToR = { (angle: Double) -> Double in
            return (angle / 360) * 2 * .pi
        }
        
        let lat1 = dToR(la1)
        let lon1 = dToR(lo1)
        let lat2 = dToR(la2)
        let lon2 = dToR(lo2)
        
        return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
    }
    
    static func getDistance<pt: GPXWaypoint>(from first: pt?, and second: pt?) -> Double? {
        guard let lat1 = first?.latitude, let lon1 = first?.longitude, let lat2 = second?.latitude, let lon2 = second?.longitude else { return nil }
        
        return haversineDistance(la1: lat1, lo1: lon1, la2: lat2, lo2: lon2)
    }
}

