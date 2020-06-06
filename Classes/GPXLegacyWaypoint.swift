//
//  GPXLegacyWaypoint.swift
//  Pods
//
//  Created by Vincent Neo on 6/6/20.
//

import Foundation

public class GPXLegacyWaypoint: GPXElement, GPXWaypointProtocol {
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
    public var fix: GPXFix?
    public var satellites: Int?
    public var horizontalDilution: Double?
    public var verticalDilution: Double?
    public var positionDilution: Double?
    public var ageofDGPSData: Double?
    public var DGPSid: Int?
    
    public var latitude: Double?
    public var longitude: Double?
    
    /// URL of this particular waypoint, if any.
    public var url: URL?
    
    /// Name associated with the given URL.
    public var urlName: String?
    
    override func tagName() -> String {
        return "wpt"
    }
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let latitude = latitude {
            attribute.append(" lat=\"\(latitude)\"")
        }
        
        if let longitude = longitude {
            attribute.append(" lon=\"\(longitude)\"")
        }
        
        gpx.appendOpenTag(indentation: indent(forIndentationLevel: indentationLevel), tag: tagName(), attribute: attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: elevation, gpx: gpx, tagName: "ele", indentationLevel: indentationLevel)
        self.addProperty(forValue: Convert.toString(from: time), gpx: gpx, tagName: "time", indentationLevel: indentationLevel)
        /* add course, speed for trkpt here */
        self.addProperty(forDoubleValue: magneticVariation, gpx: gpx, tagName: "magvar", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: geoidHeight, gpx: gpx, tagName: "geoidheight", indentationLevel: indentationLevel)
        self.addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        self.addProperty(forValue: comment, gpx: gpx, tagName: "cmt", indentationLevel: indentationLevel)
        self.addProperty(forValue: desc, gpx: gpx, tagName: "desc", indentationLevel: indentationLevel)
        self.addProperty(forValue: source, gpx: gpx, tagName: "src", indentationLevel: indentationLevel)

        if let url = url {
            self.addProperty(forValue: url.absoluteString, gpx: gpx, tagName: "url", indentationLevel: indentationLevel)
        }
        self.addProperty(forValue: urlName, gpx: gpx, tagName: "urlname", indentationLevel: indentationLevel)
        self.addProperty(forValue: symbol, gpx: gpx, tagName: "sym", indentationLevel: indentationLevel)
        self.addProperty(forValue: type, gpx: gpx, tagName: "type", indentationLevel: indentationLevel)

        if let fix = self.fix?.rawValue {
           self.addProperty(forValue: fix, gpx: gpx, tagName: "fix", indentationLevel: indentationLevel)
        }

        self.addProperty(forIntegerValue: satellites, gpx: gpx, tagName: "sat", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: horizontalDilution, gpx: gpx, tagName: "hdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: verticalDilution, gpx: gpx, tagName: "vdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: positionDilution, gpx: gpx, tagName: "pdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: ageofDGPSData, gpx: gpx, tagName: "ageofdgpsdata", indentationLevel: indentationLevel)
        self.addProperty(forIntegerValue: DGPSid, gpx: gpx, tagName: "dgpsid", indentationLevel: indentationLevel)
    }
}

public final class GPXLegacyRoutePoint: GPXLegacyWaypoint {
    override func tagName() -> String {
        return "rtept"
    }
}

public final class GPXLegacyTrackPoint: GPXLegacyWaypoint {
    
    public var course: Double?
    public var speed: Double?
    
    override func tagName() -> String {
        return "trkpt"
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: elevation, gpx: gpx, tagName: "ele", indentationLevel: indentationLevel)
        self.addProperty(forValue: Convert.toString(from: time), gpx: gpx, tagName: "time", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: course, gpx: gpx, tagName: "course", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: speed, gpx: gpx, tagName: "speed", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: magneticVariation, gpx: gpx, tagName: "magvar", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: geoidHeight, gpx: gpx, tagName: "geoidheight", indentationLevel: indentationLevel)
        self.addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        self.addProperty(forValue: comment, gpx: gpx, tagName: "cmt", indentationLevel: indentationLevel)
        self.addProperty(forValue: desc, gpx: gpx, tagName: "desc", indentationLevel: indentationLevel)
        self.addProperty(forValue: source, gpx: gpx, tagName: "src", indentationLevel: indentationLevel)

        if let url = url {
            self.addProperty(forValue: url.absoluteString, gpx: gpx, tagName: "url", indentationLevel: indentationLevel)
        }
        self.addProperty(forValue: urlName, gpx: gpx, tagName: "urlname", indentationLevel: indentationLevel)
        self.addProperty(forValue: symbol, gpx: gpx, tagName: "sym", indentationLevel: indentationLevel)
        self.addProperty(forValue: type, gpx: gpx, tagName: "type", indentationLevel: indentationLevel)

        if let fix = self.fix?.rawValue {
           self.addProperty(forValue: fix, gpx: gpx, tagName: "fix", indentationLevel: indentationLevel)
        }

        self.addProperty(forIntegerValue: satellites, gpx: gpx, tagName: "sat", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: horizontalDilution, gpx: gpx, tagName: "hdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: verticalDilution, gpx: gpx, tagName: "vdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: positionDilution, gpx: gpx, tagName: "pdop", indentationLevel: indentationLevel)
        self.addProperty(forDoubleValue: ageofDGPSData, gpx: gpx, tagName: "ageofdgpsdata", indentationLevel: indentationLevel)
        self.addProperty(forIntegerValue: DGPSid, gpx: gpx, tagName: "dgpsid", indentationLevel: indentationLevel)
    }
    
}
