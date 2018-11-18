//
//  GPXEmail.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import UIKit

/// An email address. Broken into two parts (id and domain) to help prevent email harvesting.
class GPXEmail: GPXElement {
    var emailID: String?
    var domain: String?
    
    // MARK:- Instance
    
    override init() {
        emailID = String()
        domain = String()
        
        super.init()
        emailID = self.value(ofAttribute: "id", xmlElement: &element, required: true)
        domain = self.value(ofAttribute: "domain", xmlElement: &element, required: true)
    }
    
    func emailWith(ID emailID: String, domain: String) {
        let email = GPXEmail()
        email.emailID = emailID
    }
    
    // MARK:- Tag
    override func tagName() -> String! {
        return "email"
    }
    
    // MARK:- GPX
    override func addOpenTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        let attribute: NSMutableString = ""
        
        if emailID != nil {
            attribute.appendFormat(" id=\"%@\"", emailID!)
        }
        if domain != nil {
            attribute.appendFormat(" domain=\"%@\"", domain!)
        }
        gpx.appendFormat("%@<%@%@>\r\n", indent(forIndentationLevel: indentationLevel), self.tagName(), attribute)
    }
}
