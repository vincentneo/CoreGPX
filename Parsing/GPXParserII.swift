//
//  GPXParserII.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//

import Foundation

public class GPXParserII: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    
    func parse(_ data: Data) {
        stack = [GPXRawElement]()
        stack.append(documentRoot)
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    public func parse(_ url: URL) -> [GPXRawElement] {
        stack = [GPXRawElement]()
        stack.append(documentRoot)
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        return stack
    }
    
    public init(_ url: URL) {
        super.init()
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        stack = [GPXRawElement]()
        stack.append(documentRoot)
        parser.parse()
    }
    
    // MARK:- private
    fileprivate var documentRoot = GPXRawElement(name: "GPXRoot")
    public var stack = [GPXRawElement]()
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = GPXRawElement(name: elementName)
        if !attributeDict.isEmpty {
            node.attributes = attributeDict
        }
        
        let parentNode = stack.last
        
        node.parent = parentNode
        parentNode?.children.append(node)
        stack.append(node)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if let text = stack.last?.text {
            stack.last?.text = text + foundString
        } else {
            stack.last?.text = "" + foundString
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        stack.last?.text = stack.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        stack.removeLast()
    }
    
    public func convertToGPX() -> GPXRoot? {
        guard let firstTag = stack.first else { return nil }
        guard let rawGPX = firstTag.children.first else { return nil }
        
        let root = GPXRoot() // to be returned via function.
        
        for child in rawGPX.children {
            let name = child.name
            
            switch name {
            case "metadata":
                let metadata = GPXMetadata(raw: child)
                root.metadata = metadata
            case "wpt":
                let waypoint = GPXWaypoint(raw: child)
                root.add(waypoint: waypoint)
            case "rte":
                let route = GPXRoute(raw: child)
                root.add(route: route)
            case "trk":
                let track = GPXTrack(raw: child)
                root.add(track: track)
            case "extensions":
                let extensions = GPXExtensions()
                root.extensions = extensions
            default: continue
            }
        }
        
        return root
    }
}
