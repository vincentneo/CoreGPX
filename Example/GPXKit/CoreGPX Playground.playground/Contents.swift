import Foundation
import CoreGPX

// Example: Generate GPX string

let root = GPXRoot(creator: "CoreGPX Playground") // Init with a creator name.

let track = GPXTrack()
let firstSegment = GPXTrackSegment()

let metadata = GPXMetadata()

metadata.time = Date()
metadata.copyright = GPXCopyright(author: "Vincent Neo")
metadata.desc = "This GPX File is created to facilitate the understanding of CoreGPX library's usage!"

root.metadata = metadata

let firstTrkPt = GPXTrackPoint(latitude: 1.2345, longitude: 2.3456)
let secondTrkPt = GPXTrackPoint(latitude: 0.294, longitude: 38.019)

firstTrkPt.elevation = 31.92492
firstTrkPt.extensions = GPXExtensions()
firstTrkPt.extensions?.append(at: "customproperties", contents: ["Location" : "Sembawang, Singapore", "CompassDegree" : "120"])


firstSegment.add(trackpoints: [firstTrkPt, secondTrkPt])
track.add(trackSegment: firstSegment)

root.add(track: track)


// Dealing with extensions
let rootExtensions = GPXExtensions()
let child = GPXExtensionsElement(name: "trkExtensions")
let speed = GPXExtensionsElement(name: "speed")
speed.text = "50.49"
let airQuality = GPXExtensionsElement(name: "AirQuality")
airQuality.text = "82"
child.attributes = ["purpose" : "test"]

child.children.append(speed)
child.children.append(airQuality)

rootExtensions.children.append(child)

root.extensions = rootExtensions

print("Completed GPXRoot: \(root.gpx())")

let rt: GPXRoot?

do {
    rt = try GPXParser(withPath: "https://www.apple.com")?.failibleParsedData(forceContinue: false)
}
catch {
    print(error)
}
