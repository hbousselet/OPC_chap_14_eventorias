//
//  UserModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
@testable import OPC_Chap14_Eventorias

final class UserModelTests: XCTestCase {
    var firestoreServiceMock: FirestoreServiceMock!

    override func setUpWithError() throws {
        firestoreServiceMock = FirestoreServiceMock()
    }

    override func tearDownWithError() throws {
        firestoreServiceMock.shouldSuccess = false
        firestoreServiceMock.data = nil
    }
    
    @MainActor
    func testPopulateUserOk() async throws {
        firestoreServiceMock.shouldSuccess = true
        firestoreServiceMock.createOnly = true
        
        let user = UserFirestore(name: "Tester Pro",
                        email: "test@test.com",
                        icon: nil,
                        notification: false)
        
        do {
            try await user.populateUser("test", firestoreService: firestoreServiceMock)
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testPopulateUserNOk() async throws {
        firestoreServiceMock.shouldSuccess = false
        
        let user = UserFirestore(name: "Tester Pro",
                        email: "test@test.com",
                        icon: nil,
                        notification: false)
        
        do {
            try await user.populateUser("test", firestoreService: firestoreServiceMock)
        } catch {
            XCTAssert(error as! EventoriasAlerts == .failedCreate)
        }
    }
    
    @MainActor
    func testUserOk() async throws {
        firestoreServiceMock.shouldSuccess = true
        
        let jsonString =  """
        [
        {   "name": "Jean Marocco",
            "email": "jean.marocco@gmail.com",
            "notification": true,
            "identifier": "hsbjhbsxj"
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
        do {
            let user: UserFirestore = try await UserFirestore.fetchUser("hsbjhbsxj", firestoreService: firestoreServiceMock)
            XCTAssert(user.identifier == "hsbjhbsxj")
            XCTAssert(user.name == "Jean Marocco")
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testUserNOk() async throws {
        firestoreServiceMock.shouldSuccess = false
        do {
            let _ : UserFirestore = try await UserFirestore.fetchUser("hsbjhbsxj", firestoreService: firestoreServiceMock)
            XCTFail("Should catch an error")
        } catch {
            XCTAssert(error as! EventoriasAlerts == .notAbleToFetchUser)
        }
    }

}
