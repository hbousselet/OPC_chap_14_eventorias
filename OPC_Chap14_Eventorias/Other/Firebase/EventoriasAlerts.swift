//
//  EventoriasAlerts.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 17/10/2025.
//

import Foundation

enum EventoriasAlerts: Error, Equatable {
    case notAbleToFetchUser
    case userDoesNotExist
    case notAbleToSignIn
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
    case failedCreate
    case failedMultiFetch
    case failedFetch
    case failedEventCreation
    case notAbleToExportImage
    case imageUrlNotFound
    case none
    
    var errorDescription: String? {
        switch self {
        case .none:
            return "No error"
        case .notAbleToFetchUser:
            return "Not able to fetch user."
        case .userDoesNotExist:
            return "User does not exist"
        case .notAbleToSignIn:
            return "Not able to sign in. Please retry."
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
        case .notAbleToExportImage:
            return "Not able to export image."
        case .imageUrlNotFound:
            return "Image url not found."
        case .failedCreate:
            return "Failed to create the object and to store it in database."
        case .failedMultiFetch:
            return "Failed to fetch multiple objects."
        case .failedFetch:
            return "Failed to fetch the object."
        }
    }
}
