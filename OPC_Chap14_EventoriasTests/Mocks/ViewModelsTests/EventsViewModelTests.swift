//
//  EventsViewModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
import FirebaseAuth
@testable import OPC_Chap14_Eventorias


final class EventsViewModelTests: XCTestCase {
    var firestoreEventServiceMock: FirestoreServiceMock!
    var firestoreUserServiceMock: FirestoreServiceMock!
    var storageServiceMock: StorageFirebaseMock!
    
    
    override func setUpWithError() throws {
        firestoreEventServiceMock = FirestoreServiceMock()
        firestoreUserServiceMock = FirestoreServiceMock()
        storageServiceMock = StorageFirebaseMock()
    }
    
    override func tearDownWithError() throws {
        firestoreEventServiceMock.shouldSuccess = false
        firestoreEventServiceMock.data = nil
        firestoreUserServiceMock.shouldSuccess = false
        firestoreUserServiceMock.data = nil
        storageServiceMock.shouldSuccess = false
        storageServiceMock.data = nil
    }
    
    @MainActor
    func testFetchEventsOk() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        await eventsViewModel.fetchEvents()
        XCTAssert(eventsViewModel.events.count == 2)
        XCTAssert(eventsViewModel.events[0].user == "pierrePasLeBest")
        XCTAssert(eventsViewModel.events[1].user == "hboLeBest")
    }
    
    @MainActor
    func testFetchEventsNOk() async {
        firestoreEventServiceMock.shouldSuccess = false
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .failedMultiFetch)
    }
    
    @MainActor
    func testFetchEventsNOkUsers() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = false
        storageServiceMock.shouldSuccess = true
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .notAbleToFetchUser)
    }
    
    @MainActor
    func testFetchEventsNOkStorage() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = false
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .imageUrlNotFound)
    }
    
    @MainActor
    func testFetchEventOk() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        await eventsViewModel.fetchEvent(with: "xjknsq")
        XCTAssert(eventsViewModel.events.count == 1)
        XCTAssert(eventsViewModel.events[0].user == "pierrePasLeBest")
    }
    
    @MainActor
    func testFetchEventNOk() async {
        firestoreEventServiceMock.shouldSuccess = false
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvent(with: "hjxqsjhqsb")
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .failedFetch)
    }
    
    @MainActor
    func testFetchEventNOkUsers() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = false
        storageServiceMock.shouldSuccess = true
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvent(with: "xjknsl")
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .notAbleToFetchUser)
    }
    
    @MainActor
    func testFetchEventNOkStorage() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = false
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvent(with: "xjknsl")
        XCTAssert(eventsViewModel.alertIsPresented == true)
        XCTAssert(eventsViewModel.alert == .imageUrlNotFound)
    }
    
    @MainActor
    func testFilteredEventsDescendingNoSearch() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        eventsViewModel.search = ""
        eventsViewModel.sorting = .dateDescending
        
        XCTAssertEqual(eventsViewModel.filteredEvents.count, 2)
        XCTAssertEqual(eventsViewModel.filteredEvents[0].name,"Musée du Louvres")
    }
    
    @MainActor
    func testFilteredEventsAscendingNoSearch() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        eventsViewModel.search = ""
        eventsViewModel.sorting = .dateAscending
        
        XCTAssertEqual(eventsViewModel.filteredEvents.count, 2)
        XCTAssertEqual(eventsViewModel.filteredEvents[1].name,"Musée du Louvres")
    }
    
    @MainActor
    func testFilteredEventsNoneNoSearch() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        eventsViewModel.search = ""
        eventsViewModel.sorting = .none
        
        XCTAssertEqual(eventsViewModel.filteredEvents.count, 2)
        XCTAssertEqual(eventsViewModel.filteredEvents[0].name,"Musée du Louvres")
    }
    
    @MainActor
    func testFilteredEventSearch() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        storageServiceMock.url = URL(string: "https://github.com/twostraws/Vortex")
        
        let eventsJson =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum",
            "user": "pierrePasLeBest",
            "image": "https://github.com/twostraws/Vortex"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival",
            "user": "hboLeBest",
            "image": "https://github.com/twostraws/Vortex"
        }
        ]
        """
        
        let dataEvents =  eventsJson.data(using: .utf8)!
        firestoreEventServiceMock.data = dataEvents
        
        let usersJson =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hboLeBest"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "pierrePasLeBest"
        }
        ]
        """
        let dataUsers =  usersJson.data(using: .utf8)!
        firestoreUserServiceMock.data = dataUsers
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        
        await eventsViewModel.fetchEvents()
        eventsViewModel.search = EventType.museum.rawValue.lowercased()
        eventsViewModel.sorting = .none
        
        XCTAssertEqual(eventsViewModel.filteredEvents.count, 1)
        XCTAssertEqual(eventsViewModel.filteredEvents[0].name,"Musée du Louvres")
    }
    
    @MainActor
    func testSortingToDescending() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        eventsViewModel.sorting = .none
        eventsViewModel.sortingHit()
        
        XCTAssert(eventsViewModel.sorting == .dateDescending)
    }
    
    @MainActor
    func testSortingToAcscending() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        eventsViewModel.sorting = .dateDescending
        eventsViewModel.sortingHit()
        
        XCTAssert(eventsViewModel.sorting == .dateAscending)
    }
    
    @MainActor
    func testSortingToNone() async {
        firestoreEventServiceMock.shouldSuccess = true
        firestoreUserServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventsViewModel = EventsViewModel(event: [],
                                              eventFirestore: firestoreEventServiceMock,
                                              userFirestore: firestoreUserServiceMock, storage: storageServiceMock)
        eventsViewModel.sorting = .dateAscending
        eventsViewModel.sortingHit()
        
        XCTAssert(eventsViewModel.sorting == .none)
    }
}

//func sortingHit() {
//    switch sorting {
//    case .none:
//        sorting = .dateDescending
//    case .dateDescending:
//        sorting = .dateAscending
//    case .dateAscending:
//        sorting = .none
//    }
//}
