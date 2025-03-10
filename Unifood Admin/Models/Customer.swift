import Foundation

struct Customer: Codable {
    let id: String
    let name: String
    let bonuses: Double
    let level: String
}

struct CustomerResponse: Codable {
    let bonuses: Double
    let level: String
    let nextLevel: Double
    let progress: Double
} 
