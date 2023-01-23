//
//  FriendEntity+CoreDataProperties.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendEntity> {
        return NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var users: NSSet?

    public var wrappedId: String {
        id ?? "unattributed"
    }
    
    public var wrappedName: String {
        name ?? "unknown"
    }
}

// MARK: Generated accessors for users
extension FriendEntity {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: UserEntity)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: UserEntity)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
