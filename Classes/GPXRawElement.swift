//
//  ParserElement.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//

import Foundation

public class GPXRawElement {
    public var name: String
    public var text: String?
    public var attributes = [String : String]()
    public var children = [GPXRawElement]()
    
    public weak var parent: GPXRawElement?
    
    public init(name: String) {
        self.name = name
    }
    
    //subscript(children) -> ParserElement
}
