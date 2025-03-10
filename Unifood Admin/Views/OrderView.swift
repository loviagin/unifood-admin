import SwiftUI
import CodeScanner

struct OrderView: View {
    @ObservedObject var order: Order
    @State private var isShowingScanner = false
    @State private var isShowingOrderSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(MenuItem.sampleItems) { item in
                    HStack(spacing: 12) {
                        MenuItemImage(url: item.imageUrl)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(Int(item.price)) ₽")
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Меню")
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr]) { response in
                    switch response {
                    case .success(let result):
                        fetchCustomerData(userId: result.string)
                        isShowingScanner = false
                        isShowingOrderSheet = true
                    case .failure(let error):
                        print("Ошибка сканирования: \(error.localizedDescription)")
                        isShowingScanner = false
                    }
                }
            }
            .sheet(isPresented: $isShowingOrderSheet) {
                if let customer = order.customer {
                    OrderSheet(order: order, customer: customer, isPresented: $isShowingOrderSheet)
                }
            }
        }
    }
    
    private func fetchCustomerData(userId: String) {
        guard let url = URL(string: "https://unifood.space/api/users/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(CustomerResponse.self, from: data)
                    DispatchQueue.main.async {
                        order.customer = Customer(id: userId,
                                                  name: "Клиент #\(userId.prefix(4))",
                                                  bonuses: response.bonuses,
                                                  level: response.level)
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                }
            }
        }.resume()
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    @ObservedObject var order: Order
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text("\(Int(item.price)) ₽")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack {
                Button {
                    order.removeItem(item)
                } label: {
                    Image(systemName: "minus.circle")
                }
                
                if let orderItem = order.items.first(where: { $0.menuItem.id == item.id }) {
                    Text("\(orderItem.quantity)")
                        .frame(minWidth: 30)
                }
                
                Button {
                    order.addItem(item)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .padding(.vertical, 8)
    }
}
