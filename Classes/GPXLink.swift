//
//  GPXLink.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import Foundation

/**
 A value type that can hold a web link to a external resource, or external information about a certain attribute.
 
 In addition to having a URL as its attribute, it also accepts the following as child tag:
    - type of content
    - text of web link (probably a description kind of thing)
 */
open class GPXLink: GPXElement {
    
    // MARK:- Properties

    /// Text of hyperlink
    public var text: String?
    
    /// Mime type of content (image/jpeg)
    public var mimetype: String?
    
    /// URL of hyperlink
    public var href: String?
    
    private let commonWebExtensions = ["htm", "html", "asp", "aspx", "php", "cgi"]
   
    // MARK:- Instance
    
    public required init() {
        self.text = String()
        self.mimetype = String()
        self.href = String()
        super.init()
    }
    
    /// ---------------------------------
    /// @name Create Link
    /// ---------------------------------
    
    /** Creates and returns a new link element.
     @param href URL of hyperlink
     @return A newly created link element.*/
    public init(withHref href: String) {
        self.href = href
        self.mimetype = String()
        self.text = String()
    }
    
    public init(withURL url: URL?) {
        guard let isURL = url?.isFileURL else { return }
        if isURL {
            self.href = url?.absoluteString
            guard let pathExtension = url?.pathExtension else { return }
            if commonWebExtensions.contains(pathExtension) {
                self.mimetype = "Website"
            }
        }
    }
    
    init(dictionary: [String : String]) {
        self.href = dictionary["href"]
        self.mimetype = dictionary["mimetype"]
        self.text = dictionary["text"]
    }
    
    
    // MARK:- Public Methods
    
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "link"
    }
   
    
    // MARK:- GPX
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let href = href {
            attribute.appendFormat(" href=\"%@\"", href)
        }
        gpx.appendFormat("%@<%@%@>\r\n", indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        self.addProperty(forValue: text, gpx: gpx, tagName: "text", indentationLevel: indentationLevel)
        self.addProperty(forValue: mimetype, gpx: gpx, tagName: "type", indentationLevel: indentationLevel)
    }
}
