import Foundation

class MenuService {
    static let shared = MenuService()
    private let baseURL = "https://unifood.space/api"
    
    private init() {}
    
    func fetchMenu() async throws -> [MenuItem] {
        guard let url = URL(string: "\(baseURL)/menu") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Статус ответа: \(httpResponse.statusCode)")
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Полученные данные: \(jsonString)")
        }
        
        if httpResponse.statusCode != 200 {
            throw URLError(.badServerResponse)
        }
        
        do {
            print("Начинаем декодирование MenuResponse...")
            let decoder = JSONDecoder()
            let menuResponse = try decoder.decode(MenuResponse.self, from: data)
            print("MenuResponse успешно декодирован")
            print("Количество элементов в меню: \(menuResponse.menu.count)")
            return menuResponse.menu
        } catch {
            print("Ошибка декодирования: \(error)")
            throw error
        }
    }
} 
