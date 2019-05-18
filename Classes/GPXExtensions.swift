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
    var attributes = [[String : String]]()
    
    // MARK:- Initializer
    public required init() {
        super.init()
    }
    
    // MARK:- Tag
    override func tagName() -> String {
        return "extensions"
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
    
    // MARK:- GPX
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
    }
}
