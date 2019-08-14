//
//  GPXMetadata.swift
//  GPXKit
//
//  Created by Vincent on 22/11/18.
//

import Foundation

/**
 A value type that represents the metadata header of a GPX file.
 
 Information about the GPX file should be stored here.
 - Supported Info types:
    - Name
    - Description
    - Author Info
    - Copyright
    - Date and Time
    - Keyword
    - Bounds
    - Also supports extensions
 */
open class GPXMetadata: GPXElement, Codable {
    
    /// Name intended for the GPX file.
    public var name: String?
    
    /// Description about what the GPX file is about.
    public var desc: String?
    
    /// Author, or the person who created the GPX file.
    ///
    /// Includes other information regarding the author (see `GPXAuthor`)
    public var author: GPXAuthor?
    
    /// Copyright of the file, if required.
    public var copyright: GPXCopyright?
    
    /// A web link, usually one with information regarding the GPX file.
    public var link: GPXLink?
    
    /// Date and time of when the GPX file is created.
    public var time: Date?
    
    /// Keyword of the GPX file.
    public var keyword: String?

    /// Boundaries of coordinates of the GPX file.
    public var bounds: GPXBounds?
    
    /// Extensions to standard GPX, if any.
    public var extensions: GPXExtensions?
    
    
    // MARK:- Instance
    
    public override init() {
        self.time = Date()
        super.init()
    }
    
    /// For internal use only
    ///
    /// Initializes the metadata using a dictionary, with each key being an attribute name.
    ///
    /// - Remark:
    /// This initializer is designed only for use when parsing GPX files, and shouldn't be used in other ways.
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary with a key of an attribute, followed by the value which is set as the GPX file is parsed.
    ///
    init(dictionary: inout [String : String]) {
        self.time = GPXDateParser.parse(date: dictionary.removeValue(forKey: "time"))
        super.init()
        dictionary.removeValue(forKey: self.tagName())
        self.name = dictionary.removeValue(forKey: "name")
        self.desc = dictionary.removeValue(forKey: "desc")
        self.keyword = dictionary.removeValue(forKey: "keyword")
        
        if dictionary.count > 0 {
            //self.extensions = GPXExtensions(dictionary: dictionary)
        }
    }
    
    init(raw: GPXRawElement) {
        super.init()
        for child in raw.children {
            let text = child.text
            
            switch child.name {
            case "name":        self.name = text
            case "desc":        self.desc = text
            case "author":      self.author = GPXAuthor(raw: child)
            case "copyright":   self.copyright = GPXCopyright(raw: child)
            case "link":        self.link = GPXLink(raw: child)
            case "time":        self.time = GPXDateParser.parse(date: text)
            case "keywords":    self.keyword = text
            case "bounds":      self.bounds = GPXBounds(raw: child)
            case "extensions":  self.extensions = GPXExtensions(raw: child)
            default: continue
            }
        }
    }
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "metadata"
    }
    
    // MARK:- GPX
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        self.addProperty(forValue: name, gpx: gpx, tagName: "name", indentationLevel: indentationLevel)
        self.addProperty(forValue: desc, gpx: gpx, tagName: "desc", indentationLevel: indentationLevel)
        
        if author != nil {
            self.author?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        if copyright != nil {
            self.copyright?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        if link != nil {
            self.link?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        self.addProperty(forValue: Convert.toString(from: time), gpx: gpx, tagName: "time", indentationLevel: indentationLevel, defaultValue: "0")
        self.addProperty(forValue: keyword, gpx: gpx, tagName: "keyword", indentationLevel: indentationLevel)
        
        if bounds != nil {
            self.bounds?.gpx(gpx, indentationLevel: indentationLevel)
        }
        
        if extensions != nil {
            self.extensions?.gpx(gpx, indentationLevel: indentationLevel)
        }
    }
}

extension GPXMetadata: Hashable {
    public static func == (lhs: GPXMetadata, rhs: GPXMetadata) -> Bool {
        return lhs.name == rhs.name
            && lhs.desc == rhs.desc
            && lhs.author == rhs.author
            && lhs.copyright == rhs.copyright
            && lhs.link == rhs.link
            && lhs.time == rhs.time
            && lhs.keyword == rhs.keyword
            && lhs.bounds == rhs.bounds
            && lhs.extensions == rhs.extensions
            && lhs.tagName() == rhs.tagName()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(desc)
        hasher.combine(author)
        hasher.combine(copyright)
        hasher.combine(link)
        hasher.combine(time)
        hasher.combine(keyword)
        hasher.combine(bounds)
        hasher.combine(extensions)
        hasher.combine(tagName())
        
    }
}
