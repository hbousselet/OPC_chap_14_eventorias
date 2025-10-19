//
//  EventoriasAlerts.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 17/10/2025.
//

import Foundation

enum EventoriasAlerts: Error {
    case notAbleToFetchEvents(error: Error)
    case notAbleToDownloadImage(error: Error)
    case notAbleToFetchUser(error: Error)
    case userDoesNotExist
    case notAbleToLoadUserImage(error: Error)
    case notAbleToSignIn(error: Error)
    case notAbleToPopulateUserInDb(error: Error)
    case emptyPassword
    case emptyName
    case invalidEmail
    case notAbleToSignUp
    case invalidDate
    case emptyDate
    case emptyTitle
    case emptyDescription
    case emptyAddress
    case invalidAddress
    case failedEventCreation
    case notAbleToExportImage(error: Error)
    case none
    
    var errorDescription: String? {
        switch self {
        case .none:
            return "No error"
        case .notAbleToFetchEvents(error: let error):
            return "Not able to fetch events : \(error.localizedDescription)"
        case .notAbleToDownloadImage(error: let error):
            return "Not able to download image : \(error.localizedDescription)"
        case .notAbleToFetchUser(error: let error):
            return "Not able to fetch user : \(error.localizedDescription)"
        case .notAbleToLoadUserImage(error: let error):
            return "Not able to load user's image : \(error.localizedDescription)"
        case .userDoesNotExist:
            return "User does not exist"
        case .notAbleToSignIn(error: let error):
            return "Not able to sign in : \(error.localizedDescription)"
        case .notAbleToPopulateUserInDb(error: let error):
            return "Not able to populate the user from authentication to db : \(error.localizedDescription)"
        case .emptyPassword:
            return "Password is empty. Retry with a valid password."
        case .invalidEmail:
            return "Email is invalid. Retry with a valid email."
        case .notAbleToSignUp:
            return "Not able to sign up. Please retry."
        case .emptyName:
            return "The name entered is empty. Please enter a valid name."
        case .invalidDate:
            return "You entered an invalid date. Please try again."
        case .emptyDate:
            return "No date was entered. Please enter a date."
        case .emptyTitle:
            return "Please enter a title."
        case .emptyDescription:
            return "Please enter a description."
        case .emptyAddress:
            return "Please enter an address."
        case .invalidAddress:
            return "The address you entered was not found. Please try again."
        case .failedEventCreation:
            return "Not able to create the event. Please retry in a few moments."
        case .notAbleToExportImage(error: let error):
            return "Not able to export image : \(error.localizedDescription)."
        }
    }
}
