//
//  UserViewModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
import FirebaseAuth
@testable import OPC_Chap14_Eventorias


final class UserViewModelTests: XCTestCase {
    var authFirebaseMock: AuthFirebaseMock!
    var firestoreServiceMock: FirestoreServiceMock!



    override func setUpWithError() throws {
        authFirebaseMock = AuthFirebaseMock()
        firestoreServiceMock = FirestoreServiceMock()
    }

    override func tearDownWithError() throws {
        authFirebaseMock.currentUser = nil
        authFirebaseMock.isAuthenticated = false
        authFirebaseMock.shouldSuccess = false
        firestoreServiceMock.shouldSuccess = false
        firestoreServiceMock.data = nil
    }
    
    @MainActor
    func testFetchUserOk() async throws {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = true
        
        let jsonString =  """
        [
        {   "name": "Jean Marocco",
            "email": "test@test.com",
            "notification": true,
            "identifier": "bqknsxkqsmx"
        },
        {   "name": "Pierre Milan",
            "email": "pierre.milan@gmail.com",
            "notification": false,
            "identifier": "csjkoiwjqs"
        }
        ]
        """
        
        let data =  jsonString.data(using: .utf8)!
        
        firestoreServiceMock.data = data
        
        let dummyUser = DummyUser(uid: "bqknsxkqsmx",
                                  displayName: "testerPro",
                                  email: "test@test.com")
        authFirebaseMock.currentUser = dummyUser
        
        let userViewModel = UserViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock)
        await userViewModel.fetchUser()
        XCTAssert(userViewModel.user.name == "Jean Marocco")
    }
    
    @MainActor
    func testFetchNoUserNOk() async throws {
        let userViewModel = UserViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock)
        await userViewModel.fetchUser()
        XCTAssert(userViewModel.alertIsPresented == true)
        XCTAssert(userViewModel.alert == EventoriasAlerts.userDoesNotExist)
    }
    
    @MainActor
    func testFetchNOk() async throws {
        authFirebaseMock.shouldSuccess = true
        firestoreServiceMock.shouldSuccess = false
        
        let dummyUser = DummyUser(uid: "bqknsxkqsmx",
                                  displayName: "testerPro",
                                  email: "test@test.com")
        authFirebaseMock.currentUser = dummyUser
        
        let userViewModel = UserViewModel(firebase: authFirebaseMock, firestore: firestoreServiceMock)
        await userViewModel.fetchUser()
        
        XCTAssert(userViewModel.alertIsPresented == true)
        XCTAssert(userViewModel.alert == EventoriasAlerts.notAbleToFetchUser)
        
        
    }
}
