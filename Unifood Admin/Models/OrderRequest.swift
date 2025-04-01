import Foundation

struct OrderRequest: Codable {
    let userId: String
    let title: String
    let details: String
    let amount: Int
    let bonuses: Int
    let type: String
    let date: Date
    
    static func createOrder(from order: Order) -> OrderRequest? {
        guard let customer = order.customer else { return nil }
        
        let details = order.items
            .map { "\($0.menuItem.name) × \($0.quantity)" }
            .joined(separator: ", ")
        
        // Рассчитываем бонусы (5% от суммы заказа)
        let earnedBonuses = Int(Double(order.total) * 0.05)
        
        return OrderRequest(
            userId: customer.id,
            title: "Заказ",
            details: details,
            amount: order.total,
            bonuses: order.useBonuses ? -order.bonusesToUse : earnedBonuses,
            type: order.useBonuses ? "spend" : "earn",
            date: Date()
        )
    }
} 
