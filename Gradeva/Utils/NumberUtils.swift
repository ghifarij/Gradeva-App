//
//  NumberUtils.swift
//  Gradeva
//
//  Created by Codex CLI on 21/08/25.
//

import Foundation

/// Parses a user-entered decimal string into Double.
/// - Handles current locale formats and common variants (commas/dots).
/// - Strips grouping separators and normalizes decimal separator.
/// - Returns nil for empty, invalid, or non-finite numbers (NaN/Inf).
func parseDecimal(_ raw: String, locale: Locale = .current) -> Double? {
    let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    // Try locale-aware parsing first
    let formatter = NumberFormatter()
    formatter.locale = locale
    formatter.numberStyle = .decimal
    if let num = formatter.number(from: trimmed) {
        let value = num.doubleValue
        return value.isFinite ? value : nil
    }

    // Fallback: sanitize string and normalize decimal separator
    let allowed = CharacterSet(charactersIn: "0123456789.,-+")
    let filteredScalars = trimmed.unicodeScalars.filter { allowed.contains($0) }
    var cleaned = String(String.UnicodeScalarView(filteredScalars))

    let commaCount = cleaned.filter { $0 == "," }.count
    let dotCount = cleaned.filter { $0 == "." }.count

    // Decide decimal separator and remove grouping
    if commaCount > 0 && dotCount == 0 {
        // Use comma as decimal
        cleaned = cleaned.replacingOccurrences(of: ",", with: ".")
    } else if commaCount > 0 && dotCount > 0 {
        // Use the last-seen separator as decimal, drop the other as grouping
        if let lastComma = cleaned.lastIndex(of: ","), let lastDot = cleaned.lastIndex(of: ".") {
            if lastComma > lastDot {
                // comma decimal → remove dots, replace comma with dot
                var temp = cleaned.replacingOccurrences(of: ".", with: "")
                cleaned = temp.replacingOccurrences(of: ",", with: ".")
            } else {
                // dot decimal → remove commas
                cleaned = cleaned.replacingOccurrences(of: ",", with: "")
            }
        }
    } else {
        // Only dots or none → ensure commas removed
        cleaned = cleaned.replacingOccurrences(of: ",", with: "")
    }

    // Final parse
    if let value = Double(cleaned), value.isFinite {
        return value
    }
    return nil
}

