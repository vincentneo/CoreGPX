//
//  GPXWaypoint.swift
//  GPXKit
//
//  Created by Vincent on 19/11/18.
//

import Foundation

/**
 A value type that represents waypoint based off GPX v1.1 schema's `wptType`.
 
 According to the GPX schema, the waypoint type can represent the following:
    - a waypoint
    - a point of interest
    - a named feature on a map
 
 The waypoint should at least contain the attributes of both `latitude` and `longitude` in order to be considered a valid waypoint.
*/
open class GPXWaypoint: GPXElement {
    
    // MARK:- Attributes of a waypoint
    // Documentation for attributes still WORK IN PROGRESS
    
    /// A value type for link properties (see `GPXLink`)
    public var link: GPXLink?
    public var elevation: Double?
    public var time: Date?
    public var magneticVariation: Double?
    public var geoidHeight: Double?
    public var name: String?
    public var comment: String?
    public var desc: String?
    public var source: String?
    public var symbol: String?
    public var type: String?
    public var fix: Int?
    public var satellites: Int?
    public var horizontalDilution: Double?
    public var verticalDilution: Double?
    public var positionDilution: Double?
    public var ageofDGPSData: Double?
    public var DGPSid: Int?
    public var extensions: GPXExtensions?
    public var latitude: Double?
    public var longitude: Double?
    
    // MARK:- Initializers
    
    /// Initialize with current date and time
    ///
    /// The waypoint should be configured appropriately after initializing using this initializer. The `time` attribute will also be set to the time of initializing.
    ///
    /// - Note:
    ///     At least latitude and longitude should be configured as required by the GPX v1.1 schema.
    ///
    public required init() {
        self.time = Date()
        super.init()
    }
    
    /// Initialize with current date and time, with latitude and longitude.
    ///
    /// The waypoint should be configured appropriately after initializing using this initializer. The `time` attribute will also be set to the time of initializing, along with `latitude` and `longitude` attributes.
    ///
    /// - Note:
    ///     Other attributes can still be configured as per normal.
    ///
    /// - Parameters:
    ///     - latitude: latitude value of the waypoint, in `Double` or `CLLocationDegrees`, **WGS 84** datum only. Should be within the ranges of **-90.0 to 90.0**
    ///     - longitude: longitude value of the waypoint, in `Double` or `CLLocationDegrees`, **WGS 84** datum only. Should be within the ranges of **-180.0 to 180.0**
    ///
    public init(latitude: Double, longitude: Double) {
        self.time = Date()
        super.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// For internal use only
    ///
    /// Initializes a waypoint through a dictionary, with each key being an attribute name.
    ///
    /// - Note:
    /// This initializer is designed only for use when parsing GPX files, and shouldn't be used in other ways.
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary with a key of an attribute, followed by the value which is set as the GPX file is parsed.
    ///
    init(dictionary: [String : String]) {
        self.time = ISO8601DateParser.parse(dictionary ["time"])
        super.init()
        self.elevation = number(from: dictionary["ele"])
        self.latitude = number(from: dictionary["lat"])
        self.longitude = number(from: dictionary["lon"])
        self.magneticVariation = number(from: dictionary["magvar"])
        self.geoidHeight = number(from: dictionary["geoidheight"])
        self.name = dictionary["name"]
        self.comment = dictionary["cmt"]
        self.desc = dictionary["desc"]
        self.source = dictionary["src"]
        self.symbol = dictionary["sym"]
        self.type = dictionary["type"]
        self.fix = integer(from: dictionary["fix"])
        self.satellites = integer(from: dictionary["sat"])
        self.horizontalDilution = number(from: dictionary["hdop"])
        self.verticalDilution = number(from: dictionary["vdop"])
        self.positionDilution = number(from: dictionary["pdop"])
        self.DGPSid = integer(from: dictionary["dgpsid"])
        self.ageofDGPSData = number(from: dictionary["ageofdgpsdata"])
    }
    
    // MARK:- Internal Methods
    
    /// For conversion from optional `String` type to optional `Double` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Double` that will be nil if input `String` is nil.
    ///
    func number(from string: String?) -> Double? {
        guard let NonNilString = string else {
            return nil
        }
        return Double(NonNilString)
    }
    
    /// For conversion from optional `String` type to optional `Int` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Int` that will be nil if input `String` is nil.
    ///
    func integer(from string: String?) -> Int? {
        guard let NonNilString = string else {
            return nil
        }
        return Int(NonNilString)
    }
    
    // MARK:- Public Methods
    
    /// for initializing a `GPXLink` with href, which is added to this point type as well.
    ///   - Parameters:
    ///        - href: a URL hyperlink as a `String`
    ///
    /// This method works by initializing a new `GPXLink`, adding to this point type, then return the `GPXLink`
    ///
    ///   - Warning: Will be deprecated starting version 0.5.0
    @available(*, deprecated, message: "Initialize GPXLink first then, add it to this point type instead.")
    open func newLink(withHref href: String) -> GPXLink {
        let link = GPXLink(withHref: href)
        self.link = link
        return link
    }
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "wpt"
    }
    
    // MARK:- GPX
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if latitude != nil {
            attribute.appendFormat(" lat=\"%f\"", latitude!)
        }
        
        if longitude != nil {
            attribute.appendFormat(" lon=\"%f\"", longitude!)
        }
        
        gpx.appendFormat("%@<%@%@>\r\n", indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        self.addProperty(forDoubleValue: elevation, gpx: gpx, tagName: "ele", indentationLevel: indentationLevel)
        self.addProperty(forValue: GPXType().value(forDateTime: time), gpx: gpx, tagName: "time", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: magneticVariation, gpx: gpx, tagName: "magvar", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: geoidHeight, gpx: gpx, tagName: "geoidheight", indentationLevel: indentationLevel)
        self.addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        self.addProperty(forValue: comment, gpx: gpx, tagName: "cmt", indentationLevel: indentationLevel)
        self.addProperty(forValue: desc, gpx: gpx, tagName: "desc", indentationLevel: indentationLevel)
        self.addProperty(forValue: source, gpx: gpx, tagName: "source", indentationLevel: indentationLevel)
        
        if self.link != nil {
            self.link?.gpx(gpx, indentationLevel: indentationLevel)
        }
 
        self.addProperty(forValue: symbol, gpx: gpx, tagName: "sym", indentationLevel: indentationLevel)
        self.addProperty(forValue: type, gpx: gpx, tagName: "type", indentationLevel: indentationLevel)
        self.addProperty(forIntegerValue: fix, gpx: gpx, tagName: "source", indentationLevel: indentationLevel)
        self.addProperty(forIntegerValue: satellites, gpx: gpx, tagName: "sat", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: horizontalDilution, gpx: gpx, tagName: "hdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: verticalDilution, gpx: gpx, tagName: "vdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: positionDilution, gpx: gpx, tagName: "pdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: ageofDGPSData, gpx: gpx, tagName: "ageofdgpsdata", indentationLevel: indentationLevel)
        self.addProperty(forIntegerValue: DGPSid, gpx: gpx, tagName: "dgpsid", indentationLevel: indentationLevel)
        
        if self.extensions != nil {
            self.extensions?.gpx(gpx, indentationLevel: indentationLevel)
        }
    }
}


// MARK:- Date Parser
// code from http://jordansmith.io/performant-date-parsing/
// edited for use in CoreGPX

class ISO8601DateParser {
    
    private static var calendarCache = [Int : Calendar]()
    private static var components = DateComponents()
    
    private static let year = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let month = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let day = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let hour = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let minute = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let second = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    
    static func parse(_ dateString: String?) -> Date? {
        guard let NonNilString = dateString else {
            return nil
        }
        
        _ = withVaList([year, month, day, hour, minute,
                        second], { pointer in
                            vsscanf(NonNilString, "%d-%d-%dT%d:%d:%dZ", pointer)
                            
        })
        
        components.year = year.pointee
        components.minute = minute.pointee
        components.day = day.pointee
        components.hour = hour.pointee
        components.month = month.pointee
        components.second = second.pointee
        
        if let calendar = calendarCache[0] {
            return calendar.date(from: components)
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendarCache[0] = calendar
        return calendar.date(from: components)
    }
}
