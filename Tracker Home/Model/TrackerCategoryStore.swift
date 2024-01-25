//
//  TrackerCategoryStore.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 25.01.2024.
//

import UIKit
import CoreData

private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidHeader
    case decodingErrorInvalidTracker
}

class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var coreDataCategories: [ TrackerCategoryCoreData ]?
    
    //Извлекаем из CoreData
    func getCategories()  -> [TrackerCategory] {
        return try! trackerCategory(from: (fetchCoreDataCategories()))
    }

    //Преобразование TrackerCategoriesCoreData в TrackerCategories
    func trackerCategory(from trackerCategoryCoreData: [TrackerCategoryCoreData]) throws -> [TrackerCategory] {
        var cdCategory: [TrackerCategory] = []
        for category in trackerCategoryCoreData {
            let id = category.id!
            let header = category.header!
            var trackers: [Tracker] = []
            let allTrackers = category.trackers?.allObjects as? [TrackerCoreData]
            for tracker in trackers {
                let id = tracker.id
                let name = tracker.name
                let color = tracker.color
                let emoji = tracker.emoji
                let schedule = tracker.schedule
                let newTracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
                trackers.append(newTracker)
            }
            let newCategory = TrackerCategory(header: header, tracker: trackers, id: id)
            cdCategory.append(newCategory)
        }
        return cdCategory
    }
    
    private func fetchCoreDataCategories() -> [TrackerCategoryCoreData]  {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        } catch {
            print(error)
        }
        return categories
    }
    
    func saveCategoryToCoreData(_ category: TrackerCategory) {
        if !isCategoryInCoreData(category) {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.id = category.id
            newCategory.header = category.header
            do {
                try self.context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isCategoryInCoreData(_ category: TrackerCategory) -> Bool {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        } catch {
            print(error)
        }
        if categories.contains(where: { $0.id == category.id}) {
            return true
        } else {
            return false
        }
    }
    
    func fetchCategoryWithId(_ id: UUID) -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let category = try! context.fetch(request)
        return category[0]
    }
    
    func renameCategory(_ id: UUID, newName: String) {
        let category = fetchCategoryWithId(id)
        category.header = newName
        do {
            try self.context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteCategory(_ id: UUID) {
        let category = fetchCategoryWithId(id)
        
        if let trackers = category.trackers?.allObjects as? [TrackerCoreData] {
            for tracker in trackers {
                context.delete(tracker)
            }
        }
        context.delete(category)
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
