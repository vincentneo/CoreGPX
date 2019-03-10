//
//  GPXBounds.swift
//  GPXKit
//
//  Created by Vincent on 22/11/18.
//

import Foundation

/**
 A value type that represents bounds based off GPX v1.1 schema's `boundsType`.
 
 This is meant for having two pairs of longitude and latitude, signifying the maximum and minimum, defining the extent / boundaries of a particular element.
 */
open class GPXBounds: GPXElement {

    /// Minimum latitude of boundaries to a element.
    public var minLatitude: Double?
    /// Maximum latitude of boundaries to a element.
    public var maxLatitude: Double?
    /// Minimum longitude of boundaries to a element.
    public var minLongitude: Double?
    /// Maximum longitude of boundaries to a element.
    public var maxLongitude: Double?
    
    // MARK:- Instance
    
    public required init() {
        super.init()
    }
    
    /// Initializes with all values
    ///
    /// - Parameters:
    ///     - minLatitude: Minimum latitude
    ///     - maxLatitude: Maximum latitude
    ///     - minLongitude: Minimum longitude
    ///     - maxLongitude: Maximum longitude
    public init(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double) {
        super.init()
        self.minLatitude = minLatitude
        self.maxLatitude = maxLatitude
        self.minLongitude = minLongitude
        self.maxLongitude = maxLongitude
    }
    
    /// For internal use only
    ///
    /// Initializes through a dictionary, with each key being an attribute name.
    ///
    /// - Remark:
    /// This initializer is designed only for use when parsing GPX files, and shouldn't be used in other ways.
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary with a key of an attribute, followed by the value which is set as the GPX file is parsed.
    ///
    init(dictionary: [String : String]) {
        super.init()
        self.minLatitude = number(from: dictionary["minlat"])
        self.maxLatitude = number(from: dictionary["maxlat"])
        self.minLongitude = number(from: dictionary["minlon"])
        self.maxLongitude = number(from: dictionary["maxlon"])
    }
    
    /// For conversion from optional `String` type to optional `Double` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Double` that will be nil if input `String` is nil.
    ///
    func number(from string: String?) -> Double? {
        guard let NonNilString = string else {
            return nil
        }
        return Double(NonNilString)
    }
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "bounds"
    }
    
    // MARK:- GPX
    
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute = NSMutableString()
        
        if let minLatitude = minLatitude {
            attribute.appendFormat(" minlat=\"%f\"", minLatitude)
        }
        if let minLongitude = minLongitude {
            attribute.appendFormat(" minlon=\"%f\"", minLongitude)
        }
        if let maxLatitude = maxLatitude {
            attribute.appendFormat(" maxlat=\"%f\"", maxLatitude)
        }
        if let maxLongitude = maxLongitude {
            attribute.appendFormat(" maxlon=\"%f\"", maxLongitude)
        }
        
        gpx.appendFormat("%@<%@%@>\r\n", indent(forIndentationLevel: indentationLevel))
    }
}
