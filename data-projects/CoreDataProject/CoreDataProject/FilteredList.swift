//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Diogo Melo on 9/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI
import CoreData
struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    let createdPredicate = NSPredicate(format: "%K CONTAINS[c] %@", "lastname", "s")
    
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, filterValue: String,
         sorters: [NSSortDescriptor] = [],
         predicateType: String = "",
         @ViewBuilder content: @escaping (T) -> Content) {
        let createdPredicate: NSPredicate
        switch predicateType {
        case "begins":
                        createdPredicate = NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
        case "contains":
            createdPredicate = NSPredicate(format: "%K CONTAINS[c] %@", filterKey, filterValue)
        default:
            createdPredicate = NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue)
        }
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors:sorters, predicate: createdPredicate)
        self.content = content
    }
}
