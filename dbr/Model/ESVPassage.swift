//
//  ESVPassage.swift
//  dbr
//
//  Created by Ray Krow on 9/30/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation

struct ESVPassageResponse: Codable {
//    let query: String
//    let canonical: String
//    let parsed: [String]
//    let passageMeta: [ESVPassageMeta]
    let passages: [String]
    private enum CodingKeys: String, CodingKey {
//        case query
//        case canonical
//        case parsed
//        case passageMeta = "passage_meta"
        case passages
    }
}

struct ESVPassageMeta: Codable {
    let canonical: String
    let chapterStart: [Int]
    let chapterEnd: [Int]
    let prevVerse: Int
    let nextVerse: Int
    let prevChapter: [Int]
    let nextChapter: [Int]
    private enum CodingKeys: String, CodingKey {
        case canonical
        case chapterStart = "chapter_start"
        case chapterEnd = "chapter_end"
        case prevVerse = "prev_verse"
        case nextVerse = "next_verse"
        case prevChapter = "prev_chapter"
        case nextChapter = "next_chapter"
    }
}
