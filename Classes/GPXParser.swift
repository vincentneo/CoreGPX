//
//  GPXParser.swift
//  GPXKit
//
//  Created by Vincent on 2/11/18.
//  

import UIKit

open class GPXParser: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    
    // MARK:- Init
    
    public init(withData data: Data) {
        
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
        parser.parse()
    }
    
    public init(withPath path: String) {
        self.parser = XMLParser()
        super.init()
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            self.parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        catch {
            print(error)
        }
    }
    
    public init(withURL url: URL) {
        self.parser = XMLParser()
        super.init()
        do {
            let data = try Data(contentsOf: url)
            self.parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        catch {
            print(error)
        }
    }
    
    // MARK:- GPX Parsing
    
    var element = String()
    var latitude: CGFloat? = CGFloat()
    var longitude: CGFloat? = CGFloat()
    var latitudeString: String? = String()
    var longitudeString: String? = String()
    
    // Elements
    var waypoint = GPXWaypoint()
    var route = GPXRoute()
    var routepoint = GPXRoutePoint()
    var track = GPXTrack()
    var tracksegment = GPXTrackSegment()
    var trackpoint = GPXTrackPoint()
    
    // Arrays of elements
    var waypoints = [GPXWaypoint]()
    var routes = [GPXRoute]()
    var routepoints = [GPXRoutePoint]()
    
    var tracks = [GPXTrack]()
    var tracksegements = [GPXTrackSegment]()
    var trackpoints = [GPXTrackPoint]()
    
    var metadata: GPXMetadata? = GPXMetadata()
    var extensions: GPXExtensions? = GPXExtensions()
    
    var isWaypoint: Bool = false
    var isMetadata: Bool = false
    var isRoute: Bool = false
    var isRoutePoint: Bool = false
    var isTrack: Bool = false
    var isTrackSegment: Bool = false
    var isTrackPoint: Bool = false
    var isExtension: Bool = false
    
    func value(from string: String?) -> CGFloat? {
        if string != nil {
            if let number = NumberFormatter().number(from: string!) {
                return CGFloat(number.doubleValue)
            }
        }
        return nil
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName
        
        switch elementName {
        case "wpt":
            isWaypoint = true
            latitudeString =  attributeDict ["lat"]
            longitudeString = attributeDict ["lon"]
            //latitude = value(from: attributeDict ["lat"])
            //longitude = value(from: attributeDict ["lon"])
        case "trk":
            isTrack = true
        case "trkseg":
            isTrackSegment = true
        case "trkpt":
            isTrackPoint = true
            latitudeString =  attributeDict ["lat"]
            longitudeString = attributeDict ["lon"]
            //latitude = value(from: attributeDict ["lat"])
            //longitude = value(from: attributeDict ["lon"])
        case "rte":
            isRoute = true
        case "rtept":
            isRoutePoint = true
        case "metadata":
            isMetadata = true
        case "extensions":
            isExtension = true
        default: ()
        }

    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let foundString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isWaypoint || isTrackPoint || isRoutePoint {
            waypoint.latitudeString = latitudeString!
            waypoint.longitudeString = longitudeString!
            if foundString.isEmpty == false {
                switch element {
                case "ele":
                    self.waypoint.elevationString = foundString
                case "time":
                    self.waypoint.timeString = foundString
                case "magvar":
                    self.waypoint.magneticVariationString = foundString
                case "geoidheight":
                    self.waypoint.geoidHeightString = foundString
                case "name":
                    self.waypoint.name = foundString
                case "desc":
                    self.waypoint.desc = foundString
                case "source":
                    self.waypoint.source = foundString
                case "sat":
                    self.waypoint.satellitesString = foundString
                case "hdop":
                    self.waypoint.hdopString = foundString
                case "vdop":
                    self.waypoint.vdopString = foundString
                case "pdop":
                    self.waypoint.pdopString = foundString
                case "ageofdgpsdata":
                    self.waypoint.ageofDGPSDataString = foundString
                case "dgpsid":
                    self.waypoint.DGPSidString = foundString
                default: ()
                }
            }
        }
        if isMetadata {
            if foundString.isEmpty != false {
                switch element {
                case "name":
                    self.metadata!.name = foundString
                case "desc":
                    self.metadata!.desc = foundString
                case "time":
                    self.metadata!.set(date: foundString)
                case "keyword":
                    self.metadata!.keyword = foundString
                // author, copyright, link, bounds, extensions not implemented.
                default: ()
                }
            }
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            
        case "metadata":
            isMetadata = false
            
        case "wpt":
            let tempWaypoint = GPXWaypoint()
            
            // copy values
            tempWaypoint.latitudeString = self.waypoint.latitudeString
            tempWaypoint.longitudeString = self.waypoint.longitudeString
            tempWaypoint.elevationString = self.waypoint.elevationString
            tempWaypoint.timeString = self.waypoint.timeString
            tempWaypoint.magneticVariationString = self.waypoint.magneticVariationString
            tempWaypoint.geoidHeightString = self.waypoint.geoidHeightString
            tempWaypoint.name = self.waypoint.name
            tempWaypoint.desc = self.waypoint.desc
            tempWaypoint.source = self.waypoint.source
            tempWaypoint.satellitesString = self.waypoint.satellitesString
            tempWaypoint.hdopString = self.waypoint.hdopString
            tempWaypoint.vdopString = self.waypoint.vdopString
            tempWaypoint.pdopString = self.waypoint.pdopString
            tempWaypoint.ageofDGPSDataString = self.waypoint.ageofDGPSDataString
            tempWaypoint.DGPSidString = self.waypoint.DGPSidString
            //tempWaypoint.convertStrings()
            
            self.waypoints.append(tempWaypoint)
            // clear values
            isWaypoint = false
            latitude = nil
            longitude = nil
            
        case "rte":
            self.route.add(routepoints: routepoints)
            let tempTrack = GPXRoute()
            tempTrack.routepoints = self.route.routepoints
            self.routes.append(route)
            
            // clear values
            isRoute = false
            
        case "rtept":
            
            let tempRoutePoint = GPXRoutePoint()
            
            // copy values
            tempRoutePoint.latitudeString = self.waypoint.latitudeString
            tempRoutePoint.longitudeString = self.waypoint.longitudeString
            tempRoutePoint.elevationString = self.waypoint.elevationString
            tempRoutePoint.timeString = self.waypoint.timeString
            tempRoutePoint.magneticVariationString = self.waypoint.magneticVariationString
            tempRoutePoint.geoidHeightString = self.waypoint.geoidHeightString
            tempRoutePoint.name = self.waypoint.name
            tempRoutePoint.desc = self.waypoint.desc
            tempRoutePoint.source = self.waypoint.source
            tempRoutePoint.satellitesString = self.waypoint.satellitesString
            tempRoutePoint.hdopString = self.waypoint.hdopString
            tempRoutePoint.vdopString = self.waypoint.vdopString
            tempRoutePoint.pdopString = self.waypoint.pdopString
            tempRoutePoint.ageofDGPSDataString = self.waypoint.ageofDGPSDataString
            tempRoutePoint.DGPSidString = self.waypoint.DGPSidString
            tempRoutePoint.convertStrings()
            
            self.routepoints.append(tempRoutePoint)
            
            isRoutePoint = false
        case "trk":
            
            self.track.add(trackSegments: tracksegements)
            
            let tempTrack = GPXTrack()
            tempTrack.tracksegments = self.track.tracksegments
            self.tracks.append(tempTrack)
            
            //clear values
            isTrack = false
            
        case "trkseg":
            self.tracksegment.add(trackpoints: trackpoints)
            
            let tempTrackSegment = GPXTrackSegment()
            tempTrackSegment.trackpoints = self.tracksegment.trackpoints
            self.tracksegements.append(tempTrackSegment)
            
            // clear values
            isTrackSegment = false
            
        case "trkpt":
            
            let tempTrackPoint = GPXTrackPoint()
            
            // copy values
            tempTrackPoint.latitudeString = self.waypoint.latitudeString
            tempTrackPoint.longitudeString = self.waypoint.longitudeString
            tempTrackPoint.elevationString = self.waypoint.elevationString
            tempTrackPoint.timeString = self.waypoint.timeString
            tempTrackPoint.magneticVariationString = self.waypoint.magneticVariationString
            tempTrackPoint.geoidHeightString = self.waypoint.geoidHeightString
            tempTrackPoint.name = self.waypoint.name
            tempTrackPoint.desc = self.waypoint.desc
            tempTrackPoint.source = self.waypoint.source
            tempTrackPoint.satellitesString = self.waypoint.satellitesString
            tempTrackPoint.hdopString = self.waypoint.hdopString
            tempTrackPoint.vdopString = self.waypoint.vdopString
            tempTrackPoint.pdopString = self.waypoint.pdopString
            tempTrackPoint.ageofDGPSDataString = self.waypoint.ageofDGPSDataString
            tempTrackPoint.DGPSidString = self.waypoint.DGPSidString
            //tempTrackPoint.convertStrings()
            
            self.trackpoints.append(tempTrackPoint)
            
            // clear values
            isTrackPoint = false
            latitude = nil
            longitude = nil
        case "extensions":
            isExtension = false
        default: ()
        }
    }
    
    
    // MARK:- Export parsed data
    
    open func parsedData() -> GPXRoot {
        let root = GPXRoot()
        root.metadata = metadata // partially implemented
        root.extensions = extensions // not implemented
        root.add(waypoints: waypoints)
        root.add(routes: routes)
        root.add(tracks: tracks)
        return root
    }

}
