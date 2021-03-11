//
//  Collection+Extensions.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/11/21.
//

import Foundation

extension Array where Element: Identifiable {
    func shouldPaginate(on item: Element) -> Bool {
        guard let itemIndex = firstIndex(where: { $0.id == item.id }), let lastIndex = firstIndex(where: { $0.id == last?.id }) else { return false }
        let itemsDistance = self.distance(from: itemIndex, to: lastIndex)
        
        return itemsDistance < 4
    }
}
