//
//  WeekdayTransformer.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 18.01.2024.
//

import Foundation

@objc
final class WeekdayTransformer: ValueTransformer {
    //Свойства которые описывают тип данных для хранения в Transformatable
    //Указывает, что нужна конвертация для чтения и записи
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    //Переопределяем функции, которые кодируют и декодируют
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
    
    //Зарегистрируем кастомный трансформер и сообщим о нем системе:
    static func register() {
            ValueTransformer.setValueTransformer(
                WeekdayTransformer(),
                forName: NSValueTransformerName(rawValue: String(describing: WeekdayTransformer.self)))
        }
    
    //Зарегистрируем трансформер в AppDelegate
    //WeekdayTransformer.register()
}
//для сериализации / сохранения
//let weekdays: [Weekday] = [.friday, .monday]
//let data: NSData? = try? NSKeyedArchiver.archivedData(withRootObject: weekdays, requiringSecureCoding: false) as NSData
//tracker.schedule = data

//для десериализации / Получения значения из CoreData
//let fetchedData = tracker.schedule
//if let nsData = fetchedData as? NSData,
//    let data = nsData as Data,
//    let decodedWeekdays = try? JSONDecoder().decode([Weekday].self, from: data) {
//    
//    // есть массив [Weekday], который вы можете использовать
//    print("Decoded Weekdays: \(decodedWeekdays)")
//}

