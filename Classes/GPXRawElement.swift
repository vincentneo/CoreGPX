//
//  ParserElement.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//
//  Referenced from GitHub, yahoojapan/SwiftyXMLParser

import Foundation

class GPXRawElement {
    var name: String
    var text: String?
    var attributes = [String : String]()
    var children = [GPXRawElement]()
    
    init(name: String) {
        self.name = name
    }
}
