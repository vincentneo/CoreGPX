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
    var latitude = CGFloat()
    var longitude = CGFloat()
    
    public var metadata: GPXMetadata? = GPXMetadata()
    public var waypoints = [GPXWaypoint]()
    public var routes = [GPXRoute]()
    public var tracks = [GPXTrack]()
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
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName
        
        switch elementName {
        case "metadata":
            isMetadata = true
        case "wpt":
            isWaypoint = true
            latitude = attributeDict ["lat:"]
        case "rte":
            isRoute = true
        case "trk":
            isTrack = true
        case "extensions":
            isExtension = true
        default: ()
        }
        print(element)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "wpt" {
            
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "metadata":
            isMetadata = false
        case "wpt":
            isWaypoint = false
        case "rte":
            isRoute = false
        case "trk":
            isTrack = false
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
