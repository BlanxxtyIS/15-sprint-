//
//  TrackerCategory.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 26.12.2023.
//

import Foundation

//Для хранения трекеров по категориям
struct TrackerCategory {
    let header: String
    var tracker: [Tracker]
    let id: UUID
}
