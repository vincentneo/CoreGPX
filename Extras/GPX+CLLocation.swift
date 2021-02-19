//  The following file is also licensed under the MIT license, as with the CoreGPX project.
//  You may read about the license here: https://raw.githubusercontent.com/vincentneo/CoreGPX/master/LICENSE
//
//  GPX+CLLocation.swift
//  Extras
//
//  Created by Vincent Neo on 19/2/21.
//  Provided under CoreGPX project.
//

import CoreGPX
import CoreLocation

public protocol GPXBridge {
    func convert<Point: GPXWaypointProtocol>(as: Point.Type) -> Point
}

extension GPXWaypointProtocol {
    public func convertToLocation() -> CLLocation? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinates, altitude: self.elevation ?? 0, horizontalAccuracy: 0, verticalAccuracy: self.elevation == nil ? -1 : 0, timestamp: self.time ?? Date())
        return location
    }
    
    public func convertToCoordinates() -> CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension CLLocation: GPXBridge {
    
    public func convert<Point>(as: Point.Type) -> Point where Point : GPXWaypointProtocol {
        let point = Point()
        
        point.elevation = self.altitude
        point.time = self.timestamp
        point.latitude = self.coordinate.latitude
        point.longitude = self.coordinate.longitude
        
        return point
    }

}

