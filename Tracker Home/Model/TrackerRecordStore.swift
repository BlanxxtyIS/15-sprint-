//
//  TrackerRecordStore.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 25.01.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    static let shared = TrackerRecordStore()
    let trackerStore = TrackerStore.shared
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getCompletedTrackers() -> [TrackerRecord] {
        return convertToTrackerRecord(coreDataRecords: fetchCompletedRecords())
    }
    
    private func fetchCompletedRecordsForDate(_ date: Date) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            records = try context.fetch(request)
        } catch {
            print(error)
        }
        return records
    }
    
    func fetchCompletedRecordsForTracker(_ tracker: TrackerCoreData) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        do {
            records = try context.fetch(request)
        } catch {
            print(error)
        }
        return records
    }
    
    func deleteCompletedRecordsForTracker(_ tracker: TrackerCoreData) {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        do {
            records = try context.fetch(request)
            for record in records {
                context.delete(record)
                do {
                    try self.context.save()
                }
                catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func fetchCompletedRecords() -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        do {
            records = try context.fetch(request)
        } catch {
            print(error)
        }
        return records
    }
    
    private func convertToTrackerRecord(coreDataRecords: [TrackerRecordCoreData]) -> [TrackerRecord] {
        var trackerRecords: [TrackerRecord] = []
        for trackerRecord in coreDataRecords {
            let date = trackerRecord.date!
            let tracker = trackerStore.convertToTracker(trackerCoreData: trackerRecord.tracker!)
            let newRecord = TrackerRecord(id: tracker.id, date: date)
            trackerRecords.append(newRecord)
        }
        return trackerRecords
    }
    
    func saveTrackerRecordCoreData(_ trackerRecord: TrackerRecord) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.date = trackerRecord.date
        let tracker = trackerStore.fetchTrackerWithId(trackerRecord.id)
        newTrackerRecord.tracker = tracker
        
        do {
            try self.context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteTrackerRecord(with id: UUID, on date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let trackerCoreData = trackerStore.fetchTrackerWithId(id)
        
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K BETWEEN {%@, %@}",
                                        #keyPath(TrackerRecordCoreData.tracker), trackerCoreData,
                                        #keyPath(TrackerRecordCoreData.date), startOfDay as NSDate, Date() as NSDate)
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
}
