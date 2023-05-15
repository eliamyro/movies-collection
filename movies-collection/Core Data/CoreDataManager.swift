//
//  CoreDataManager.swift
//  movies-collection
//
//  Created by Elias Myronidis on 15/5/23.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesDataModel")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Loading of store failed: \(error.localizedDescription)")
            }
        }

        return container
    }()
}

extension CoreDataManager {
    func saveFavoriteMedia(media: APIMovie, completed: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let favoriteMedia = FavoriteMedia(context: context)
        favoriteMedia.id = Int32(media.id ?? 0)
        favoriteMedia.title = media.title
        favoriteMedia.name = media.name
        favoriteMedia.type = media.getMediaType

        if context.hasChanges {
            do {
                try context.save()
                completed(true)
            } catch {
                print(error)
                completed(false)
            }
        }
    }

    func deleteFavoriteMedia(id: Int, completed: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMedia> = FavoriteMedia.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %ld", id)
        fetchRequest.includesPropertyValues = false

        do {
            let result = try context.fetch(fetchRequest)
            for object in result {
                context.delete(object)
            }

            if context.hasChanges {
                do {
                    try context.save()
                    completed(true)
                } catch {
                    print(error)
                    completed(false)
                }
            }
        } catch {
            print(error)
            completed(false)
        }
    }

    func isFavorite(id: Int) -> Bool {
        let context = persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<FavoriteMedia> = FavoriteMedia.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %ld", id)

        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print(error)
            return false
        }
    }
}
