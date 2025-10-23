//
//  UserModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import XCTest
@testable import OPC_Chap14_Eventorias

final class UserModelTests: XCTestCase {
    var firestoreService: FirestoreServiceMock!

    override func setUpWithError() throws {
        firestoreService = FirestoreServiceMock()
    }

    override func tearDownWithError() throws {
        firestoreService.shouldSuccess = false
        firestoreService.data = nil
    }
    
    @MainActor
    func testPopulateUserOk() async throws {
        firestoreService.shouldSuccess = true
        firestoreService.createOnly = true
        
        let user = UserFirestore(name: "Tester Pro",
                        email: "test@test.com",
                        icon: nil,
                        notification: false)
        
        do {
            try await user.populateUser("test", firestoreService: firestoreService)
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testPopulateUserNOk() async throws {
        firestoreService.shouldSuccess = false
        
        let user = UserFirestore(name: "Tester Pro",
                        email: "test@test.com",
                        icon: nil,
                        notification: false)
        
        do {
            try await user.populateUser("test", firestoreService: firestoreService)
        } catch {
            XCTAssert(error as! EventoriasAlerts == .failedCreate)
        }
    }
    
    @MainActor
    func testUserOk() async throws {
        firestoreService.shouldSuccess = true
        
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
        
        firestoreService.data = data
        do {
            let user: UserFirestore = try await UserFirestore.fetchUser("hsbjhbsxj", firestoreService: firestoreService)
            XCTAssert(user.identifier == "hsbjhbsxj")
            XCTAssert(user.name == "Jean Marocco")
        } catch {
            XCTFail("Should not catch the error")
        }
    }
    
    @MainActor
    func testUserNOk() async throws {
        firestoreService.shouldSuccess = false
        do {
            let _ : UserFirestore = try await UserFirestore.fetchUser("hsbjhbsxj", firestoreService: firestoreService)
            XCTFail("Should catch an error")
        } catch {
            XCTAssert(error as! EventoriasAlerts == .notAbleToFetchUser)
        }
    }

}
