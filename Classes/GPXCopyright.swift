//
//  GPXCopyright.swift
//  GPXKit
//
//  Created by Vincent on 22/11/18.
//

import Foundation

/**
 A value type for representing copyright info

 Copyight information also includes additional attributes.
 
 **Supported attributes:**
 - Year of first publication
 - License of the file
 - Author / Copyright Holder's name
 
*/
open class GPXCopyright: GPXElement {
    
    /// Year of the first publication of this copyrighted work.
    ///
    /// This should be the current year.
    ///
    ///     year = Date()
    ///     // year attribute will be current year.
    public var year: Date?
    
    /// License of the file.
    ///
    /// A URL linking to the license's documentation, represented with a `String`
    public var license: String?
    
    /// Author / copyright holder's name.
    ///
    /// Basically, the person who has created this GPX file, which is also the copyright holder, shall them wish to have it as a copyrighted work.
    public var author: String?
    
    // MARK:- Instance
    
    public required init() {
        super.init()
    }
    
    /// Initializes with author
    ///
    /// At least the author name must be valid in order for a `GPXCopyright` to be valid.
    public init(author: String) {
        super.init()
        self.author = author
    }
    
    /// For internal use only
    ///
    /// Initializes a waypoint through a dictionary, with each key being an attribute name.
    ///
    /// - Remark:
    /// This initializer is designed only for use when parsing GPX files, and shouldn't be used in other ways.
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary with a key of an attribute, followed by the value which is set as the GPX file is parsed.
    ///
    init(dictionary: [String : String]) {
        super.init()
        self.year = CopyrightYearParser.parse(dictionary["year"])
        self.license = dictionary["license"]
        self.author = dictionary["author"]
    }
    
    // MARK: Tag
    
    override func tagName() -> String {
        return "copyright"
    }
    
    // MARK: GPX
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let author = author {
            attribute.appendFormat(" author=\"%@\"", author)
        }
        
        gpx.appendFormat("%@<%@%@>\r\n", tagName())
    }
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        self.addProperty(forValue: Convert.toString(from: year), gpx: gpx, tagName: "year", indentationLevel: indentationLevel)
        self.addProperty(forValue: license, gpx: gpx, tagName: "license", indentationLevel: indentationLevel)
    }
}

// MARK:- Year Parser
// code from http://jordansmith.io/performant-date-parsing/
// edited for use in CoreGPX

/// Special parser that only parses year for the copyright attribute when `GPXParser` parses.
fileprivate class CopyrightYearParser {
    
    private static var calendarCache = [Int : Calendar]()
    private static var components = DateComponents()
    
    private static let year = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    
    static func parse(_ yearString: String?) -> Date? {
        guard let NonNilString = yearString else {
            return nil
        }
        
        _ = withVaList([year], { pointer in
                            vsscanf(NonNilString, "%d", pointer)
                            
        })
        
        components.year = year.pointee
        
        if let calendar = calendarCache[0] {
            return calendar.date(from: components)
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendarCache[0] = calendar
        return calendar.date(from: components)
    }
}
