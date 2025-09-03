import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    private let text: String
    
    init(text: String) {
        self.text = text
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
            
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(text)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
                }
                TextField("", text: $searchText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
                    .disabled(true)
            }

            Image(systemName: "mic.fill")
                .foregroundColor(Color(red: 140/255, green: 140/255, blue: 140/255))
                .padding(.trailing, 3)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 7)
        .background(Color(red: 28/255, green: 28/255, blue: 28/255))
        .cornerRadius(10)
    }
}
