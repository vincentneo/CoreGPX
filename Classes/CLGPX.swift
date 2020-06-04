//
//  CLGPX.swift
//  Pods
//
//  Created by Vincent Neo on 4/6/20.
//


import CoreLocation

extension GPXWaypoint {
    public convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    public convenience init(location: CLLocation) {
        self.init(coordinates: location.coordinate)
        self.elevation = location.altitude
        self.time = location.timestamp
        
    }
}

extension GPXPoint {
    public convenience init(coordinates: CLLocationCoordinate2D) {
        self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    public convenience init(location: CLLocation) {
        self.init(coordinates: location.coordinate)
        self.elevation = location.altitude
        self.time = location.timestamp
        
    }
}
