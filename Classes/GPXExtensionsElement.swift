//
//  GPXExtensionsElement.swift
//  Pods
//
//  Created by Vincent on 14/7/19.
//

import Foundation

public class GPXExtensionsElement: GPXElement, Codable {
    
    public var name: String
    public var text: String?
    public var attributes = [String : String]()
    public var children = [GPXExtensionsElement]()
    
    public subscript(name: String) -> GPXExtensionsElement {
        get {
            for child in children {
                if child.name == name {
                    return child
                }
            }
            return GPXExtensionsElement()
        }
    }
    
    public init(name: String) {
        self.name = name
        super.init()
    }
    
    override func tagName() -> String {
        return name
    }
    
    required init() {
        self.name = "Undefined"
    }
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        for (key, value) in attributes {
            attribute.appendFormat(" %@=\"%@\"", key, value)
        }
        gpx.appendOpenTag(indentation: indent(forIndentationLevel: indentationLevel), tag: tagName(), attribute: attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        if let text = text {
            self.addProperty(forValue: text, gpx: gpx, tagName: tagName(), indentationLevel: indentationLevel)
        }
        for child in children {
            if let text = child.text {
                self.addProperty(forValue: text, gpx: gpx, tagName: child.tagName(), indentationLevel: indentationLevel)
            }
            else {
                child.gpx(gpx, indentationLevel: indentationLevel)
            }
        }
        
    }
}
