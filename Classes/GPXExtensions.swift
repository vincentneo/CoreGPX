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
    
    var attributes = [String : String]()
    
    // MARK:- Initializer
    public required init() {
        super.init()
    }
    
    // MARK:- Tag
    override func tagName() -> String {
        return "extensions"
    }
    
    init(with Dictionary: [String : String]) {
        self.attributes = Dictionary
    }
    
    // MARK:- GPX
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
    }
}
