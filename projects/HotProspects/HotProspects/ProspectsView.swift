//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Diogo Melo on 29/10/20.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    let filter: FilterType
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }

    @State private var showOrder = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
            VStack(alignment: .leading) {
                Text(prospect.name)
                    .font(.headline)
                HStack {
                Text(prospect.emailAddress)
                    .foregroundColor(.secondary)
                    if filter == FilterType.none {
                    if prospect.isContacted {
                        Image(systemName: "checkmark.circle")
                            .accessibility(removeTraits: .isImage)
                                                        .accessibilityLabel(Text("Contacted"))
                    } else {
                        Image(systemName: "questionmark.diamond")
                            .accessibility(removeTraits: .isImage)
                            .accessibilityLabel(Text("Uncontacted"))
                    }
                    }
                }
            }.accessibilityElement(children: .combine)
            .accessibilityAction(named: Text("Remind Me"), {
                self.addNotification(for: prospect)
                        })
                                .accessibilityAction(named: Text(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ), {
                self.prospects.toggle(prospect)
            })
                        .contextMenu {
                Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                    self.prospects.toggle(prospect)
                }
                if !prospect.isContacted {
                    Button("Remind Me") {
                        self.addNotification(for: prospect)
                    }
                }
            }
        }
    }
                .navigationBarTitle(title)
            .navigationBarItems(leading: Button("Sort") {
                self.showOrder = true
            }, trailing: Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $showOrder) {
                ActionSheet(title: Text("Reorder"), buttons: [
                                .default(Text("Chrono")) {
                                    self.prospects.sortChronollogicaly()
                                },
                    .default(Text("By name")) {
                        self.prospects.sortByName()
                    }
                ])
            }
        
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            
            self.prospects.add(person)
                    case .failure(let error):
            print("Scanning failed")
        }
    }

    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    enum FilterType {
        case none, contacted, uncontacted
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
