//
//  VerseCell.swift
//  dbr
//
//  Created by Ray Krow on 9/29/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class VerseCell: UITableViewCell {
    
    
    @IBOutlet weak var passage: UILabel!
    
    let disposeBag = DisposeBag()
    
    func setVerse(_ verse: String) -> Void {
        
        if (verse == "Ephesians 1") {
            self.passage.text = "xxxxx The book of the genealogy of Jesus Christ, bthe son of David, cthe son of Abraham.\n2 dAbraham was the father of Isaac, and eIsaac the father of Jacob, and fJacob the father of Judah and his brothers, 3 and gJudah the father of Perez and Zerah by Tamar, and Perez the father of Hezron, and Hezron the father of Ram,1 4 and Ram the father of Amminadab, and Amminadab the father of Nahshon, and Nahshon the father of Salmon, 5 and Salmon the father of Boaz by hRahab, and Boaz the father of Obed by Ruth, and Obed the father of Jesse, 6 and iJesse the father of David the king."
        } else {
            self.passage.text = "ooooooo Then Herod summoned the wise men secretly and ascertained from them what time the star had appeared. 8 And he sent them to Bethlehem, saying, “Go and search diligently for the child, and when you have found him, bring me word, that I too may come and worship him.” 9 After listening to the king, they went on their way."
        }
        
//        ESVService.getPassage(verse).subscribe(onNext: { text in
//            guard let t = text else { return }
//            self.passage.text = t.joined(separator: "\n")
//        }).disposed(by: disposeBag)
    }
    
}
