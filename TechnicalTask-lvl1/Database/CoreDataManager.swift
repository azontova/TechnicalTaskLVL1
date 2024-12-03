//
//  CoreDataManager.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 28.11.24.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext

    private init() {
        persistentContainer = NSPersistentContainer(name: "Users")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }

    func fetchUsers() -> [User] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities.map { userEntity in
                User(
                    name: userEntity.name ?? "",
                    email: userEntity.email ?? "",
                    address: Address(
                        street: userEntity.street ?? "",
                        suite: userEntity.suite ?? "",
                        city: userEntity.city ?? "",
                        zipcode: userEntity.zipcode ?? ""
                    )
                )
            }
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }

    func saveUsers(_ users: [User]) {
        context.performAndWait {
            for user in users {
                if !userExists(with: user.email) {
                    let userEntity = UserEntity(context: context)
                    userEntity.name = user.name
                    userEntity.email = user.email
                    userEntity.city = user.address.city
                    userEntity.zipcode = user.address.zipcode
                    userEntity.suite = user.address.suite
                    userEntity.street = user.address.street
                }
            }
            do {
                try context.save()
            } catch {
                print("Failed to save users: \(error)")
            }
        }
    }

    func deleteUser(user: User) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", user.email)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let userEntity = users.first {
                context.delete(userEntity)
                try context.save()
            }
        } catch {
            print("Error deleting user: \(error)")
        }
    }
    
    func userExists(with email: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking user existence: \(error)")
            return false
        }
    }
}
