//
//  DefaultTypes.swift
//  CoreGPX
//
//  Created by Vincent on 19/5/19.
//

import Foundation

/// For use in checking in `init(dictionary:)`'s extension parsing.
///
/// when initializing various classes using `init(dictionary:)`, the initializer will check against the arrays in this class to ignore default types, such as `"lat"` and `"lon"`.
internal struct DefaultTypes {
    
    /// All attributes of a waypoint and its types, in an `Array`.
    static let waypoint: Set = ["time", "ele", "lat", "lon", "magvar", "geoidheight", "name", "cmt", "desc", "src", "sym", "type", "fix", "sat", "hdop", "vdop", "pdop", "dgpsid", "ageofdgpsdata"]
    
    /// All attributes of a metadata, in an `Array`.
    static let metadata: Set = ["name", "desc", "author", "copyright", "link", "time", "keyword", "bounds"]
    
    static let link: Set = ["href", "type", "text"]
    
    static let email: Set = ["id", "domain"]
    
    static let copyright: Set = ["year", "license", "user"]
    
    static let track:Set = ["number", "name", "cmt", "desc", "src", "type"]
    
    
}
