//
//  GPXParser.swift
//  GPXKit
//
//  Created by Vincent on 2/11/18.
//  

import UIKit

open class GPXParser: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    var element = String()
    var dictonary = Dictionary<String,String>()
    var latitude: CGFloat? = CGFloat()
    var longitude: CGFloat? = CGFloat()
    

    public var waypoint = GPXWaypoint()
    public var route = GPXRoute()
    public var track = GPXTrack()
    
    public var waypoints = [GPXWaypoint]()
    public var routes = [GPXRoute]()
    public var tracks = [GPXTrack]()
    
    public var metadata: GPXMetadata? = GPXMetadata()
    public var extensions: GPXExtensions? = GPXExtensions()
    
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
    
    open func parsedData() -> GPXRoot {
        let root = GPXRoot()
        root.add(waypoints: waypoints)
        return root
    }
    
    var isWaypoint: Bool = false
    var isMetadata: Bool = false
    var isRoute: Bool = false
    var isTrack: Bool = false
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
        case "metadata":
            isMetadata = true
        case "wpt":
            isWaypoint = true
            latitude = value(from: attributeDict ["lat"])
            longitude = value(from: attributeDict ["lon"])
        case "rte":
            isRoute = true
        case "trk":
            isTrack = true
        case "trkpt":
            latitude = value(from: attributeDict ["lat"])
            longitude = value(from: attributeDict ["lon"])
        case "extensions":
            isExtension = true
        default: ()
        }

    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isWaypoint {
            waypoint.latitude = latitude
            waypoint.longitude = longitude
            switch element {
            case "ele":
                self.waypoint.elevation = value(from: string)!
            case "time":
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                self.waypoint.time = dateFormatter.date(from: string)!
            case "magvar":
                self.waypoint.magneticVariation = value(from: string)!
            case "geoidheight":
                self.waypoint.geoidHeight = value(from: string)!
            case "name":
                self.waypoint.name = string
            case "desc":
                self.waypoint.desc = string
            case "source":
                self.waypoint.source = string
            case "sat":
                self.waypoint.satellites = Int(value(from: string)!)
            case "hdop":
                self.waypoint.horizontalDilution = value(from: string)!
            case "vdop":
                self.waypoint.verticalDilution = value(from: string)!
            case "pdop":
                self.waypoint.positionDilution = value(from: string)!
            case "ageofdgpsdata":
                self.waypoint.ageofDGPSData = value(from: string)!
            case "dgpsid":
                self.waypoint.DGPSid = Int(value(from: string)!)
            default: ()
            }
            //waypoints.append(waypoint)
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "metadata":
            isMetadata = false
        case "wpt":
            let tempWaypoint = GPXWaypoint()
            
            // copy values
            tempWaypoint.elevation = self.waypoint.elevation
            tempWaypoint.time = self.waypoint.time
            tempWaypoint.magneticVariation = self.waypoint.magneticVariation
            tempWaypoint.geoidHeight = self.waypoint.geoidHeight
            tempWaypoint.name = self.waypoint.name
            tempWaypoint.desc = self.waypoint.desc
            tempWaypoint.source = self.waypoint.source
            tempWaypoint.satellites = self.waypoint.satellites
            tempWaypoint.horizontalDilution = self.waypoint.horizontalDilution
            tempWaypoint.verticalDilution = self.waypoint.verticalDilution
            tempWaypoint.positionDilution = self.waypoint.positionDilution
            tempWaypoint.ageofDGPSData = self.waypoint.ageofDGPSData
            tempWaypoint.DGPSid = self.waypoint.DGPSid
            tempWaypoint.latitude = self.waypoint.latitude
            tempWaypoint.longitude = self.waypoint.longitude
            
            self.waypoints.append(tempWaypoint)
            
            // clear values
            isWaypoint = false
            latitude = nil
            longitude = nil
            
        case "rte":
            isRoute = false
        case "trk":
            isTrack = false
        case "trkpt":
            latitude = nil
            longitude = nil
        case "extensions":
            isExtension = false
        default: ()
        }
    }

    /* MARK: Instance
    
    public func parseGPXAt(url: URL) -> GPXRoot? {
        do {
            let data = try Data(contentsOf: url)
            return self.parseGPXWith(data: data)
        }
        catch {
            print(error)
        }
        return nil
    }
    
    public func parseGPXAt(path: String) -> GPXRoot? {
        
        let url = URL(fileURLWithPath: path)
        return GPXParser().parseGPXAt(url: url)
    }
    
    public func parseGPXWith(string: String) -> GPXRoot? {
        
        let xml = try? TBXML(xmlString: string, error: ())

        if xml?.rootXMLElement != nil {
            return GPXRoot(XMLElement: xml!.rootXMLElement, parent: nil)
        }
        
        return nil
    }
    
    public func parseGPXWith(data: Data) -> GPXRoot? {
     
        let xml = try? TBXML(xmlData: data, error: ())
     
        if xml?.rootXMLElement != nil {
            return GPXRoot(XMLElement: xml?.rootXMLElement, parent: nil)
        }

        return nil
    }
    */
}
