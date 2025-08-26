import SwiftUI

struct SellerHomePageView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Requirement Screen")
                .tabItem {
                    Label("Requirement", systemImage: "list.bullet")
                }
            
            Text("Transactions Screen")
                .tabItem {
                    Label("Transactions", systemImage: "dollarsign.circle")
                }
            
            Text("Account Screen")
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
        }
        .accentColor(.blue)
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    YourPropertiesSection()
                    QuickActionGridView()
                    CustomSegmentedPicker()
                    InformationCardsSection()
                }
                .padding(.horizontal, 16)
                .padding(.top)
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        HStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "leaf.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            
            Text("Hi, Heshan 👋")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                do {
                    try sessionStore.signOut()
                } catch {
                    print("Error signing out: \(error)")
                }
            }) {
                Image(systemName: "power")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical)
    }
}

struct YourPropertiesSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Properties")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("All")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                }
            }
            PropertyCardView()
        }
    }
}

struct PropertyCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 150)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 8) {
                Text("Heshan Dunumala")
                    .font(.headline)
                    .fontWeight(.bold)
                
                PropertyDetailRow(key: "Property Name:", value: "Warakapola 1")
                PropertyDetailRow(key: "City:", value: "Warakapola")
                PropertyDetailRow(key: "Estimate Harvest:", value: "2500 kg")
                PropertyDetailRow(key: "Next Harvest:", value: "2025/10/15")
                PropertyDetailRow(key: "Highest Bid:", value: "LKR 550.00")
                PropertyDetailRow(key: "Status:", value: "Available", valueColor: .green)
            }
            .font(.footnote)
            
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct PropertyDetailRow: View {
    let key: String
    let value: String
    var valueColor: Color = .black

    var body: some View {
        HStack {
            Text(key)
                .foregroundColor(.secondary)
            Text(value)
                .foregroundColor(valueColor)
                .fontWeight(.medium)
            Spacer()
        }
    }
}

struct QuickActionGridView: View {
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            QuickActionCard(title: "Buyers", imageName: "person.2.fill", isSymbol: true)
            QuickActionCard(title: "Sellers", imageName: "person.badge.plus", isSymbol: true)
            QuickActionCard(title: "BIDS", imageName: "gavel.fill", isSymbol: true)
            QuickActionCard(title: "Offers", imageName: "tag.fill", isSymbol: true)
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let imageName: String
    let isSymbol: Bool

    var body: some View {
        VStack {
            if isSymbol {
                Image(systemName: imageName)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Text(title)
                .font(.headline)
                .padding(.bottom, 12)
        }
        .frame(height: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct CustomSegmentedPicker: View {
    @State private var selectedIndex = 0
    let options = ["About Us", "Events"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedIndex = index
                    }
                }) {
                    Text(options[index])
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selectedIndex == index {
                                    Capsule()
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
                                }
                            }
                        )
                        .foregroundColor(selectedIndex == index ? .blue : .secondary)
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray5))
        .clipShape(Capsule())
    }
}

struct InformationCardsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            InformationCard(
                title: "Automated Bid Notification",
                iconName: "bell.badge.fill",
                description: "Get instant notifications on your mobile device when a new bid is placed on your property."
            )
            InformationCard(
                title: "Direct Buyer Communication",
                iconName: "text.bubble.fill",
                description: "Communicate directly with potential buyers through our secure messaging platform to negotiate offers."
            )
        }
    }
}

struct InformationCard: View {
    let title: String
    let iconName: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: iconName)
                    .foregroundColor(.blue)
            }
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(16)
    }
}

struct SellerHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        SellerHomePageView()
            .environmentObject(SessionStore())
    }
}

