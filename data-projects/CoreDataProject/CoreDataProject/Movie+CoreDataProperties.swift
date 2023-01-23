//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Diogo Melo on 8/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var director: String?
    @NSManaged public var title: String?
    @NSManaged public var year: Int16

    // instead of optionals, unwrap core data types as computed properties
    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    
}
