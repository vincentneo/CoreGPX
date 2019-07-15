//
//  ParserElement.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//

import Foundation

class GPXRawElement {
    var name: String
    var text: String?
    var attributes = [String : String]()
    var children = [GPXRawElement]()
    
    weak var parent: GPXRawElement?
    
    init(name: String) {
        self.name = name
    }
}
