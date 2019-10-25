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
        case stripDuplicatesOnly
        case stripNearbyData
        case stripBoth
        case randomRemoval
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
    func stripNearbyData(_ gpx: GPXRoot, types: [GPXParserLossyOptions], distanceRadius: Double) -> GPXRoot {
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
    
    func lossyRandom(_ gpx: GPXRoot, types: [GPXParserLossyOptions]) -> GPXRoot {
        
        let gpx = gpx
        let wptCount = gpx.waypoints.count
        
        // Percentage of points to remove
        let kPercent = 0.2 // 20%
        
        if types.contains(.waypoint) {
            if wptCount != 0 {
                let removalAmount = Int(kPercent * Double(wptCount))
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
                               let removalAmount = Int(kPercent * Double(trkptCount))
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
                    let removalAmount = Int(kPercent * Double(rteCount))
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
