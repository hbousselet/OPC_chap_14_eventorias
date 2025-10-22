//
//  EventModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
@testable import OPC_Chap14_Eventorias


final class EventModelTests: XCTestCase {
    var firestoreService: FirestoreServiceMock!

    override func setUpWithError() throws {
        firestoreService = FirestoreServiceMock()
    }

    override func tearDownWithError() throws {
        firestoreService.shouldSuccess = false
        firestoreService.data = nil
    }
    
    @MainActor
    func testFetchEventsOk() async throws {
        firestoreService.shouldSuccess = true
        
        let data =  """
        [
        {
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum"
        },
        {
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival"
        }
        ]
        """.data(using: .utf8)!
        
        firestoreService.data = data
        do {
            let events: [Event] = try await Event.fetchEvents(firestoreService: firestoreService)
            XCTAssert(events.count == 2)
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testFetchEventsNOk() async throws {
        firestoreService.shouldSuccess = false
        do {
            let _: [Event] = try await Event.fetchEvents(firestoreService: firestoreService)
            XCTFail("Should catch an error")
        } catch {
            XCTAssert(error as! EventoriasAlerts == .failedMultiFetch)
        }
    }
    
    @MainActor
    func testFetchEventOk() async throws {
        firestoreService.shouldSuccess = true
        
        let jsonString =  """
        [
        {   "identifier": "xjknsq",
            "description": "De jour comme de nuit.",
            "date": "2025-10-22T14:30:00Z",
            "name": "Musée du Louvres",
            "type": "museum"
        },
        {   "identifier": "xjknsl",
            "description": "Festivale d'électro et de danse.",
            "date": "2025-02-22T14:30:00Z",
            "name": "Tomorrowland",
            "type": "festival"
        }
        ]
        """
        
        let data =  jsonString.data(using: .utf8)!
        

        firestoreService.data = data
        do {
            let event: Event = try await Event.fetchEvent(with: "xjknsq",firestoreService: firestoreService)
            XCTAssert(event.identifier == "xjknsq")
            XCTAssert(event.type == .museum)
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testFetchEventNOk() async throws {
        firestoreService.shouldSuccess = false
        do {
            let _ : Event = try await Event.fetchEvent(with: "xjknsq",firestoreService: firestoreService)
            XCTFail("Should catch an error")
        } catch {
            XCTAssert(error as! EventoriasAlerts == .failedFetch)
        }
    }
}
