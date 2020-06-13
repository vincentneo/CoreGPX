//
//  GPXLegacyRoute.swift
//  Pods
//
//  Created by Vincent Neo on 13/6/20.
//

import Foundation

public class GPXLegacyRoute: GPXElement, GPXRouteType {
    
    public var name: String?
    
    /// Additional comment of the route.
    ///
    /// - Important:
    /// Not available in GPX 0.6 and below.
    public var comment: String?
    
    var isVersion1 = true
    
    public var desc: String?
    
    public var source: String?
    
    public var url: URL?
    
    public var urlName: String?
    
    /// Stated in GPX 1.0 schema that it is only *proposed*
    //public var type: String?
    
    public var number: Int?
    
    public var routepoints = [GPXLegacyRoutePoint]()
    
    override func tagName() -> String {
        return "rtept"
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        if isVersion1 {
            addProperty(forValue: comment, gpx: gpx, tagName: "comment", indentationLevel: indentationLevel)
        }
        addProperty(forValue: desc, gpx: gpx, tagName: "desc", indentationLevel: indentationLevel)
        addProperty(forValue: source, gpx: gpx, tagName: "srtc", indentationLevel: indentationLevel)
        addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        
    }
    
}
