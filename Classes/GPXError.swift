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
        case issueAt(line: Int, error: Error)
        case fileIsNotGPX
        case fileIsNotXMLBased
        case fileDoesNotConformSchema
        case fileIsEmpty
        case multipleErrorsOccurred(_ errors: [Error])
    }
}

struct coordinatesChecker {
    static func checkError(latitude: Double, longitude: Double) -> Error? {
        guard latitude >= -90 && latitude <= 90 else {
            if latitude <= -90 {
                return GPXError.coordinates.invalidLatitude(dueTo: .underLimit)
            }
            else {
                return GPXError.coordinates.invalidLatitude(dueTo: .overLimit)
            }
        }
        guard longitude >= -180 && longitude <= 180 else {
            if longitude <= -180 {
                return GPXError.coordinates.invalidLongitude(dueTo: .underLimit)
            }
            else {
                return GPXError.coordinates.invalidLongitude(dueTo: .overLimit)
            }
        }
        
        return nil
    }
}
