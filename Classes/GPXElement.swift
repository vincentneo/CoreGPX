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
    
    init(XMLElement element: UnsafeMutablePointer<TBXMLElement>, parent: GPXElement?) {
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
    
    func childElement(ofClass Class: AnyClass, xmlElement: UnsafeMutablePointer<TBXMLElement>) -> GPXElement? {
       
        return childElement(ofClass: Class, xmlElement: xmlElement, required: false)
    }
    
    func childElement(ofClass Class: AnyClass, xmlElement: UnsafeMutablePointer<TBXMLElement>, required: Bool) -> GPXElement? {
        let firstElement: GPXElement?
        let element: UnsafeMutablePointer<TBXMLElement>? = TBXML.childElementNamed(GPXElement.tagName, parentElement: xmlElement)
        
        firstElement = GPXElement.init(XMLElement: element!, parent: self)
        
        if element != nil {
            
            
            let secondElement: UnsafeMutablePointer<TBXMLElement>? = TBXML.nextSiblingNamed(GPXElement.tagName, searchFrom: element)
            if secondElement != nil {
                let description = "\(GPXElement.tagName ?? "") element require \(GPXElement.tagName ?? "") element."
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
            }
        }
        
        if required {
            if firstElement == nil {
                let description = "\(GPXElement.tagName ?? "") element require \(GPXElement.tagName ?? "") element."
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
            }
        }
        
        return firstElement
    }
    
    func childElement(Named name: String, Class: AnyClass, xmlElement: UnsafeMutablePointer<TBXMLElement>) -> GPXElement? {
        return childElement(ofClass: Class, xmlElement: xmlElement, required: false)
    }
    
    func childElement(Named name: String, Class: AnyClass, xmlElement: UnsafeMutablePointer<TBXMLElement>, required: Bool) -> GPXElement? {
        let firstElement: GPXElement?
        let element: UnsafeMutablePointer<TBXMLElement>? = TBXML.childElementNamed(name, parentElement: xmlElement)
        
        firstElement = GPXElement.init(XMLElement: element!, parent: self)
        
        if element != nil {
            
            let secondElement: UnsafeMutablePointer<TBXMLElement>? = TBXML.nextSiblingNamed(name, searchFrom: element)
            if secondElement != nil {
                let description = "\(GPXElement.tagName ?? "") element has more than two \(GPXElement.tagName ?? "") element."
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
            }
        }
        
        if required {
            if firstElement == nil {
                let description = "\(GPXElement.tagName ?? "") element require \(GPXElement.tagName ?? "") element."
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGPXInvalidGPXFormatNotification), object: self, userInfo: [kGPXDescriptionKey : description])
            }
        }
        
        return firstElement
    }
    
    func childElement(ofClass Class:AnyClass, xmlElement: UnsafeMutablePointer<TBXMLElement>, eachBlock: @escaping (_ element: GPXElement?) -> Void) {
        var element: UnsafeMutablePointer<TBXMLElement>? = TBXML.childElementNamed(GPXElement.tagName, parentElement: xmlElement)
        
        while element != nil {
            eachBlock(GPXElement.init(XMLElement: element!, parent: self))
            element = TBXML.nextSiblingNamed(GPXElement.tagName, searchFrom: element)
        }
    }
    
    // MARK:- GPX
   
    // Coming soon....
    
}
