//
//  GPXRoot.swift
//  GPXKit
//
//  Created by Vincent on 5/11/18.
//  

import Foundation

/// Creation of a GPX file starts here
///
/// `GPXRoot` holds all `metadata`, `waypoints`, `tracks`, `routes` and `extensions` types together before being packaged as a GPX file, or formatted as per GPX schema's requirements.
///
open class GPXRoot: GPXElement {

    public var version: String? = "1.1"
    public var creator: String?
    public var metadata: GPXMetadata?
    public var waypoints = [GPXWaypoint]()
    public var routes = [GPXRoute]()
    public var tracks = [GPXTrack]()
    public var extensions: GPXExtensions?
    
    // MARK: GPX v1.1 Namespaces
    
    /// Link to the GPX v1.1 schema
    let schema = "http://www.topografix.com/GPX/1/1"
    /// Link to the schema locations. If extended, the extended schema should be added.
    let schemaLocation = "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"
    /// Link to XML schema instance
    let xsi = "http://www.w3.org/2001/XMLSchema-instance"
    
    // MARK:- Public Initializers
    
    /// for initializing without a creator name
    public required init() {
        super.init()
        creator = "Powered by Open Source CoreGPX Project"
    }
    
    /// for initializing with a creator name
    ///
    /// - Parameters:
    ///    - creator: name of your app, or whichever product that ends up generating a GPX file
    ///
    public init(creator: String) {
        super.init()
        self.creator = creator
    }
    
    // MARK:- Public Methods
    
    /// for saving newly tracked data straight to a GPX file in a directory
    ///
    /// - Parameters:
    ///     - location: a URL where you wish to have the GPX file saved at.
    ///     - fileName: The name of the file which you wish to save as, without extension.
    ///
    public func outputToFile(saveAt location: URL, fileName: String) throws {
        let gpxString = self.gpx()
        let filePath = location.appendingPathComponent("\(fileName).gpx")
        
        do {
            try gpxString.write(to: filePath, atomically: true, encoding: .utf8)
        }
        catch {
            print(error)
            throw error
        }
    }
    
    public func newWaypointWith(latitude: Double, longitude: Double) -> GPXWaypoint {
        let waypoint = GPXWaypoint.init(latitude: latitude, longitude: longitude)
        
        self.add(waypoint: waypoint)
        
        return waypoint
    }
    
    public func add(waypoint: GPXWaypoint?) {
        if let validWaypoint = waypoint {
           self.waypoints.append(validWaypoint)
        }
    }
    
    public func add(waypoints: [GPXWaypoint]) {
        self.waypoints.append(contentsOf: waypoints)
    }
    
    public func remove(waypoint: GPXWaypoint) {
        let contains = waypoints.contains(waypoint)
        if contains == true {
            waypoint.parent = nil
            if let index = waypoints.firstIndex(of: waypoint) {
                self.waypoints.remove(at: index)
            }
        }
    }
    
    public func newRoute() -> GPXRoute {
        let route = GPXRoute()
        
        self.add(route: route)
        
        return route
    }
    
    public func add(route: GPXRoute?) {
        if let validRoute = route {
           self.routes.append(validRoute)
        }
    }
    
    public func add(routes: [GPXRoute]) {
        self.routes.append(contentsOf: routes)
    }
    
    public func remove(route: GPXRoute) {
        let contains = routes.contains(route)
        if contains == true {
            route.parent = nil
            if let index = routes.firstIndex(of: route) {
                self.waypoints.remove(at: index)
            }
        }
    }
    
    public func newTrack() -> GPXTrack {
        let track = GPXTrack()
        
        return track
    }
    
    public func add(track: GPXTrack?) {
        if let validTrack = track {
            self.tracks.append(validTrack)
        }
    }
    
    public func add(tracks: [GPXTrack]) {
        self.tracks.append(contentsOf: tracks)
    }
    
    public func remove(track: GPXTrack) {
        let contains = tracks.contains(track)
        if contains == true {
            track.parent = nil
            if let index = tracks.firstIndex(of: track) {
               self.waypoints.remove(at: index)
            }
        }
    }
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "gpx"
    }
    
    // MARK:- GPX
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        attribute.appendFormat(" xmlns:xsi=\"%@\"", self.xsi)
        attribute.appendFormat(" xmlns=\"%@\"", self.schema)
        attribute.appendFormat(" xsi:schemaLocation=\"%@\"", self.schemaLocation)
        
        if let version = self.version {
            attribute.appendFormat(" version=\"%@\"", version)
        }
        
        if let creator = self.creator {
            attribute.appendFormat(" creator=\"%@\"", creator)
        }
        
        gpx.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n")
        
        gpx.appendFormat("%@<%@%@>\r\n", self.indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        if self.metadata != nil {
            self.metadata?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for waypoint in waypoints {
            waypoint.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for route in routes {
            route.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        for track in tracks {
            track.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        if self.extensions != nil {
            self.extensions?.gpx(gpx, indentationLevel: indentationLevel)
        }
    }
}
