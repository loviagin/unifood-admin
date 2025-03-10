import Foundation
import SwiftUI

struct OrderItem: Identifiable {
    let id = UUID()
    let menuItem: MenuItem
    var quantity: Int
    
    var subtotal: Int {
        Int(menuItem.price) * quantity
    }
}

class Order: ObservableObject {
    @Published var items: [OrderItem] = []
    @Published var customer: Customer?
    @Published var useBonuses: Bool = false
    
    var total: Int {
        items.reduce(0) { sum, item in
            sum + item.subtotal
        }
    }
    
    var bonusesToUse: Int {
        guard let customer = customer, useBonuses else { return 0 }
        return min(Int(customer.bonuses), Int(Double(total) * 0.5)) // Максимум 50% от суммы заказа
    }
    
    func addItem(_ item: MenuItem) {
        if let index = items.firstIndex(where: { $0.menuItem.id == item.id }) {
            items[index].quantity += 1
        } else {
            items.append(OrderItem(menuItem: item, quantity: 1))
        }
    }
    
    func removeItem(_ item: MenuItem) {
        guard let index = items.firstIndex(where: { $0.menuItem.id == item.id }) else { return }
        
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }
    
    func clear() {
        items = []
        customer = nil
        useBonuses = false
    }
} 
