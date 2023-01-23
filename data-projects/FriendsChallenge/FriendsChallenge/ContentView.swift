//
//  ContentView.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: UserEntity.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \UserEntity.name, ascending: true)], predicate: nil)
    var usersList: FetchedResults<UserEntity>
    
//    @State private var users: [User] = []
    
    var body: some View {
        NavigationView {
        List (usersList, id: \.wrappedId) { user in
            NavigationLink (destination:
            DetailedView(user: user)) {
                                ListView(user: user)
                                        }
        }.onAppear(perform: loadData)
            .navigationBarTitle("FriendsChallenge \(usersList.count)")
        }
    }
    
    func loadData() {
//        for del in self.usersList {
//            self.moc.delete(del)
//            try? self.moc.save()
//        }
        guard self.usersList.isEmpty else {
                        return
        }
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                                if let decodedResponse = try? JSONDecoder().decode([User].self, from: data) {
                                        DispatchQueue.main.async {
//                                                self.users = decodedResponse
                                            for user in decodedResponse {
                                                let newUser = UserEntity(context: self.moc)
                                                newUser.id = user.id
                                                newUser.name = user.name
                                                newUser.isActive = user.isActive
                                                newUser.age = Int16(user.age)
                                                newUser.company = user.company
                                                newUser.email = user.email
                                                newUser.address = user.address
                                                newUser.about = user.about
                                                newUser.registered = user.registered
                                                for tag in user.tags {
                                                    let newTag = TagEntity(context: self.moc)
                                                    newTag.tag = tag
                                                    newUser.addToTags(newTag)
                                                }
                                                
                                                for friend in user.friends {
                                                    let newFriend = FriendEntity(context: self.moc)
                                                    newFriend.id = friend.id
                                                    newFriend.name = friend.name
                                                    newUser.addToFriends(newFriend)
                                                }
                                                
                                                try? self.moc.save()
                                            }

                                            print("\(self.usersList.count)")
                                            
                                                                    return
                    }
                }
            }
                    }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
