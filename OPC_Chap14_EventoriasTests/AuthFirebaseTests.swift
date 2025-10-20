//
//  AuthFirebaseTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 19/10/2025.
//

import XCTest
@testable import OPC_Chap14_Eventorias


final class AuthFirebaseTests: XCTestCase {
    var authFirebaseMock: AuthFirebaseMock!

    override func setUpWithError() throws {
        authFirebaseMock = AuthFirebaseMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    @MainActor
    func testSignInOk() async {
        authFirebaseMock.shouldSuccess = true
        
        do {
            try await authFirebaseMock.signIn(email: "test@test.com", password: "test")
            XCTAssertTrue(authFirebaseMock.isAuthenticated)
        } catch {
            XCTFail("Should not throw an error")
        }
    }
    
    @MainActor
    func testSignInNOk() async {
        authFirebaseMock.shouldSuccess = false
        do {
            try await authFirebaseMock.signIn(email: "test@test.com", password: "test")
        } catch {
            XCTAssertEqual(error as? EventoriasAlerts, .notAbleToSignIn)
        }
    }
    
    @MainActor
    func testCreateUserOk() async {
        authFirebaseMock.shouldSuccess = true
        
        do {
            try await authFirebaseMock.createUser(email: "test@test.com", password: "test")
            XCTAssertTrue(authFirebaseMock.isAuthenticated)
        } catch {
            XCTFail("Should not throw an error")
        }
    }
    
    @MainActor
    func testCreateUserNOk() async {
        authFirebaseMock.shouldSuccess = false
        do {
            try await authFirebaseMock.createUser(email: "test@test.com", password: "test")
        } catch {
            XCTAssertEqual(error as? EventoriasAlerts, .notAbleToSignUp)
        }
    }

}
