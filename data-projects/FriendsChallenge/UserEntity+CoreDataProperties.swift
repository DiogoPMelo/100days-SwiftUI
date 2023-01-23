//
//  UserEntity+CoreDataProperties.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: String?
    @NSManaged public var friends: NSSet?
    @NSManaged public var tags: NSSet?

    public var wrappedId: String {
        id ?? "unattributed"
    }
    
    public var wrappedName: String {
        name ?? "unnamed"
    }
    
    public var wrappedAge: Int {
        Int(age)
    }
    
    public var wrappedCompany: String {
        company ?? "Apple"
    }
    
    public var wrappedEmail: String {
        email ?? "N/A"
    }
    
    public var wrappedAddres: String {
        address ?? "N/A"
    }
    
    public var wrappedAbout: String {
        about ?? "nothing to say"
    }
    
    public var wrappedRegister: String {
        registered ?? "unregistered"
    }
    
    public var tagsList: [String] {
        let set = tags as? Set<TagEntity> ?? []
        let orderedTags = set.sorted {
            $0.wrappedTag < $1.wrappedTag
        }
        var tagsAsString = [String]()
        for tag in orderedTags {
            tagsAsString.append(tag.wrappedTag)
        }
        return tagsAsString
    }
    
    public var friendsList: [FriendEntity] {
        let set = friends as? Set<FriendEntity> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for friends
extension UserEntity {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendEntity)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendEntity)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension UserEntity {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagEntity)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagEntity)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
