import Foundation
import CoreGPX

// Example: Generate GPX string

let root = GPXRoot(creator: "CoreGPX Playground")

let track = GPXTrack()
let firstSegment = GPXTrackSegment()

let metadata = GPXMetadata()

metadata.time = Date()
metadata.copyright = GPXCopyright(author: "Vincent Neo")
metadata.desc = "This GPX File is created to facilitate the understanding of CoreGPX library's usage!"

root.metadata = metadata

let firstTrkPt = GPXTrackPoint(latitude: 1.2345, longitude: 2.3456)
firstTrkPt.elevation = 31.92492
firstTrkPt.extensions = GPXExtensions()
firstTrkPt.extensions!["customproperties"] = ["Location" : "Sembawang, Singapore", "CompassDegree" : "120"]

let secondTrkPt = GPXTrackPoint(latitude: 0.294, longitude: 38.019)

firstSegment.add(trackpoint: firstTrkPt)
firstSegment.add(trackpoint: secondTrkPt)

track.add(trackSegment: firstSegment)

root.add(track: track)

print(root.gpx())

