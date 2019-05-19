//
//  GPXExtensions.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import Foundation

/**
 For adding an extension tag.
 
 If extended, tags should be inbetween the open and close tags of **\<extensions>**
 */
open class GPXExtensions: GPXElement, Codable {
    
    /// attributes will be in format of 
    public var attributes = [[String : String]]()
    
    // MARK:- Initializer
    public required init() {
        super.init()
    }
    
    // MARK:- Tag
    override func tagName() -> String {
        return "extensions"
    }
    
    public init(custom: [[String : String]]) {
        self.attributes = custom
    }
    
    public func insertParentTag(at index: Int, tagName: String) {
        if !attributes.indices.contains(index) {
            attributes.append([String : String]())
        }
        self.attributes[index][tagName] = "index \(index)"
    }
    
    init(dictionary: [String : String]) {

        for key in dictionary.keys {
            let strings = key.components(separatedBy: ", ")
            let index = Int(strings[1])!
            if !attributes.indices.contains(index) {
                attributes.append([String : String]())
            }
            
            attributes[index][strings[0]] = dictionary[key]
        }
        
    }
    private var hasParentTag = false
    func addChildTag(fromIndexOfAttributes index: Int) {
        if attributes[index].values.contains("index \(index)") {
            
        }
    }
    
    // MARK:- GPX
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        var hasParentElement = false
        var parentKey = String()
        var newIndentationLevel = indentationLevel
        var index = Int()
        
        for attribute in attributes {
            if attribute.values.contains("index \(index)") {
                for key in attribute.keys {
                    if attribute[key] == "index \(index)" {
                        newIndentationLevel += 1
                        gpx.append(String(format: "%@<%@>\r\n", indent(forIndentationLevel: newIndentationLevel), key))
                        parentKey = key
                        hasParentElement = true
                    }
                }
            }
            
            for key in attribute.keys {
                if attribute[key] != "index \(index)" {
                    gpx.appendFormat("%@<%@>%@</%@>\r\n", indent(forIndentationLevel: newIndentationLevel + 1), key, attribute[key] ?? "", key)
                }
            }
            
            if hasParentElement {
                gpx.append(String(format: "%@</%@>\r\n", indent(forIndentationLevel: newIndentationLevel), parentKey))
                hasParentElement = false
            }
            // increment index
            index += 1
            
            //reset
            newIndentationLevel = indentationLevel
        }
        
    }
}
