import Foundation

enum UserType: String, Codable, CaseIterable {
    case buyer = "Buyer"
    case seller = "Seller"
}

struct AppUser: Codable, Identifiable {
    let id: String
    let fullName: String
    let email: String
    let userType: UserType
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case fullName
        case email
        case userType
    }
}

