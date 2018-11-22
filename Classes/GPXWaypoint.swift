//
//  GPXWaypoint.swift
//  GPXKit
//
//  Created by Vincent on 19/11/18.
//

import UIKit

class GPXWaypoint: GPXElement {
    var elevationValue = String()
    var timeValue = String()
    var magneticVariationValue = String()
    var geoidHeightValue = String()
    var links = NSMutableArray()
    var fixValue = String()
    var satellitesValue = String()
    var horizontalDilutionValue = String()
    var verticalDilutionValue = String()
    var positionDilutionValue = String()
    var ageOfGPSDataValue = String()
    var DGPSidValue = String()
    var latitudeValue = String()
    var longitudeValue = String()
    
    //var elevation = CGFloat()
    //var time = Date()
    var magneticvariation = CGFloat()
    //var geoidHeight = CGFloat()
    var name = String()
    var comment = String()
    var desc = String()
    var source = String()
    //var links = NSArray()
    var symbol = String()
    var type = String()
    //var fix = Int()
    //var satellites = Int()
    //var horizontalDilution = CGFloat()
    //var positionDilution = CGFloat()
    var ageofDGPSData = CGFloat()
    var DGPSid = Int()
    var extensions: GPXExtensions
    var latitude = CGFloat()
    var longitude = CGFloat()
    
    override init() {
        self.extensions = GPXExtensions()
        super.init()
    }
    
    override init(XMLElement element: UnsafeMutablePointer<TBXMLElement>?, parent: GPXElement?) {
        self.extensions = GPXExtensions(XMLElement: element, parent: parent)
        
        super.init(XMLElement: element, parent: parent)
        
        self.elevationValue = text(forSingleChildElement: "ele", xmlElement: element)
        self.timeValue = text(forSingleChildElement: "time", xmlElement: element)
        self.magneticVariationValue = text(forSingleChildElement: "magvar", xmlElement: element)
        self.geoidHeightValue = text(forSingleChildElement: "geoidheight", xmlElement: element)
        self.name = text(forSingleChildElement: "name", xmlElement: element)
        self.comment = text(forSingleChildElement: "cmt", xmlElement: element)
        self.desc = text(forSingleChildElement: "desc", xmlElement: element)
        self.source = text(forSingleChildElement: "src", xmlElement: element)
        self.childElement(ofClass: GPXLink.self, xmlElement: element, eachBlock: { element in
            if element != nil {
                self.links.add(element!)
            } })
        self.symbol = text(forSingleChildElement: "sym", xmlElement: element)
        self.type = text(forSingleChildElement: "type", xmlElement: element)
        self.fixValue = text(forSingleChildElement: "fix", xmlElement: element)
        self.satellitesValue = text(forSingleChildElement: "sat", xmlElement: element)
        self.horizontalDilutionValue = text(forSingleChildElement: "hdop", xmlElement: element)
        self.verticalDilutionValue = text(forSingleChildElement: "vdop", xmlElement: element)
        self.positionDilutionValue = text(forSingleChildElement: "pdop", xmlElement: element)
        self.ageOfGPSDataValue = text(forSingleChildElement: "ageofdgpsdata", xmlElement: element)
        self.DGPSidValue = text(forSingleChildElement: "dgpsid", xmlElement: element)
        self.extensions = childElement(ofClass: GPXExtensions.self, xmlElement: element) as! GPXExtensions
        
        self.latitudeValue = value(ofAttribute: "lat", xmlElement: element, required: true)!
        self.longitudeValue = value(ofAttribute: "lon", xmlElement: element, required: true)!
        
        self.latitude = GPXType().latitude(latitudeValue)
        self.longitude =  GPXType().longitude(longitudeValue)
        
    }
    
    func waypoint(With latitude: CGFloat, longitude: CGFloat) -> GPXWaypoint {
        let waypoint = GPXWaypoint()
        waypoint.latitude = latitude
        waypoint.longitude = longitude
        return waypoint
    }
    
    // MARK:- Public Methods
    
    var elevation: CGFloat {
        return GPXType().decimal(elevationValue)
    }
    
    func set(Elevation elevation: CGFloat) {
        elevationValue = GPXType().value(forDecimal: elevation)
    }
    
    var time: Date? {
        return GPXType().dateTime(value: timeValue)
    }
    
    func set(Time time: Date) {
        timeValue = GPXType().value(forDateTime: time)
    }
    
    var magneticVariation: CGFloat {
        return GPXType().degrees(magneticVariationValue)
    }
    
    func set(MagneticVariation magneticVariation: CGFloat) {
        magneticVariationValue = GPXType().value(forDegrees: magneticVariation)
    }
    
    var geoidHeight: CGFloat {
        return GPXType().decimal(geoidHeightValue)
    }
    
    func set(GeoidHeight geoidHeight: CGFloat) {
        geoidHeightValue = GPXType().value(forDecimal: geoidHeight)
    }
    
    func newLink(withHref href: String) -> GPXLink {
        let link: GPXLink = GPXLink().link(with: href)
        return link
    }
    
    func add(Link link: GPXLink?) {
        if link != nil {
            let index = links.index(of: link!)
            if index == NSNotFound {
                link?.parent = self
                links.add(link!)
            }
        }
    }
    
    func add(Links array: NSArray) {
        for case let link as GPXLink in array {
            add(Link: link)
        }
    }
    
    func remove(Link link: GPXLink) {
        let index = links.index(of: link)
        
        if index != NSNotFound {
            link.parent = nil
            links.remove(link)
        }
    }
    
    var fix: Int { // maybe GPXFix would be better?
        return GPXType().fix(value: fixValue).rawValue
    }
    
    func set(Fix: Int) {
        fixValue = GPXType().value(forFix: GPXFix(rawValue: Fix) ?? .none)
    }
    
    var satellites: Int {
        return GPXType().nonNegativeInt(satellitesValue)
    }
    
    func set(Satellites: Int) {
        satellitesValue = GPXType().value(forNonNegativeInt: Satellites)
    }
    
    var horizontalDilution: CGFloat {
        return GPXType().decimal(horizontalDilutionValue)
    }
    
    func set(HorizontalDilution: CGFloat) {
        horizontalDilutionValue = GPXType().value(forDecimal: HorizontalDilution)
    }
    
    var verticalDilution: CGFloat {
        return GPXType().decimal(horizontalDilutionValue)
    }
    
    func set(VerticalDilution: CGFloat) {
        verticalDilutionValue = GPXType().value(forDecimal: VerticalDilution)
    }
    
    var positionDilution: CGFloat {
        return GPXType().decimal(positionDilutionValue)
    }
    
    func set(PositionDilution: CGFloat) {
        positionDilutionValue = GPXType().value(forDecimal: PositionDilution)
    }
    
    var ageOfDGPSData: CGFloat {
        return GPXType().decimal(ageOfGPSDataValue)
    }
    
    func set(DGPSid: Int) {
        DGPSidValue = GPXType().value(forDgpsStation: DGPSid)
    }
    
    func set(Latitude: CGFloat) {
        latitudeValue = GPXType().value(forLatitude: Latitude)
    }
    
    func set(Longitude: CGFloat) {
        longitudeValue = GPXType().value(forLongitude: Longitude)
    }
    
    
    
}
