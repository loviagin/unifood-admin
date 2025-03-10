import Foundation

struct OrderResponse: Codable {
    let message: String
    let orderId: String
    let newBonusesString: String
    let newLevel: String
    let newProgressString: String
    
    var newBonuses: Double {
        return Double(newBonusesString) ?? 0
    }
    
    var newProgress: Double {
        return Double(newProgressString) ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case message
        case orderId
        case newBonusesString = "newBonuses"
        case newLevel
        case newProgressString = "newProgress"
    }
} 