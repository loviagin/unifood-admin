import Foundation
import SwiftUI

@MainActor
class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var hasLoadedData = false
    
    func fetchMenu() async {
        guard !hasLoadedData else { return }
        
        isLoading = true
        error = nil
        
        do {
            menuItems = try await MenuService.shared.fetchMenu()
            hasLoadedData = true
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 