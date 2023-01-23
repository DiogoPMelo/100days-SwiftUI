//
//  Person.swift
//  Photonames
//
//  Created by Diogo Melo on 25/10/20.
//

import SwiftUI

struct Person: Identifiable, Comparable, Codable {
    var id = UUID()
    var name: String
    var photo: UIImage

    static func < (lhs: Person, rhs: Person) -> Bool{
        lhs.name < rhs.name
    }

    enum CodingKeys: CodingKey {
        case id, name, photo
    }
    
    init (name: String, photo: UIImage) {
        self.name = name
        self.photo = photo
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let jpegData = try container.decode(Data.self, forKey: .photo)
        photo = UIImage(data: jpegData) ?? UIImage()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)

        if let jpegData = photo.jpegData(compressionQuality: 0.8) {
        try container.encode(jpegData, forKey: .photo)
        }
    }
}
