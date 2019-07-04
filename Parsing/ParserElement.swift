//
//  ParserElement.swift
//  CoreGPX
//
//  Created by Vincent on 2/7/19.
//

import Foundation

public class ParserElement {
    public var name: String
    public var text: String?
    public var attributes = [String : String]()
    public var children = [ParserElement]()
    
    public weak var parent: ParserElement?
    
    public init(name: String) {
        self.name = name
    }
    
    //subscript(children) -> ParserElement
}
