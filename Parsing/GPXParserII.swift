//
//  GPXParserII.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//

import Foundation

public class GPXParserII: NSObject, XMLParserDelegate {
    
    func parse(_ data: Data) {
        stack = [ParserElement]()
        stack.append(documentRoot)
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    public func parse(_ url: URL) -> [ParserElement] {
        stack = [ParserElement]()
        stack.append(documentRoot)
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
        return stack
    }
    
    // MARK:- private
    fileprivate var documentRoot = ParserElement(name: "GPXRoot")
    public var stack = [ParserElement]()
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = ParserElement(name: elementName)
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
    
    func convertToGPX() {
        guard let gpx = stack.first else { return }
        
        for child in gpx.children {
            let name = child.name
            
            switch name {
            case "metadata":
                let metadata = GPXMetadata()
            default:
                break
            }
        }
    }
}
