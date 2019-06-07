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
        self.attributes[index][tagName] = "internalParsingIndex \(index)"
    }
    
    public func addChildTag(inIndexOfParent index: Int, withContents contents: [String : String]) {
        if attributes[index].values.contains("internalParsingIndex \(index)") {
            for key in contents.keys {
                self.attributes[index][key] = contents[key]
            }
        }
        else {
            self.attributes.append(contents)
        }
    }
    
    init(dictionary: [String : String]) {
        var dictionary = dictionary
        
        for key in dictionary.keys {
            let strings = key.components(separatedBy: ", ")
            if strings.count == 2 {
                let index = Int(strings[1])!
                while !attributes.indices.contains(index) {
                    attributes.append([String : String]())
                }
                
                attributes[index][strings[0]] = dictionary[key]
            }
            // ignore any key that does not conform to GPXExtension's parsing naming convention.
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
            if attribute.values.contains("internalParsingIndex \(index)") {
                for key in attribute.keys {
                    if attribute[key] == "internalParsingIndex \(index)" {
                        newIndentationLevel += 1
                        gpx.append(String(format: "%@<%@>\r\n", indent(forIndentationLevel: newIndentationLevel), key))
                        parentKey = key
                        hasParentElement = true
                    }
                }
            }
            
            for key in attribute.keys {
                if attribute[key] != "internalParsingIndex \(index)" {
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
