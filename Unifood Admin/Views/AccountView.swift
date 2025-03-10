import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading) {
                            Text("Администратор")
                                .font(.headline)
                            Text("UniFoodAdmin")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Настройки") {
                    NavigationLink {
                        Text("История заказов")
                    } label: {
                        Label("История заказов", systemImage: "clock")
                    }
                    
                    NavigationLink {
                        Text("Настройки приложения")
                    } label: {
                        Label("Настройки", systemImage: "gear")
                    }
                }
                
                Section {
                    Button {
                        // Здесь будет логика выхода
                    } label: {
                        Label("Выйти", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Аккаунт")
        }
    }
} 