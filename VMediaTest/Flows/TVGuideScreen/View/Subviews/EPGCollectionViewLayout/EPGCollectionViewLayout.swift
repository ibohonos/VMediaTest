//
//  EPGCollectionViewLayout.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 13.02.2023.
//

import Foundation
import UIKit

class EPGCollectionViewLayout: UICollectionViewLayout {
    let cellWidth: Double = 400
    let cellHeight: Double = 130
    var cellAttributesDictionary = [IndexPath: UICollectionViewLayoutAttributes]()
    var contentSize = CGSize.zero
    var channels: [ChannelSection]?
    var timeCount: Int = 0
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        cellAttributesDictionary.removeAll()
        
        guard let collectionView = collectionView,
              let sectionCount = channels?.count else {
            return
        }
        
        for section in 0 ... sectionCount {
            let yPos = Double(section) * cellHeight
            
            let channel: ChannelSection? = (section == 0) ? nil : channels?[section - 1]
            let rowCount = (section == 0) ? timeCount : channel?.programs.count ?? 0
            
            for item in 0 ... rowCount {
                let cellIndex = IndexPath(item: item, section: section)
                
                var xPos = Double(item) * cellWidth
                var width = cellWidth
                
                let program: ProgramItem? = (section > 0 && item > 0) ? channel?.programs[item - 1] : nil
                
                if let program, let startDate = program.startTime.toDate {
                    xPos = cellWidth * (startDate.timeIntervalFromStartOfDay / 60 / 30) + cellWidth
                    width = (program.length / 30) * cellWidth
                }
                
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                cellAttributes.frame = CGRect(x: xPos, y: yPos, width: width, height: cellHeight)
                
                cellAttributesDictionary[cellIndex] = cellAttributes
            }
        }
        
        contentSize = CGSize(width: timeCount * Int(cellWidth), height: collectionView.numberOfSections * Int(cellHeight) + 30)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributesDictionary.values.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDictionary[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
