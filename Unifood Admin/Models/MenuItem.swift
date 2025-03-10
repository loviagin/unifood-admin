import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let imageUrl: String?
}

// Тестовые данные
extension MenuItem {
    static let sampleItems = [
        MenuItem(
            name: "Капучино",
            price: 159,
            description: "Классический кофейный напиток",
            imageUrl: "https://unifood.space/images/menu/cappuccino.png"
        ),
        MenuItem(
            name: "Латте",
            price: 179,
            description: "Кофе с молоком",
            imageUrl: "https://unifood.space/images/menu/latte.png"
        ),
        MenuItem(
            name: "Круассан",
            price: 129,
            description: "Свежая выпечка",
            imageUrl: "https://unifood.space/images/menu/croissant.png"
        ),
        MenuItem(
            name: "Чизкейк",
            price: 259,
            description: "Нью-Йорк",
            imageUrl: "https://unifood.space/images/menu/cheesecake.png"
        )
    ]
} 
