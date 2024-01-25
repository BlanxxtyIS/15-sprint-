//
//  ColorTransformer.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 24.01.2024.
//

import UIKit

class ColorTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    static func register() {
        let transformer = ColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: String(describing: ColorTransformer.self)))
    }
}

//сохранить в CoreData:
//let tracker = TrackerCoreData(context: context)
//tracker.color = UIColor.red

//Извлечь цвет
//if let savedColor = tracker.color as? UIColor {
//    print(savedColor)
//}

