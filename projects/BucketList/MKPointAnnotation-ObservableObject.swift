//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Diogo Melo on 18/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? ""
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? ""
        }
        
        set {
            subtitle = newValue
        }
    }
}

