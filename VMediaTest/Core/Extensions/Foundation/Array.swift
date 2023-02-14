//
//  Array.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation

extension Array {
    public mutating func appendDistinct<S>(contentsOf newElements: S, needRewrite: Bool = true, where condition: @escaping (Element, Element) -> Bool) where S : Sequence, Element == S.Element {
        newElements.forEach { (item) in
            if !(self.contains(where: { (selfItem) -> Bool in
                return !condition(selfItem, item)
            })) {
                self.append(item)
                return
            }
            
            guard needRewrite else { return }
            
            if let index = self.firstIndex(where: { (selfItem) -> Bool in
                return !condition(selfItem, item)
            }) {
                self[index] = item
            }
        }
    }
}
