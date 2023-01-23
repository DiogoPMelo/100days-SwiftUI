//
//  TagEntity+CoreDataProperties.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//
//

import Foundation
import CoreData


extension TagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagEntity> {
        return NSFetchRequest<TagEntity>(entityName: "TagEntity")
    }

    @NSManaged public var tag: String?
    @NSManaged public var users: UserEntity?

    public var wrappedTag: String {
        tag ?? "untagged"
    }
}
