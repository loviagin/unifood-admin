import SwiftUI

struct OrderSheet: View {
    @ObservedObject var order: Order
    let customer: Customer
    let menuItems: [MenuItem]
    @Binding var isPresented: Bool
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Клиент") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(customer.name)
                            .font(.headline)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(customer.level)
                        }
                        .foregroundColor(.secondary)
                        HStack {
                            Image(systemName: "creditcard.fill")
                            Text("\(Int(customer.bonuses)) бонусов")
                        }
                        .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Меню") {
                    ForEach(menuItems) { item in
                        MenuItemOrderRow(item: item, order: order)
                    }
                }
                
                if !order.items.isEmpty {
                    Section {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Итого")
                                    .font(.headline)
                                Spacer()
                                Text("\(Int(order.total)) ₽")
                                    .font(.headline)
                            }
                            
                            Toggle("Списать бонусы", isOn: $order.useBonuses)
                                .tint(.accentColor)
                            
                            if order.useBonuses {
                                HStack {
                                    Text("Будет списано:")
                                    Spacer()
                                    Text("\(order.bonusesToUse) бонусов")
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("К оплате")
                                        .font(.headline)
                                    Spacer()
                                    Text("\(Int(order.total) - order.bonusesToUse) ₽")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Button {
                                submitOrder()
                            } label: {
                                HStack {
                                    if isSubmitting {
                                        ProgressView()
                                            .tint(.white)
                                            .padding(.trailing, 8)
                                    }
                                    Text(isSubmitting ? "Оформляем..." : "Оформить заказ")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(isSubmitting)
                            .padding(.top, 8)
                        }
                    }
                }
            }
            .navigationTitle("Новый заказ")
            .navigationBarItems(trailing: Button("Отмена") {
                isPresented = false
            })
            .alert("Ошибка", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func submitOrder() {
        guard !isSubmitting else { return }
        guard let orderRequest = OrderRequest.createOrder(from: order) else {
            showError(message: "Ошибка при создании заказа")
            return
        }
        
        isSubmitting = true
        
        guard let url = URL(string: "https://unifood.space/api/orders/new") else {
            showError(message: "Некорректный URL")
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let jsonData = try? encoder.encode(orderRequest) else {
            showError(message: "Ошибка при кодировании данных")
            isSubmitting = false
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                
                if let error = error {
                    showError(message: error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    showError(message: "Некорректный ответ сервера")
                    return
                }
                
                if httpResponse.statusCode == 201, let data = data {
                    do {
                        // Преобразуем данные в строку
                        guard var jsonString = String(data: data, encoding: .utf8) else {
                            print("Ошибка: не удалось преобразовать данные в строку")
                            showError(message: "Ошибка при обработке ответа сервера")
                            return
                        }
                        
                        print("Исходный JSON:", jsonString)
                        
                        // Используем регулярное выражение для поиска чисел с плавающей точкой
                        let pattern = "([0-9]+\\.[0-9]+)"
                        if let regex = try? NSRegularExpression(pattern: pattern) {
                            let range = NSRange(jsonString.startIndex..., in: jsonString)
                            // Заменяем числа на строки
                            jsonString = regex.stringByReplacingMatches(
                                in: jsonString,
                                range: range,
                                withTemplate: "\"$1\""
                            )
                        }
                        
                        print("Обработанный JSON:", jsonString)
                        
                        // Преобразуем обратно в Data
                        guard let processedData = jsonString.data(using: .utf8) else {
                            print("Ошибка: не удалось преобразовать строку обратно в данные")
                            showError(message: "Ошибка при обработке ответа сервера")
                            return
                        }
                        
                        let response = try JSONDecoder().decode(OrderResponse.self, from: processedData)
                        print("Заказ создан: \(response)")
                        print("Новые бонусы (строка): \(response.newBonusesString)")
                        print("Новые бонусы (число): \(response.newBonuses)")
                        print("Новый прогресс (строка): \(response.newProgressString)")
                        print("Новый прогресс (число): \(response.newProgress)")
                        order.clear()
                        isPresented = false
                    } catch {
                        print("Ошибка декодирования:", error)
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Проблемный JSON:", jsonString)
                        }
                        showError(message: "Ошибка при обработке ответа сервера")
                    }
                } else {
                    showError(message: "Ошибка сервера: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

struct MenuItemOrderRow: View {
    let item: MenuItem
    @ObservedObject var order: Order
    
    private var quantity: Int {
        order.items.first(where: { $0.menuItem.id == item.id })?.quantity ?? 0
    }
    
    var body: some View {
        HStack(spacing: 12) {
            MenuItemImage()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(Int(item.price)) ₽")
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            if quantity > 0 {
                HStack(spacing: 16) {
                    Button(action: {
                        order.removeItem(item)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text("\(quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        order.addItem(item)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            } else {
                Button(action: {
                    order.addItem(item)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}
