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

let url = URL(string: "https://dl.dropboxusercontent.com/s/qomkwzrqj2punqy/multi-actIds.gpx.txt")
let gpx = GPXParserII().parse(url!)

print(gpx)

for Root in gpx {
    for child in Root.children {
        print(child.name)
        for child2 in child.children {
            print(child2.name)
            for tracking in child2.children {
                print(tracking.name)
                print(tracking.text)
            }
        }
    }
}
