//
//  CoreDataManager.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 28.11.24.
//

import CoreData

final class CoreDataService {
    
private let context: NSManagedObjectContext

init(context: NSManagedObjectContext) {
    self.context = context
}

func fetchUsers() -> [UserEntity]? {
    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    do {
        return try context.fetch(fetchRequest)
    } catch {
        print("Error fetching users: \(error)")
        return nil
    }
}

    func saveUser(id: Int, name: String, email: String) {
        let user = UserEntity(context: context)
        user.id = Int64(id)
        user.name = name
        user.email = email
        
        do {
            try context.save()
        } catch {
            print("Error saving user: \(error)")
        }
    }

    func deleteUser(user: UserEntity) {
        context.delete(user)
        do {
            try context.save()
        } catch {
            print("Error deleting user: \(error)")
        }
    }
}
