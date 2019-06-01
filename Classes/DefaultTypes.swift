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
internal class DefaultTypes {
    
    /// All attributes of a waypoint and its types, in an `Array`.
    static let waypoint = ["time", "ele", "lat", "lon", "magvar", "geoidheight", "name", "cmt", "desc", "src", "sym", "type", "fix", "sat", "hdop", "vdop", "pdop", "dgpsid", "ageofdgpsdata"]
    
    /// All attributes of a metadata, in an `Array`.
    static let metadata = ["name", "desc", "author", "copyright", "link", "time", "keyword", "bounds"]
    
    static let link = ["href", "type", "text"]
    
    static let email = ["id", "domain"]
    
    static let copyright = ["year", "license", "user"]
    
    static let track = ["number", "name", "cmt", "desc", "src", "type"]
    
    
}
