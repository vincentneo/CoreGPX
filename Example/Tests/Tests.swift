import XCTest
@testable import CoreGPX

class CoreGPX_Tests: XCTestCase {
    
    var data: Data?
    var path: String?
    var url: URL?
    var stream: InputStream?
    
    // error tests
    var wptError: URL?
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "GPXTest-TrackPointOnly", withExtension: "gpx")!
        let wptError = bundle.url(forResource: "wptError", withExtension: "gpx")!
        let path = bundle.path(forResource: "GPXTest-TrackPointOnly", ofType: "gpx")!
        do {
            let data = try Data(contentsOf: url)
            self.data = data
        }
        catch { print(error) }
        let inputStream = InputStream(url: url)
        self.path = path
        self.url = url
        self.stream = inputStream
        self.wptError = wptError
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Parsing Tests
    
    func testParseWithData() {
        guard let data = data else {
            XCTAssert(false, "testParseWithData: Data invalid")
            return
        }
        let parsedData = GPXParser(withData: data).parsedData()
        var count = Int()
        var firstLatitude = Double()
        var firstLongitude = Double()
        
        for track in parsedData!.tracks {
            for tracksegment in track.tracksegments {
                count += tracksegment.trackpoints.count
                firstLatitude = (tracksegment.trackpoints.first?.latitude)!
                firstLongitude = (tracksegment.trackpoints.first?.longitude)!
            }
        }
        
        XCTAssertEqual(count, 4142, "testParseWithData: GPX Parsing using `Data` passed")
        XCTAssertEqual(firstLatitude, 35.675032, "testParseWithData: GPX Parsing using `Data` passed")
        XCTAssertEqual(firstLongitude, 139.722148, "testParseWithData: GPX Parsing using `Data` passed")
    }
    
    func testParseWithURL() {
        guard let url = url else {
            XCTAssert(false, "testParseWithURL: URL invalid")
            return
        }
        guard let parsedData = GPXParser(withURL: url)?.parsedData() else {
            XCTAssert(false, "testParseWithURL: init with URL failed")
            return
        }
        var count = Int()
        var firstLatitude = Double()
        var firstLongitude = Double()
        
        for track in parsedData.tracks {
            for tracksegment in track.tracksegments {
                count += tracksegment.trackpoints.count
                firstLatitude = (tracksegment.trackpoints.first?.latitude)!
                firstLongitude = (tracksegment.trackpoints.first?.longitude)!
            }
        }
        
        XCTAssertEqual(count, 4142, "testParseWithURL: GPX Parsing using `URL` passed")
        XCTAssertEqual(firstLatitude, 35.675032, "testParseWithURL: GPX Parsing using `URL` passed")
        XCTAssertEqual(firstLongitude, 139.722148, "testParseWithURL: GPX Parsing using `URL` passed")
        
    }
    
    func testParseWithPath() {
        guard let path = path else {
            XCTAssert(false, "testParseWithPath: path invalid")
            return
        }
        guard let parsedData = GPXParser(withPath: path)?.parsedData() else {
            XCTAssert(false, "testParseWithPath: init with path failed")
            return
        }
        var count = Int()
        var firstLatitude = Double()
        var firstLongitude = Double()
        
        for track in parsedData.tracks {
            for tracksegment in track.tracksegments {
                count += tracksegment.trackpoints.count
                firstLatitude = (tracksegment.trackpoints.first?.latitude)!
                firstLongitude = (tracksegment.trackpoints.first?.longitude)!
            }
        }
        
        XCTAssertEqual(count, 4142, "testParseWithPath: GPX Parsing using path passed")
        XCTAssertEqual(firstLatitude, 35.675032, "testParseWithPath: GPX Parsing using path passed")
        XCTAssertEqual(firstLongitude, 139.722148, "testParseWithPath: GPX Parsing using path passed")
        
    }
    
    func testParseWithInputStream() {
        guard let stream = stream else {
            XCTAssert(false, "testParseWithInputStream: input stream invalid")
            return
        }
        let parsedData = GPXParser(withStream: stream).parsedData()
        var count = Int()
        var firstLatitude = Double()
        var firstLongitude = Double()
        
        for track in parsedData!.tracks {
            for tracksegment in track.tracksegments {
                count += tracksegment.trackpoints.count
                firstLatitude = (tracksegment.trackpoints.first?.latitude)!
                firstLongitude = (tracksegment.trackpoints.first?.longitude)!
            }
        }
        
        XCTAssertEqual(count, 4142, "testParseWithInputStream: GPX Parsing using input stream passed")
        XCTAssertEqual(firstLatitude, 35.675032, "testParseWithInputStream: GPX Parsing using input stream passed")
        XCTAssertEqual(firstLongitude, 139.722148, "testParseWithInputStream: GPX Parsing using input stream passed")
        
    }
    
    func testParseWithRawString() {
        let string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<gpx xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.topografix.com/GPX/1/1\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\" version=\"1.1\" creator=\"CoreGPX tests\">\r\n\t<trk>\r\n\t\t<trkseg>\r\n\t\t\t<trkpt lat=\"35.678507\" lon=\"139.733723\">\r\n\t\t\t\t<time>2019-02-16T08:39:57Z</time>\r\n\t\t\t</trkpt>\r\n\t\t\t<trkpt lat=\"35.678525\" lon=\"139.733723\">\r\n\t\t\t\t<time>2019-02-16T08:39:57Z</time>\r\n\t\t\t</trkpt>\r\n\t\t</trkseg>\r\n\t</trk>\r\n</gpx>\r\n"
        guard let parsedData = GPXParser(withRawString: string)?.parsedData() else {
            XCTAssert(false, "testParseWithRawString: init with string failed")
            return
        }
        var count = Int()
        var firstLatitude = Double()
        var firstLongitude = Double()
        
        for track in parsedData.tracks {
            for tracksegment in track.tracksegments {
                count += tracksegment.trackpoints.count
                firstLatitude = (tracksegment.trackpoints.first?.latitude)!
                firstLongitude = (tracksegment.trackpoints.first?.longitude)!
            }
        }
        
        XCTAssertEqual(count, 2, "testParseWithRawString: GPX Parsing using string passed")
        XCTAssertEqual(firstLatitude, 35.678507, "testParseWithRawString: GPX Parsing using string passed")
        XCTAssertEqual(firstLongitude, 139.733723, "testParseWithRawString: GPX Parsing using string passed")
        
    }
    
    // MARK: Parse Errors Test
    
    func testParseFileWithCoordinatesError() {
        guard let kUrl = wptError else {
            XCTAssert(false, "testParseFileWithCoordinatesError: URL invalid")
            return
        }
        do {
            _ = try GPXParser(withURL: kUrl)?.failibleParsedData(forceContinue: true)
        }
        catch GPXError.parser.multipleErrorsOccurred(let errors) {
            if case GPXError.parser.issueAt(line: 3, error: GPXError.coordinates.invalidLatitude(dueTo: .overLimit)) = errors[0],
                case GPXError.parser.issueAt(line: 10, error: GPXError.coordinates.invalidLongitude(dueTo: .overLimit)) = errors[1] {
                XCTAssert(true, "testParseFileWithCoordinatesError: 2 errors correctly identified")
            }
            else {
                XCTAssert(false, "testParseFileWithCoordinatesError: errors were incorrectly identified")
            }
        }
        catch {
            XCTAssert(false, "testParseFileWithCoordinatesError: unexpected error caught: \(error)")
        }
    }
    
    
    // MARK: Performace Parsing Test
    
    func testPerformanceForParsingWithURL() {
        guard let url = url else {
            XCTAssert(false, "testParseWithURL: URL invalid")
            return
        }
        self.measure() {
            //_ = GPXParser(withURL: url)?.parsedData()
            _ = GPXParser(withURL: url)?.parsedData() //convertToGPX()
        }
    }
    
    func testPerformanceForParsingWithData() {
        guard let data = data else {
            XCTAssert(false, "testParseWithData: Data is nil")
            return
        }
        self.measure() {
            //_ = GPXParser(withURL: url)?.parsedData()
            _ = GPXParser(withData: data).parsedData() //convertToGPX()
        }
    }
    
    
    // MARK:- Creation Test
    
    func testCreation() {
        let root = GPXRoot(creator: "CoreGPX tests")
        
        let trackpoint1 = GPXTrackPoint(latitude: 35.678507, longitude: 139.733723)
        let trackpoint2 = GPXTrackPoint(latitude: 35.678525, longitude: 139.733723)
        let tracksegment = GPXTrackSegment()
        let track = GPXTrack()
        tracksegment.add(trackpoints: [trackpoint1, trackpoint2])
        track.add(trackSegment: tracksegment)
        
        root.add(track: track)
        
        let string = root.gpx()
        XCTAssert(!string.isEmpty, "testCreation: successfully created")
    }
    
    func testEncoding() {
        guard let data = data else {
            XCTAssert(false, "testEncoding: Data invalid")
            return
        }
        let parsedData = GPXParser(withData: data).parsedData()
        let trackpoints = parsedData!.tracks[0].tracksegments[0].trackpoints
        
        do {
            let data = try JSONEncoder().encode(trackpoints.first)
            
            guard let stringData = String(data: data, encoding: .utf8) else {
                XCTAssert(false, "testEncoding: Data to String invalid")
                return
            }
            
            print("data: \(stringData)")
            
            XCTAssertEqual(stringData, "{\"lat\":35.675032000000002,\"lon\":139.722148,\"ele\":31.098351999999998,\"time\":565148938}", "testEncoding: Data encoding passed")
        }
        catch {
            XCTAssert(false, "testEncoding: Failed to serialize trackpoint as Data")
            print("encode: \(error)")
        }
    }
    
    func testDecoding() {
        guard let data = data else {
            XCTAssert(false, "testDecoding: Data invalid")
            return
        }
        let parsedData = GPXParser(withData: data).parsedData()
        let trackpoints = parsedData!.tracks[0].tracksegments[0].trackpoints
        
        /// `data` declared above != `serializedData`
        ///
        /// `data` is data that is structured as XML (GPX-style)
        ///
        /// `serializedData` is data that is structured as JSON (in this case), or plist (if PropertyListDecoder is used instead)
        var serializedData = Data()
        
        do { // encode
            serializedData = try JSONEncoder().encode(trackpoints.first)
        }
        catch {
            XCTAssert(false, "testDecoding: Failed to serialize/encode trackpoint as Data")
            print("encode: \(error)")
        }
        
        do { // decode
            let decode = try JSONDecoder().decode(GPXTrackPoint.self, from: serializedData)
            XCTAssertEqual(decode.latitude, 35.675032, "testDecoding: Decoding serialized trackpoint as Data passed")
            XCTAssertEqual(decode.longitude, 139.722148, "testDecoding: Decoding serialized trackpoint as Data passed")
            XCTAssertEqual(decode.elevation, 31.098352, "testDecoding: Decoding serialized trackpoint as Data passed")
        }
        catch {
            XCTAssert(false, "testDecoding: Failed to decode serialized trackpoint as Data")
            print("decode: \(error)")
        }
    }
    
}
