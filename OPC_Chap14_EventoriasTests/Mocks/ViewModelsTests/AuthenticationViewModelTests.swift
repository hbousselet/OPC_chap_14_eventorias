//
//  AuthenticationViewModelTests.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 19/10/2025.
//

import XCTest
import FirebaseAuth
@testable import OPC_Chap14_Eventorias


final class AuthenticationViewModelTests: XCTestCase {
    var authFirebaseMock: AuthFirebaseMock!
    var firestoreService: FirestoreServiceMock!



    override func setUpWithError() throws {
        authFirebaseMock = AuthFirebaseMock()
        firestoreService = FirestoreServiceMock()
    }

    override func tearDownWithError() throws {
        authFirebaseMock.currentUser = nil
        authFirebaseMock.isAuthenticated = false
        authFirebaseMock.shouldSuccess = false
        firestoreService.shouldSuccess = false
        firestoreService.data = nil
    }
    
    @MainActor
    func testSignInOk() async {
        authFirebaseMock.shouldSuccess = true
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = "test"
        
        await authViewModel.signIn()
        XCTAssertTrue(authFirebaseMock.isAuthenticated)
        XCTAssertTrue((authFirebaseMock.currentUser as! DummyUser).email == "test@test.com")
    }
    
    @MainActor
    func testSignInNokInvalidEmail() async {
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "testtest.com"
        authViewModel.password = "test"
        
        await authViewModel.signIn()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .invalidEmail)
    }
    
    @MainActor
    func testSignInNokPasswordEmpty() async {
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = ""
        
        await authViewModel.signIn()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .emptyPassword)
    }
    
    @MainActor
    func testSignInNok() async {
        authFirebaseMock.shouldSuccess = false
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = "test"
        
        await authViewModel.signIn()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .notAbleToSignIn)
    }
    
    
    @MainActor
    func testSignUpOk() async {
        authFirebaseMock.shouldSuccess = true
        firestoreService.shouldSuccess = true
        firestoreService.createOnly = true

        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = "test"
        authViewModel.name = "Jean Test"
        
        await authViewModel.signUp()
        XCTAssertTrue(authFirebaseMock.isAuthenticated)
        XCTAssertTrue((authFirebaseMock.currentUser as! DummyUser).email == "test@test.com")
    }
    
    @MainActor
    func testSignUpNokInvalidEmail() async {
        let expectation = XCTestExpectation(description: "Sign up nok with invalid email")
        
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "testtest.com"
        authViewModel.password = "test"
        authViewModel.name = "Jean Test"
        
        await authViewModel.signUp()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .invalidEmail)
    }
    
    @MainActor
    func testSignUpNokNameEmpty() async {
        let expectation = XCTestExpectation(description: "Sign up nok with empty name")
        
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = "test"
        authViewModel.name = ""
        
        await authViewModel.signUp()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .emptyName)
    }
    
    @MainActor
    func testSignUpNokPasswordEmpty() async {
        let expectation = XCTestExpectation(description: "Sign up nok with empty password")
        
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = ""
        authViewModel.name = "Jean Test"
        
        await authViewModel.signUp()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .emptyPassword)
    }
    
    @MainActor
    func testSignUpNok() async {
        let expectation = XCTestExpectation(description: "Sign up nok.")
        
        authFirebaseMock.shouldSuccess = false
        let authViewModel = AuthenticationViewModel(firebase: authFirebaseMock)
        authViewModel.email = "test@test.com"
        authViewModel.password = "test"
        authViewModel.name = "Jean Test"
        
        await authViewModel.signUp()
        XCTAssertFalse(authFirebaseMock.isAuthenticated)
        XCTAssert(authViewModel.alertIsPresented == true)
        XCTAssert(authViewModel.alert == .notAbleToSignUp)
    }
}
