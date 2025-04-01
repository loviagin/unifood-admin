import Foundation

struct MenuResponse: Codable {
    let menu: [MenuItem]
}

struct MenuItem: Identifiable, Codable {
    let id: String
    let name: String
    let price: Double
    let description: String
    let image: String
    let category: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case price
        case description
        case image
        case category
        case createdAt
    }
}
//
//// Тестовые данные для превью
//extension MenuItem {
//    static let sampleItems = [
//        MenuItem(
//            id: UUID(),
//            name: "Капучино",
//            price: 159,
//            description: "Классический кофейный напиток",
//            image: "https://unifood.space/images/menu/cappuccino.png"
//        ),
//        MenuItem(
//            id: UUID(),
//            name: "Латте",
//            price: 179,
//            description: "Кофе с молоком",
//            imageUrl: "https://unifood.space/images/menu/latte.png"
//        ),
//        MenuItem(
//            id: UUID(),
//            name: "Круассан",
//            price: 129,
//            description: "Свежая выпечка",
//            imageUrl: "https://unifood.space/images/menu/croissant.png"
//        ),
//        MenuItem(
//            id: UUID(),
//            name: "Чизкейк",
//            price: 259,
//            description: "Нью-Йорк",
//            imageUrl: "https://unifood.space/images/menu/cheesecake.png"
//        )
//    ]
//} 
