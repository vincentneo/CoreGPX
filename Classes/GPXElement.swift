//
//  GPXElement.swift
//  GPXKit
//
//  Created by Vincent on 5/11/18.
//

import UIKit

class GPXElement: NSObject {
    
    var parent: GPXElement
    
    //from GPXConst
    let kGPXInvalidGPXFormatNotification = "kGPXInvalidGPXFormatNotification"

    let kGPXDescriptionKey = "kGPXDescriptionKey"

    
    //MARK:- Tag
    
    class var tagName: String! {
        return nil
    }
    class var implementClasses:Array<Any>! {
        return nil
    }
    
    // MARK:- Instance
    
    init(XMLElement element: TBXMLElement?, parent: GPXElement?) {
        self.parent = parent!
        super.init()
        
    }
    
    // MARK:- Elements
    
    func value(ofAttribute name: String?, xmlElement: UnsafeMutablePointer<TBXMLElement>) -> String? {
        return value(ofAttribute: name, xmlElement: xmlElement)
    }
    
    func value(ofAttribute name: String?, xmlElement: UnsafeMutablePointer<TBXMLElement>, required: Bool) -> String? {
        let value = TBXML.value(ofAttributeNamed: name, for: xmlElement)
        
        if value != nil && required == true {
            
            let description = "\(GPXElement.tagName ?? "") element require \(name ?? "") attribute."
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
        }
        
        return value
    }
    
    func text(forSingleChildElement name: String?, xmlElement: UnsafeMutablePointer<TBXMLElement>) -> String {
        
        return text(forSingleChildElement: name, xmlElement: xmlElement, required: false)
    }
    
    func text(forSingleChildElement name: String?, xmlElement: UnsafeMutablePointer<TBXMLElement>, required: Bool) -> String! {
        
        if let element: UnsafeMutablePointer<TBXMLElement> = TBXML.childElementNamed(name, parentElement: xmlElement) {
            return TBXML.text(for: element)
        }
        else {
            if required {
                let description = "\(GPXElement.tagName ?? "") element require \(name ?? "") element."
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
            }
        }
        
        return nil
    }

    
}
