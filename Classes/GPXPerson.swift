//
//  GPXPerson.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import UIKit

class GPXPerson: GPXElement {
    var name: String
    var email: GPXEmail?
    var link: GPXLink
    
    // MARK:- Instance
    override init(XMLElement element: UnsafeMutablePointer<TBXMLElement>, parent: GPXElement?) {
        name = String()
        email = GPXEmail()
        link = GPXLink()
        
        super.init()
        
        name = text(forSingleChildElement: "name", xmlElement: element)
        email = childElement(ofClass: GPXEmail, xmlElement: element)
        link = childElement(ofClass: GPXLink, xmlElement: element)
    }
    
    // MARK:- Tag
    override func tagName() -> String! {
        return "person"
    }
    
    // MARK:- GPX
}
