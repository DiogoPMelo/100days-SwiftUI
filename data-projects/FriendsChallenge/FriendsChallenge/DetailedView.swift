//
//  DetailedView.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI
import CoreData

struct ListView: View {
    let user: UserEntity
    
    var body: some View {
        VStack {
            Text(user.wrappedName)
            HStack {
                Text(user.wrappedCompany)
                Text("\(user.wrappedAge)")
            }
        }
    }
}
    

struct DetailedView: View {
    
    
    
    var fetchRequest: FetchRequest<UserEntity>
    
    let user: UserEntity
    var friends: FetchedResults<UserEntity> { fetchRequest.wrappedValue }
    
    init(user: UserEntity) {
        self.user = user
        
var friendsId = [String]()
        for friend in user.friendsList {
            friendsId.append(friend.wrappedId)
        }
        
        let createdPredicate = NSPredicate(format: "id IN %@", friendsId)
        fetchRequest = FetchRequest<UserEntity>(entity: UserEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.name, ascending: true)], predicate: createdPredicate)
        //self.friends = []
        // before coredata
//        var userFriends = [User]()
//        for friend in user.friends {
//            if let match = allUsers.first(where: {
//                $0.id == friend.id}) {
//                userFriends.append(match)
//            }
//        }
                // self.friends = userFriends
    }
    
    var body: some View {
        VStack {
            Section {
                Text(user.wrappedEmail)
                Text(user.wrappedCompany)
            }
            Text(user.wrappedAbout)
            Section (header: Text("Tags (\(user.tagsList.count)")) {
            HStack {
                ForEach(self.user.tagsList, id: \.self) { tag in
                    Text(tag)
                }
            }
            }
            Spacer()
            Section (header: Text("Friends (\(friends.count)")) {
            HStack {
                ForEach(friends, id: \.id) { friend in
                    NavigationLink(destination:
                    DetailedView(user: friend)) {
                    ListView(user: friend)
                    }
                }
                }
            }
        }.navigationBarTitle(user.wrappedName)
    }
}

struct DetailedView_Previews: PreviewProvider {
static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let user = UserEntity(context: moc)

        return DetailedView(user: user)
        // pre coredata
//        DetailedView(user: .init(id: "123", name: "User Test", isActive: true, age: 22, company: "unknown", email: "coisinho@cenas.com", address: "rua das cenas", about: "unwritten", registered: "123", tags: ["one", "two"], friends: [Friend(id: "124", name: "other")]), allUsers: [])
    }
}
