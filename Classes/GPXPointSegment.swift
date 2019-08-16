//
//  GPXPointSegment.swift
//  GPXKit
//
//  Created by Vincent on 23/11/18.
//

import Foundation

/**
 * This class (`ptsegType`) is added to conform with the GPX v1.1 schema.
 
 `ptsegType` of GPX schema. Not supported in GPXRoot, nor GPXParser's parsing.
 */
open class GPXPointSegment: GPXElement, Codable {
    
    /// points of segment
    public var points = [GPXPoint]()
    
    // MARK:- Instance
    
    /// Default initializer.
    public override init() {
        super.init()
    }
    
    init(raw: GPXRawElement) {
        for child in raw.children {
            if child.name == "pt" {
                points.append(GPXPoint(raw: child))
            }
            else { break }
        }
    }
    
    // MARK:- Public Methods
    
    /// Adds a new point to segment, and returns the added point.
    public func newPoint(with latitude: Double, longitude: Double) -> GPXPoint {

        let point = GPXPoint(latitude: latitude, longitude: longitude)
        
        self.add(point: point)
        
        return point
    }
    
    /// Appends a point to the point segment
    public func add(point: GPXPoint?) {
        if let validPoint = point {
            points.append(validPoint)
        }
    }
    
    /// Appends an array of points to the point segment
    public func add(points: [GPXPoint]) {
        self.points.append(contentsOf: points)
    }
    
    /// Remove a single point in the point segment
    public func remove(point: GPXPoint) {
        let contains = points.contains(point)
        if contains == true {
            if let index = points.firstIndex(of: point) {
                points.remove(at: index)
            }
        }
    }
    
    // MARK:- Tag
    
    override func tagName() -> String {
        return "ptseg"
    }
    
    // MARK:- GPX
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        
        for point in points {
            point.gpx(gpx, indentationLevel: indentationLevel)
        }
    }
}

extension GPXPointSegment: Hashable {
    public static func == (lhs: GPXPointSegment, rhs: GPXPointSegment) -> Bool {
        return lhs.points == rhs.points && lhs.tagName() == rhs.tagName()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(points.hashValue)
    }
}
