//
//  GPXAuthor.swift
//  GPXKit
//
//  Created by Vincent on 22/11/18.
//

import Foundation

/// Author type.
open class GPXAuthor: GPXPerson {
    
    public required init() {
        super.init()
    }
    
    override init(dictionary: [String : String]) {
        super.init()
        self.name = dictionary["name"]
    }
    
    // MARK: Tag
    
    override func tagName() -> String {
        return "author"
    }
}
