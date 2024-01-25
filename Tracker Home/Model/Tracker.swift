//
//  Tracker.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 26.12.2023.
//

import UIKit

//Для хранения информации про трекер(Привычка/Нерегулярное событие)
struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
}
