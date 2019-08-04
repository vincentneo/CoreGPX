//
//  GPXParserII.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//
//  XML Parser is referenced from GitHub, yahoojapan/SwiftyXMLParser.

import Foundation

 /**
 An event-driven parser (SAX parser), currently parses GPX v1.1 files only.
 
 This parser is already setted up, hence, does not require any handling, and will parse files directly as objects.
 To get the parsed data from a GPX file, simply initialize the parser, and get the `GPXRoot` from `parsedData()`.
 */
public class GPXParser: NSObject {
    
    private let parser: XMLParser
    private let documentRoot = GPXRawElement(name: "DocumentStart")
    private var stack = [GPXRawElement]()
    
    private func didInit() {
        stack = [GPXRawElement]()
        stack.append(documentRoot)
        parser.delegate = self
    }
    
    // MARK:- Initializers
    
    /// for parsing with `Data` type
    ///
    /// - Parameters:
    ///     - data: The input must be `Data` object containing GPX markup data, and should not be `nil`
    ///
    public init(withData data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        didInit()
    }
    
    /// for parsing with `InputStream` type
    ///
    /// - Parameters:
    ///     - stream: The input must be a input stream allowing GPX markup data to be parsed synchronously
    ///
    public init(withStream stream: InputStream) {
        self.parser = XMLParser(stream: stream)
        super.init()
        didInit()
    }
    
    /// for parsing with `URL` type
    ///
    /// - Parameters:
    ///     - url: The input must be a `URL`, which should point to a GPX file located at the URL given
    ///
    public init?(withURL url: URL) {
        guard let urlParser = XMLParser(contentsOf: url) else { return nil }
        self.parser = urlParser
        super.init()
        didInit()
    }
    
    /// for parsing with a string that contains full GPX markup
    ///
    /// - Parameters:
    ///     - string: The input `String` must contain full GPX markup, which is typically contained in a `.GPX` file
    ///
    public convenience init?(withRawString string: String?) {
        if let string = string {
            if let data = string.data(using: .utf8) {
                self.init(withData: data)
            }
            else { return nil }
        }
        else { return nil }
    }
    
    /// for parsing with a path to a GPX file
    ///
    /// - Parameters:
    ///     - path: The input path, with type `String`, must contain a path that points to a GPX file used to facilitate parsing.
    ///
    public convenience init?(withPath path: String) {
        do {
            let file = try String(contentsOfFile: path, encoding: .utf8)
            self.init(withRawString: file)
        }
        catch {
            print("InitWithPath Error")
            return nil
        }
        
    }
    
    // MARK: GPX
    
    public func parsedData() -> GPXRoot? {
        self.parser.parse() // parse when requested
        guard let firstTag = stack.first else { return nil }
        guard let rawGPX = firstTag.children.first else { return nil }
        
        let root = GPXRoot(raw: rawGPX) // to be returned via function.
        
        for child in rawGPX.children {
            let name = child.name
            
            switch name {
            case "metadata":
                let metadata = GPXMetadata(raw: child)
                root.metadata = metadata
            case "wpt":
                let waypoint = GPXWaypoint(raw: child)
                root.add(waypoint: waypoint)
            case "rte":
                let route = GPXRoute(raw: child)
                root.add(route: route)
            case "trk":
                let track = GPXTrack(raw: child)
                root.add(track: track)
            case "extensions":
                let extensions = GPXExtensions(raw: child)
                root.extensions = extensions
            default: continue
            }
        }
        
        // reset stack
        stack = [GPXRawElement]()
        
        return root
    }
    
}


///
/// XML Parser Delegate Implementation
///
extension GPXParser: XMLParserDelegate {
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = GPXRawElement(name: elementName)
        if !attributeDict.isEmpty {
            node.attributes = attributeDict
        }
        
        let parentNode = stack.last
        
        parentNode?.children.append(node)
        stack.append(node)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if let text = stack.last?.text {
            stack.last?.text = text + foundString
        } else {
            stack.last?.text = "" + foundString
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        stack.last?.text = stack.last?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        stack.removeLast()
    }
    
}
