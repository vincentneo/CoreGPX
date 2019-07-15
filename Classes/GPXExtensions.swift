//
//  GPXExtensions.swift
//  GPXKit
//
//  Created by Vincent on 18/11/18.
//

import Foundation

/**
 For adding/obtaining data stored as extensions in GPX file.
 
 Typical GPX extended data, would have data that should be inbetween the open and close tags of **\<extensions>**
 
 This class represents the extended data in a GPX file.
 */
open class GPXExtensions: GPXElement, Codable {
    
    public var children = [GPXExtensionsElement]()
    
    // MARK:- Initializers
    
    /// Default Initializer.
    public required init() {
        super.init()
    }

    
    public func append(at parent: String?, contents: [String : String]) {
        if let parent = parent {
            let parentElement = GPXExtensionsElement(name: parent)
            for (key, value) in contents {
                let element = GPXExtensionsElement(name: key)
                element.text = value
                parentElement.children.append(element)
            }
            children.append(parentElement)
        }
        else {
            for (key, value) in contents {
                let element = GPXExtensionsElement(name: key)
                element.text = value
                children.append(element)
            }
        }
    }
    
    public func get(from parent: String?) -> [String : String]? {
        var data = [String : String]()
        
        if let parent = parent {
            var hasChild = false
            for child in children {
                if child.name == parent {
                    data = child.attributes
                    
                    for child2 in child.children {
                        data[child2.name] = child2.text
                    }
                    hasChild = true
                }
            }
            if !hasChild {
                return nil
            }
        }
        else {
            guard let child = children.first else { return nil }
            data = child.attributes
            data[child.name] = child.text
        }
        
        return data
    }
    
    /*
    /// for parsing uses only. Internal Initializer.
    init(dictionary: [String : String]) {
        var dictionary = dictionary
        var attributes = [[String : String]]()
        var elementNames = [Int : String]()
        
        for key in dictionary.keys {
            let keySegments = key.components(separatedBy: ", ")
            if keySegments.count == 2 {
                let index = Int(keySegments[1])!
                let elementName = keySegments[0]
                let value = dictionary[key]
                
                while !attributes.indices.contains(index) {
                    attributes.append([String : String]())
                }
                
                if value == "internalParsingIndex \(index)" {
                    elementNames[index] = elementName
                }
                else {
                    attributes[index][elementName] = value
                }
            }
            // ignore any key that does not conform to GPXExtension's parsing naming convention.
        }
        if elementNames.isEmpty {
            rootAttributes = attributes[0]
        }
        else {
            for elementNameIndex in elementNames.keys {
                let value = elementNames[elementNameIndex]!
                childAttributes[value] = attributes[elementNameIndex]
            }
        }
        
    }
    */
    
    init(raw: GPXRawElement) {
        super.init()
        for child in raw.children {
            let tmp = GPXExtensionsElement(name: child.name)
            tmp.text = child.text
            tmp.attributes = child.attributes
            children.append(tmp)
        }
        
    }
    
    // MARK:- Subscript
    
    /**
    Access/Write dictionaries in extensions this way.
     
     If extended data does not have a parent tag, **i.e**:
     
        <Tag>50</Tag>
     Access it via `extensions[nil]`, to get value of **["Tag" : "50"]**.
     Write it via `extensions[nil]` = **["Tag" : "50"]**.
     
     If extended data does not have a parent tag, **i.e**:
     
        <ParentTag>
            <Tag>50</Tag>
        </ParentTag>
     Access it via `extensions["ParentTag"]`, to get value of **["Tag" : "50"]**.
     Write it via `extensions["ParentTag"]` = **["Tag" : "50"]**.
     
     - Parameters:
        - parentTag: **nil** if no parent tag, if not, insert parent tag name here.
     */
    public subscript(name: String) -> GPXExtensionsElement {
        get {
            for child in children {
                if child.name == name {
                    return child
                }
            }
            return GPXExtensionsElement()
        }
    }
    
    // MARK:- Tag
    override func tagName() -> String {
        return "extensions"
    }
    
    // MARK:- Unavailable classes
    
    /// Insert a dictionary of extension objects
    ///
    /// - Parameters:
    ///     - tag: Parent Tag. If inserting without the parent tag, this value should be `nil`
    ///     - contents: Contents as a dictionary to be inserted to this object.
    @available( *, unavailable, message: "Please append GPXExtensionsElement to this extension instead, or use simpleAppend(). Will be removed in future releases.")
    public func insert(withParentTag tag: String?, withContents contents: [String : String]) {}
    
    /// Remove a dictionary of extension objects
    ///
    /// - Parameters:
    ///     - tag: Parent Tag of contents for removal. If removing without the parent tag, this value should be `nil`
    @available( *, unavailable, message: "Please append GPXExtensionsElement to this extension instead, or use simpleAppend(). Will be removed in future releases.")
    public func remove(contentsOfParentTag tag: String?) {}
    
    
    // MARK:- GPX
    
    override func addChildTag(toGPX gpx: NSMutableString, indentationLevel: Int) {
        super.addChildTag(toGPX: gpx, indentationLevel: indentationLevel)
        for child in children {
            child.gpx(gpx, indentationLevel: indentationLevel)
        }

    }
}
