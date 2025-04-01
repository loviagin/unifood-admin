import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        List(viewModel.menuItems) { item in
            VStack(alignment: .leading) {
                Text(item.name)
                Text("\(item.price) ₽")
            }
        }
        .navigationTitle("Меню")
        .task {
            await viewModel.fetchMenu()
        }
    }
}

#Preview {
    MenuView()
} 
