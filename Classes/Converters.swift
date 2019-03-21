//
//  Conversions.swift
//  Pods
//
//  Created by Vincent on 21/3/19.
//

import Foundation

/// Provides conversions, when required.
///
/// Mainly used for parsing only right now.
internal class Convert {
    
    /// For conversion from optional `String` type to optional `Int` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Int` that will be nil if input `String` is nil.
    ///
    static func toInt(from string: String?) -> Int? {
        guard let NonNilString = string else {
            return nil
        }
        return Int(NonNilString)
    }
    
    /// For conversion from optional `String` type to optional `Double` type
    ///
    /// - Parameters:
    ///     - string: input string that should be a number.
    /// - Returns:
    ///     A `Double` that will be nil if input `String` is nil.
    ///
    static func toDouble(from string: String?) -> Double? {
        guard let NonNilString = string else {
            return nil
        }
        return Double(NonNilString)
    }
    
}

