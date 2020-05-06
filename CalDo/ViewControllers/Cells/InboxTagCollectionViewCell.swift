//
//  InboxTagCollectionCollectionViewCell.swift
//  CalDo
//
//  Created by Fabian Jaeger on 2/14/20.
//  Copyright © 2020 CalDo. All rights reserved.
//

import UIKit

class InboxTagCollectionCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var TagLabel: UILabel!
    
}

//class TagCollection: UICollectionView, UICollectionViewDataSource{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
//        let text = ["Test","Test","Test"]
//        cell.TagLabel.text = text[indexPath.row]
//        cell.TagLabel.textColor = UIColor.white
//
//        return cell
//    }
//
//
//}
