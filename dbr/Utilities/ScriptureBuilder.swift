//
//  ScriptureUtility.swift
//  dbr
//
//  Created by Ray Krow on 10/4/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    mutating func replaceRange(_ start: Int, _ end: Int, with replacement: String) -> Void {
        let lowerIndex = self.index(self.startIndex, offsetBy: start)
        let upperIndex = self.index(self.startIndex, offsetBy: end)
        self.replaceSubrange(lowerIndex..<upperIndex, with: replacement)
    }
}

extension Int {
    var digitCount: Int {
        return NSString(string: "\(self)").length
    }
}

typealias VerseNumber = Int
typealias VerseIndex = Int

class ScriptureBuilder {
    
    let originalScripture: String
    var scripture: String
    var attributedScripture: NSMutableAttributedString?
    var verseIndicies = [VerseNumber: VerseIndex]()
    
    init(for scripture: String) {
        self.originalScripture = scripture
        self.scripture = scripture
        self.parseScripture()
    }
    
    func parseScripture() -> Void {
        self.verseIndicies = stripVerseBracketsForIndicies()
        self.attributedScripture = NSMutableAttributedString(string: self.scripture)
    }
    
    func convertToAttributedScripture(_ scripture: String) -> NSMutableAttributedString {
        // let verseIndices =
        return NSMutableAttributedString(string: "")
    }
    
    func stripVerseBracketsForIndicies() -> [VerseNumber: VerseIndex] {
        
        // We will be finding all the verse number labels .i.e. [2] and [23] and removing
        // the brackets from them. We want use this var to keep track of the new index
        // of every verse number after the brackets are removed so that later we can
        // know the location of all the verse numbers in our scripture.
        var indicies = [VerseNumber: VerseIndex]()
        
        guard let regex = try? NSRegularExpression(pattern: "\\[[0-9]+\\]") else { return indicies }
        
        let regexResult = regex.matches(in: self.scripture, range: NSRange(location: 0, length: (self.scripture as NSString).length))
        
        for match in regexResult {
            
            // As we move through the scripture and remove the [] that surround verse numbers
            // we make the string shorter - invalidating the list of regex results we originally
            // got. Here we create an adjustment: 2 carachters (i.e. []) for every time we've
            // already moved through the scripture
            let adjustment = indicies.count * 2
            let lowerBound = match.range.lowerBound - adjustment
            let upperBound = match.range.upperBound - adjustment
            
            // Get the charactres at that range. i.e: '[1]'
            let bracketedVerse = String(self.scripture[lowerBound..<upperBound])
            
            // Take the verse number only and replace the existing bracketed verse
            // number with it.
            let end = NSString(string: bracketedVerse).length - 1
            let verseNumberStr = bracketedVerse[1..<end]
            let verseNumber = Int(verseNumberStr)!
            
            self.scripture.replaceRange(lowerBound, upperBound, with: "\(verseNumber)")
            
            // If the verse was previously surrounded in brackets
            // [1] and we removed the brackets
            // 1 we can always assume that the verse is located
            // at our originally adjusted lower bound
            let verseIndex = lowerBound
            
            indicies[verseNumber] = verseIndex
            
        }
        
        return indicies
    }
    
}

extension ScriptureBuilder {
    func applyAttributeToVerseNumbers(_ attributeName: NSMutableAttributedString.Key, value: Any) -> Void {
        for (verseNumber, verseIndex) in self.verseIndicies {
            self.attributedScripture?.addAttribute(attributeName, value: value, range: NSRange(location: verseIndex, length: verseNumber.digitCount))
        }
    }
    func setVerseNumberFont(_ font: UIFont) -> Void {
        self.applyAttributeToVerseNumbers(NSMutableAttributedString.Key.font, value: font)
    }
    func moveVerseNumbersToSubscript() -> Void {
        self.applyAttributeToVerseNumbers(NSMutableAttributedString.Key.baselineOffset, value: 10)
    }
}
