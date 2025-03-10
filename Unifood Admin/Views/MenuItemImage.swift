import SwiftUI

struct MenuItemImage: View {
    let url: String?
    
    var body: some View {
        if let urlString = url, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .font(.system(size: 30))
                .foregroundColor(.gray)
                .frame(width: 60, height: 60)
        }
    }
} 