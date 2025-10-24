//
//  EventCreationViewModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
import FirebaseAuth
import UIKit
@testable import OPC_Chap14_Eventorias


final class EventCreationViewModelTests: XCTestCase {
    var authFirebaseMock: AuthFirebaseMock!
    var firestoreServiceMock: FirestoreServiceMock!
    var storageServiceMock: StorageFirebaseMock!


    override func setUpWithError() throws {
        authFirebaseMock = AuthFirebaseMock()
        firestoreServiceMock = FirestoreServiceMock()
        storageServiceMock = StorageFirebaseMock()
    }

    override func tearDownWithError() throws {
        authFirebaseMock.currentUser = nil
        authFirebaseMock.isAuthenticated = false
        authFirebaseMock.shouldSuccess = false
        firestoreServiceMock.shouldSuccess = false
        firestoreServiceMock.data = nil
        storageServiceMock.shouldSuccess = false
        storageServiceMock.data = nil
    }
    
    @MainActor
    func testCreateEventOk() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.dismiss == true)
    }
    
    @MainActor
    func testTurnAddressToLocationNOk() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = false
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "2GS231 WARABIA, 17263 Mars"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .failedCreate)
    }
    
    @MainActor
    func testUploadEventNOk() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = false
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .failedCreate)
    }
    
    @MainActor
    func testExportImageNOk() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = false
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.type = .bar
        
        let image: UIImage = UIImage(systemName: "camera")!
        let compressionQuality: CGFloat = 0.1
        eventCreationViewModel.selectedImage = image.jpegData(compressionQuality: compressionQuality)!
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .notAbleToExportImage)
    }
    
    @MainActor
    func testCreateEventNOkNoTitle() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = ""
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .emptyTitle)
    }
    
    @MainActor
    func testCreateEventNOkEmptyAddress() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = ""
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .emptyAddress)
    }
    
    @MainActor
    func testCreateEventNOkNoDescription() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = ""
        eventCreationViewModel.date = "12/12/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .emptyDescription)
    }
    
    @MainActor
    func testCreateEventNOkDateEmpty() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = ""
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .emptyDate)
    }
    
    @MainActor
    func testCreateEventNOkInvalidDate() async {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        storageServiceMock.shouldSuccess = true
        
        let eventCreationViewModel = EventCreationViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock, storage: storageServiceMock)
        
        eventCreationViewModel.title = "Test"
        eventCreationViewModel.description = "We love the tests. It shouldn't be a good day without tests writing."
        eventCreationViewModel.date = "12/32/2025"
        eventCreationViewModel.time = "11:11"
        eventCreationViewModel.address = "103 rue de Grenelle, Paris 75007, FRANCE"
        eventCreationViewModel.selectedImage = "bhsqjdchbsdjh".data(using: .utf8)!
        eventCreationViewModel.type = .bar
                
        await eventCreationViewModel.createEvent()
        XCTAssert(eventCreationViewModel.alertIsPresented == true)
        XCTAssert(eventCreationViewModel.alert == .invalidDate)
    }
}
