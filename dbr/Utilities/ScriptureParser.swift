//
//  ScriptureUtility.swift
//  dbr
//
//  Created by Ray Krow on 10/4/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit

typealias VerseNumber = Int
typealias VerseIndex = Int

class ScriptureParser {
    
    let originalScripture: String
    var scripture: String
    var attributedScripture: NSMutableAttributedString?
    var verseIndicies = [VerseNumber: VerseIndex]()
    var sectionTitleIndicies = [Range<String.Index>]()
    
    init(for scripture: String) {
        self.originalScripture = scripture
        self.scripture = scripture
        self.parseScripture()
    }
    
    func parseScripture() -> Void {
        self.verseIndicies = stripVerseBracketsForIndicies()
        self.sectionTitleIndicies = getSectionTitleIndicies()
        self.attributedScripture = NSMutableAttributedString(string: self.scripture)
    }
    
    func getSectionTitleIndicies() -> [Range<String.Index>] {
        
        // The magic rule for section titles returned by the ESV api
        // is that they are always wrapped in double new lines and contain
        // no punctuation except question marks.
        var sectionTitleRanges = self.scripture.ranges(of: "\\n(\\s*?)\\n[^\\.:]+\\n\\n", options: .regularExpression)
        
        // Handeling a special case here...When the very first text in the string
        // is the section title it will NOT be preceeded by the double newlines so
        // the above regex will not catch it. However, it will still be followed
        // by double newlines. So, here we do a special check to take the beggining
        // of the text and see if its a section title.
        if let firstNewlineIndex = self.scripture.firstOccurrence(of: "\\n\\n", options: .regularExpression) {
            let adjustedNewLineIndex = String.Index(encodedOffset: firstNewlineIndex.encodedOffset + 2)
            let firstSegmentRange = self.scripture.startIndex..<adjustedNewLineIndex
            let firstSegment = String(self.scripture[firstSegmentRange])
            if firstSegment.doesNotContain(".") {
                sectionTitleRanges.prepend(firstSegmentRange)
            }
        }
        
        for range in sectionTitleRanges {
            let sectionTitle = String(self.scripture[range])
            let updatedSectionTitle = sectionTitle.replacingOccurrences(of: "\\n\\n", with: " \n", options: .regularExpression)
            self.scripture.replaceRange(range, with: updatedSectionTitle)
        }
        
        return sectionTitleRanges
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
            guard let verseNumber = Int(verseNumberStr) else { continue }
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
    
    static func splitScriptureIntoChapters(_ scripture: String) -> [String] {
        
        // Get the indexes of all [1]s
        let verseOneIndexes = scripture.indexes(of: "[1]")
        var indicies = [String.Index]()
        
        // Iterate over all the [1] indexes
        for (n, verseOneIndex) in verseOneIndexes.enumerated() {
            
            // Get the last index of the \n\n occurrence from the current [1] index
            guard let lastDoubleNewLineIndex: String.Index = {
                let isVeryFirstVerseInPassage = n == 0
                if isVeryFirstVerseInPassage {
                    return scripture.startIndex
                } else {
                    return scripture.find(closest: "\\n(\\s*?)\\n[^\\.]+\\n\\n", behind: verseOneIndex)
                }
                }() else {
                    indicies.append(verseOneIndex)
                    continue
            }
            
            // Index the scripture from the found \n\n index to the current [1] index
            let possibleSectionTitle = String(scripture[lastDoubleNewLineIndex..<verseOneIndex])
            
            // If that string matches the rules to be a section title then
            // change the [1] index to include the section title
            let isHighlyProbableSectionTitle = possibleSectionTitle.doesNotContain(".")
            if isHighlyProbableSectionTitle {
                indicies.append(lastDoubleNewLineIndex)
            } else {
                indicies.append(verseOneIndex)
            }
            
        }
        
        return scripture
            .split(at: indicies)
            .shake()
            .map { $0.trim() }
        
    }
    
        
//        // Find all verse [1] markers and insert a super secret token
//        // in front of them. Then split on that token. This way we can
//        // essentailly split at all the verse one markers without removing
//        // them from the original string
//
//        var script = scripture
//        let superSecretToken = "|||xr4ti|||"
//        let verseOneRanges = script.ranges(of: "[1]")
//        var replacements = 0
//
//        for verseOneRange in verseOneRanges {
//            // Have to keep track of times we've made changes to
//            // the original string. As we add in more text we invalidate
//            // ranges that were already determined so here we calculate
//            // the needed adjustment given the super secret tokens we've already
//            // added and then adjust the range so its still accurate
//            guard let adjustedRange: Range<String.Index> = {
//                let adjustment = replacements * superSecretToken.count
//                let location = verseOneRange.lowerBound.encodedOffset + adjustment
//                let length = verseOneRange.upperBound.encodedOffset - verseOneRange.lowerBound.encodedOffset
//                return Range(NSRange(location: location, length: length), in: script)
//            }() else { continue }
//            script.replaceRange(adjustedRange, with: "\(superSecretToken)[1]")
//            replacements += 1
//        }
//
//         return script.components(separatedBy: superSecretToken)
    
    
    
}

extension ScriptureParser {
    func applyAttributeToVerseNumbers(_ attributeName: NSMutableAttributedString.Key, value: Any) -> Void {
        for (verseNumber, verseIndex) in self.verseIndicies {
            self.attributedScripture?.addAttribute(attributeName, value: value, range: NSRange(location: verseIndex, length: verseNumber.digitCount))
        }
    }
    func applyAttributeToSectionTitles(_ attributeName: NSMutableAttributedString.Key, value: Any) -> Void {
        for range in self.sectionTitleIndicies {
            self.attributedScripture?.addAttribute(attributeName, value: value, range: NSRange(range, in: self.scripture))
        }
    }
    func applyAttributeToScripture(_ attributeName: NSMutableAttributedString.Key, value: Any) -> Void {
        self.attributedScripture?.addAttribute(attributeName, value: value, range: NSRange(self.scripture.startIndex..<self.scripture.endIndex, in: self.scripture))
    }
}

