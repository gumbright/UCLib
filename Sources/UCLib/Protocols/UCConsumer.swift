//
//  Providable.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 29/11/2020.
//

import Foundation

public protocol UCConsumer {
    associatedtype ConsumedItem: Hashable
    func consume(_ item: ConsumedItem)
}
