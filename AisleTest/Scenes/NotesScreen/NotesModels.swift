//
//  NotesModels.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

struct NotesAPIModel: Codable {
    let invites: Invites?
    let likes: Likes?
    
    struct Invites: Codable {
        let totalPages: Int?
        let pendingInvitationsCount: Int?
        let profiles: [Profiles]?
        
        struct Profiles: Codable {
            let photos: [Photos]?
            let generalInformation: GeneralInformation?
            
            struct Photos: Codable {
                let photo: String?
                let selected: Bool?
                let status: String?
            }
            
            struct GeneralInformation: Codable {
                let firstName: String?
                let gender: String?
                let age: Int?
                
                enum CodingKeys: String, CodingKey {
                    case firstName = "first_name"
                    case gender
                    case age
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case photos
                case generalInformation = "general_information"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case pendingInvitationsCount = "pending_invitations_count"
            case totalPages
            case profiles
        }
    }
    
    struct Likes: Codable {
        let canSeeProfile: Bool?
        let likedRecievedCount: Int?
        let profiles: [Profiles]?
        
        struct Profiles: Codable {
            let firstName: String?
            let avatar: String?
            
            enum CodingKeys: String, CodingKey {
                case firstName = "first_name"
                case avatar
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case profiles
            case canSeeProfile = "can_see_profile"
            case likedRecievedCount = "likes_received_count"
        }
    }
}

struct NotesViewModel {
    enum DisplayWidgetType: CaseIterable {
        case mainNotes
        case intrestedInYou
    }
    
    var headerData: NotesHeaderData?
    var widgetType: DisplayWidgetType
    var cellData: [CellDataType]
}

protocol NotesHeaderData {}
protocol CellDataType {}
