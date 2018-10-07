//
//  String+Indexes.swift
//  dbr
//
//  Created by Ray Krow on 10/3/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit


extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return self.range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    mutating func replaceRange(_ start: Int, _ end: Int, with replacement: String) -> Void {
        let lowerIndex = self.index(self.startIndex, offsetBy: start)
        let upperIndex = self.index(self.startIndex, offsetBy: end)
        self.replaceRange(lowerIndex..<upperIndex, with: replacement)
    }
    mutating func replaceRange(_ range: Range<String.Index>, with replacement: String) -> Void {
        self.replaceSubrange(range, with: replacement)
    }
    func strip(regex: String) -> String {
        return self.replacingOccurrences(of: regex, with: "", options: .regularExpression)
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = self.startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func index(of string: String, from startPos: Index? = nil, options: CompareOptions = .literal) -> Index? {
        let startPos = startPos ?? self.startIndex
        return range(of: string, options: options, range: startPos ..< endIndex)?.lowerBound
    }
    func firstOccurrence(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func doesNotContain(_ str: String) -> Bool {
        return self.range(of: str) == nil
    }
    func split(at indicies: [String.Index]) -> [String] {
        var lastIndex = self.startIndex
        var slices = [String]()
        indicies.forEach { index in
            slices.append(String(self[lastIndex..<index]))
            lastIndex = index
        }
        slices.append(String(self[lastIndex..<self.endIndex]))
        return slices
    }
    func find(closest string: String, behind index: String.Index, options: CompareOptions = .regularExpression) -> String.Index? {
        return String(self[self.startIndex...index]).findAllOccurrences(of: string, options: options).last
    }
    func findAllOccurrences(of string: String, options: CompareOptions = .regularExpression) -> [String.Index] {
        var indices = [String.Index]()
        var searchStartIndex = self.startIndex
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, options: options, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            indices.append(range.lowerBound)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    func trim() -> String {
        return self.replacingOccurrences(of: "^[\\s\\n]+|[\\s\\n]+$", with: "", options: .regularExpression)
    }
}
