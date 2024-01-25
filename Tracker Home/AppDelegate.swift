//
//  AppDelegate.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 22.12.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Регестрируем трансформер
        WeekdayTransformer.register()
        ColorTransformer.register()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    //Cоздали свойство контейнера
    lazy var persistentContainer: NSPersistentContainer = {
        //создали контейнер с именем базы. Нзвание = имя файла, в который были добавлены сущности
        let container = NSPersistentContainer(name: "CoreData")
        //loadPersistentSores - загрузка модели, создание и настройка координатора и хранилиза.
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            //Обработка ошибок
            if let error = error as NSError? {
                // Код для обработки ошибки
                fatalError("\(error) \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror), \(nserror.userInfo)")
            }
        }
    }
}

