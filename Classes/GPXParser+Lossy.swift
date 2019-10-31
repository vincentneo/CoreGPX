//
//  GPXParser+Lossy.swift
//  Pods
//
//  Created by Vincent Neo on 25/10/19.
//

import Foundation

// MARK:- Issue #56
extension GPXParser {
    public enum GPXParserLossyTypes {
        case stripDuplicates
        case stripNearbyData(distanceRadius: Double)
        case randomRemoval(percentage: Double)
        
        func value() -> Double {
            switch self {
            case .stripNearbyData(distanceRadius: let rad): return rad
            case .randomRemoval(percentage: let percent): return percent
            default: fatalError("GPXParserLossyTypes: No value to get")
            }
        }
    }

    public enum GPXParserLossyOptions {
        case trackpoint
        case waypoint
        case routepoint
    }

    func stripDuplicates(_ gpx: GPXRoot, types: [GPXParserLossyOptions]) -> GPXRoot {
        let gpx = gpx
        
        var lastPointCoordinates: (Double?, Double?)
        var currentPointIndex = 0
        
        if types.contains(.waypoint) {
            for wpt in gpx.waypoints {
                if lastPointCoordinates == (wpt.latitude, wpt.longitude) {
                    gpx.waypoints.remove(at: currentPointIndex)
                }
                lastPointCoordinates = (wpt.latitude, wpt.longitude)
                currentPointIndex += 1
            }
            lastPointCoordinates = (nil,nil)
            currentPointIndex = 0
        }
        
        if types.contains(.trackpoint) {
             for track in gpx.tracks {
                        for segment in track.tracksegments {
                            for trkpt in segment.trackpoints {
                                if lastPointCoordinates == (trkpt.latitude, trkpt.longitude) {
                                    segment.trackpoints.remove(at: currentPointIndex)
                                }
                                lastPointCoordinates = (trkpt.latitude, trkpt.longitude)
                                currentPointIndex += 1
                            }
                            lastPointCoordinates = (nil,nil)
                            currentPointIndex = 0
                        }
                    }
         }
        
         
         if types.contains(.routepoint) {
             for route in gpx.routes {
                for rtept in route.routepoints {
                     if lastPointCoordinates == (rtept.latitude, rtept.longitude) {
                         route.routepoints.remove(at: currentPointIndex)
                     }
                     lastPointCoordinates = (rtept.latitude, rtept.longitude)
                     currentPointIndex += 1
                 }
                 lastPointCoordinates = (nil,nil)
                 currentPointIndex = 0
             }
         }
        
        return gpx
    }
    
    // distanceRadius in metres
    func stripNearbyData(_ gpx: GPXRoot, types: [GPXParserLossyOptions], distanceRadius: Double = 100) -> GPXRoot {
        let gpx = gpx
        
        var lastPointCoordinates: GPXWaypoint?
        var currentPointIndex = 0
        
        if types.contains(.waypoint) {
            for wpt in gpx.waypoints {
                if let distance = Convert.getDistance(from: lastPointCoordinates, and: wpt) {
                    if distance < distanceRadius {
                        gpx.waypoints.remove(at: currentPointIndex)
                        lastPointCoordinates = nil
                        currentPointIndex += 1
                        continue
                    }
                }
                lastPointCoordinates = wpt
                currentPointIndex += 1
            }
            lastPointCoordinates = nil
            currentPointIndex = 0
        }
        
        if types.contains(.trackpoint) {
             for track in gpx.tracks {
                        for segment in track.tracksegments {
                            for trkpt in segment.trackpoints {
                                if let distance = Convert.getDistance(from: lastPointCoordinates, and: trkpt) {
                                    if distance < distanceRadius {
                                        segment.trackpoints.remove(at: currentPointIndex)
                                        lastPointCoordinates = nil
                                        currentPointIndex += 1
                                        continue
                                    }
                                }
                                lastPointCoordinates = trkpt
                                currentPointIndex += 1
                            }
                            lastPointCoordinates = nil
                            currentPointIndex = 0
                        }
                    }
         }
        
         
         if types.contains(.routepoint) {
             for route in gpx.routes {
                for rtept in route.routepoints {
                    if let distance = Convert.getDistance(from: lastPointCoordinates, and: rtept) {
                        if distance < distanceRadius {
                            route.routepoints.remove(at: currentPointIndex)
                            lastPointCoordinates = nil
                            currentPointIndex += 1
                            continue
                        }
                    }
                    lastPointCoordinates = rtept
                    currentPointIndex += 1
                }
                lastPointCoordinates = nil
                currentPointIndex = 0
             }
         }
        
        return gpx
    }
    
    func lossyRandom(_ gpx: GPXRoot, types: [GPXParserLossyOptions], percent: Double = 0.2) -> GPXRoot {
        
        let gpx = gpx
        let wptCount = gpx.waypoints.count
        
        if types.contains(.waypoint) {
            if wptCount != 0 {
                let removalAmount = Int(percent * Double(wptCount))
                for i in 0...removalAmount {
                    let randomInt = Int.random(in: 0...wptCount - (i+1))
                    gpx.waypoints.remove(at: randomInt)
                }
            }
        }
        
        if types.contains(.trackpoint) {
            for track in gpx.tracks {
                       for segment in track.tracksegments {
                           let trkptCount = segment.trackpoints.count
                           if trkptCount != 0 {
                               let removalAmount = Int(percent * Double(trkptCount))
                               for i in 0...removalAmount {
                                   let randomInt = Int.random(in: 0...trkptCount - (i+1))
                                   segment.trackpoints.remove(at: randomInt)
                               }
                           }
                       }
                   }
        }
       
        
        if types.contains(.routepoint) {
            for route in gpx.routes {
                let rteCount = route.routepoints.count
                if rteCount != 0 {
                    let removalAmount = Int(percent * Double(rteCount))
                    for i in 0...removalAmount {
                        let randomInt = Int.random(in: 0...rteCount - (i+1))
                        route.routepoints.remove(at: randomInt)
                    }
                }
            }
        }
        
        return gpx
        
    }
    
}

/// Extension for distance between points calculation, without `CoreLocation` APIs.
extension Convert {
    
    /// Calculates distance between two coordinate points, returns in metres (m).
    ///
    /// Code from https://github.com/raywenderlich/swift-algorithm-club/tree/master/HaversineDistance
    /// Licensed under MIT license
    static func haversineDistance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double {
        
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        // Converts from degrees to radians
        let dToR = { (angle: Double) -> Double in
            return (angle / 360) * 2 * .pi
        }
        
        let lat1 = dToR(la1)
        let lon1 = dToR(lo1)
        let lat2 = dToR(la2)
        let lon2 = dToR(lo2)
        
        return radius * ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
    }
    
    /// Gets distance from any GPX point type
    static func getDistance<pt: GPXWaypoint>(from first: pt?, and second: pt?) -> Double? {
        guard let lat1 = first?.latitude, let lon1 = first?.longitude, let lat2 = second?.latitude, let lon2 = second?.longitude else { return nil }
        
        return haversineDistance(la1: lat1, lo1: lon1, la2: lat2, lo2: lon2)
    }
    
}
