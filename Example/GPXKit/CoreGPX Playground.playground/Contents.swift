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
firstTrkPt.extensions?.simpleAppend(parent: "customproperties", contents: ["Location" : "Sembawang, Singapore", "CompassDegree" : "120"])

let secondTrkPt = GPXTrackPoint(latitude: 0.294, longitude: 38.019)

firstSegment.add(trackpoint: firstTrkPt)
firstSegment.add(trackpoint: secondTrkPt)

track.add(trackSegment: firstSegment)

root.add(track: track)

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

//let ext = rootExtensions["trkExtenions"]["speed"].text

print(rootExtensions["trkExtensions"]["speedd"].text)

print(root.gpx())

let url = URL(string: "https://dl.dropboxusercontent.com/s/qomkwzrqj2punqy/multi-actIds.gpx.txt")
//let gpx = GPXParserII().parse(url!)
let gpx = GPXParserII(withURL: url!)?.parsedData()

print(gpx)

