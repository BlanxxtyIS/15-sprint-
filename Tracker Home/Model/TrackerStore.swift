//
//  TrackerStore.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 25.01.2024.
//

import UIKit
import CoreData

class TrackerStore {
    
    static let shared = TrackerStore()
    
    private let context: NSManagedObjectContext
    let categoryStore = TrackerCategoryStore()
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //Преобразование TrackerCoreData в Tracker
    func convertToTracker(trackerCoreData: TrackerCoreData) -> Tracker {
        let id = trackerCoreData.id!
        let name = trackerCoreData.name!
        let color = UIColor(named: trackerCoreData.color as! String)!
        let emoji = trackerCoreData.emoji!
        var decodedWeekday: [Weekday] = []
        if let data = trackerCoreData.schedule,
           let decodedWeekdays = try? JSONDecoder().decode([Weekday].self, from: data as! Data) {
            decodedWeekday = decodedWeekdays
            let schedule = decodedWeekday
            
        }
        var tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: decodedWeekday)
        return tracker
    }
        
    //Добавляем Tracker в TrackerCoreData
    func saveTrackerCoreData(toCategory: TrackerCategory, tracker: Tracker) {
        let newTracker = TrackerCoreData(context: context)
        
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.color = tracker.color
        newTracker.emoji = tracker.emoji
        let encoder = JSONEncoder()
        if let weekdaysData = try? encoder.encode(tracker.schedule) {
            newTracker.schedule = weekdaysData as NSData
        } else {
            print("Ошибка при преобразовании schedule в CD в классе TrackerStore")
        }
        
        do { 
            try self.context.save()
        } catch {
            let nsError = error as NSError
            print(nsError, nsError.localizedDescription)
        }
    }
    
    func fetchTrackerWithId(_ id: UUID) -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let tracker = try! context.fetch(request)
        return tracker[0]
    }
    
    func fetchTrackersOfCategory(_ category: TrackerCategoryCoreData) -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "category == %@", category)
        let trackers = try! context.fetch(request)
        return trackers
    }
    
    private func fetchTrackers() -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        let trackers = try! context.fetch(request)
        return trackers
    }
    
    func convertToTrackers(_ coreData: [TrackerCoreData]) -> [Tracker] {
        var trackers: [Tracker] = []
        for tracker in coreData {
            let converted = convertToTracker(trackerCoreData: tracker)
            trackers.append(converted)
        }
        return trackers
    }
    
    func getTrackers() -> [Tracker] {
        return convertToTrackers(fetchTrackers())
    }
    
    func getNumberOfTrackers() -> Int {
        let trackers = getTrackers()
        return trackers.count
    }
}
