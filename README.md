# CoreGPX
Parse, generate GPX files on iOS, watchOS & macOS.

[![CI Status](https://travis-ci.com/vincentneo/CoreGPX.svg?branch=master)](https://travis-ci.com/vincentneo/CoreGPX)
[![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://swift.org/blog/swift-4-2-released/)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Platform](https://img.shields.io/cocoapods/p/CoreGPX.svg?style=flat)](https://cocoapods.org/pods/CoreGPX)
[![Version](https://img.shields.io/cocoapods/v/CoreGPX.svg?style=flat)](https://cocoapods.org/pods/CoreGPX)

# What is CoreGPX?
CoreGPX is a port of iOS-GPX-Framework to Swift language. It aims to be more than a port of the abandoned project, so do expect more features to be added in the future, as development is currently under progress.

It makes use of `XMLParser` for parsing GPX files, thus making it fully dependent on the native APIs only.

## Features
- [x] Successfully outputs string that can be packaged into a GPX file
- [x] Parses GPX files using native XMLParser
- [x] Support for macOS & watchOS

## How to parse?
Parsing of GPX files is done on by initializing `GPXParser`.

There are three ways of initializing `GPXParser`:
### You can initialize with a `URL`:
```Swift
let gpx = GPXParser(withURL: inputURL).parsedData()
```
### With path:
```Swift
let gpx = GPXParser(withPath: inputPath).parsedData() // String type
```
### Or with `Data`:
```Swift
let gpx = GPXParser(withData: inputData).parsedData()
```

`.parsedData()` returns a `GPXRoot` type, which contains all the metadata, waypoints, tracks, routes, and extensions(if any), which you can expect from a GPX file, depending on what that file contains.

### Making use of parsed data
```Swift
let gpx = GPXParser(withURL: inputURL).parsedData()
        
// waypoints, tracks, tracksegements, trackpoints are all stored as Array depends on the amount stored in the GPX file.
for waypoint in gpx.waypoints {  // for loop example, every waypoint is written
    print(waypoint.latitude)     // prints every waypoint's latitude, etc: 1.3521, as a Double object
    print(waypoint.longitude)    // prints every waypoint's latitude, etc: 103.8198, as a Double objec
    print(waypoint.time)         // prints every waypoint's date, as a Date object
    print(waypoint.name)         // prints every waypoint's name, as a String
}
    print(gpx.metadata?.desc)    // prints description given in GPX file metadata tag
    print(gpx.metadata?.name)    // prints name given in GPX file metadata tag
                
```

## How to create?
Coming soon!

## Example
To run the example project, clone the repo, and try out the Example!

## Contributing
Contributions to this project will be more than welcomed. Feel free to add a pull request or open an issue.

#### TO DO Checklist
Any help would be appreciated!
- [ ] Extension to metadata to support collection of more info in GPX file
- [ ] Add tests
- [ ] Documentation
- [ ] Code optimisation
- [ ] New features


## Installation

CoreGPX will be available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CoreGPX'
```

## License

CoreGPX is available under the MIT license. See the LICENSE file for more info.
