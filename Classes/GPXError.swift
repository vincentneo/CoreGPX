//
//  GPXError.swift
//  Pods
//
//  Created by Vincent on 4/9/19.
//

import Foundation

/// Throwable errors for GPX library
public struct GPXError {
    
    /// Coordinates related errors
    public enum coordinates: Error {
        case invalidLatitude(dueTo: reason)
        case invalidLongitude(dueTo: reason)
        
        public enum reason {
            case underLimit
            case overLimit
        }
    }
    
    /// Parser related errors
    public enum parser: Error {
        case unsupportedVersion
        case issueAt(line: Int)
        case fileIsNotGPX
        case fileIsNotXMLBased
        case fileDoesNotConformSchema
        case fileIsEmpty
    }
}


