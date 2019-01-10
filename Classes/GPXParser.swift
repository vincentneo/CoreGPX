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
    
    init(withData data: Data) {
        
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
        parser.parse()
    }
    
    init(withPath path: String) {
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
    
    init(withURL url: URL) {
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
    
    func parsedData() -> GPXRoot {
        let root = GPXRoot()
        
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
        
        print(element)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isWaypoint {
            switch element {
            case "ele":
                waypoint.elevation = value(from: string)!
            case "magvar":
                waypoint.magneticVariation = value(from: string)!
            case "geoidheight":
                waypoint.geoidHeight = value(from: string)!
            case "name":
                waypoint.name = string
            case "desc":
                waypoint.desc = string
            case "source":
                waypoint.source = string
            case "sat":
                waypoint.satellites = value(from: string)!
            case "hdop":
            case "vdop":
            case "pdop":
            case "ageofdgpsdata":
            case "dgpsid":
            }
            /*
            <ele>0.000000</ele>
            <magvar>0.000000</magvar>
            <geoidheight>0.000000</geoidheight>
            <name>8:02:35 pm</name>
            <desc>3 Jan 2019 at 8:02:35 pm</desc>
            <source>0.000000</source>
            <sat>0.000000</sat>
            <hdop>0.000000</hdop>
            <vdop>0.000000</vdop>
            <pdop>0.000000</pdop>
            <ageofdgpsdata>0.000000</ageofdgpsdata>
            <dgpsid>0.000000</dgpsid>
            <extensions>
            </extensions>
 */
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "metadata":
            isMetadata = false
        case "wpt":
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
