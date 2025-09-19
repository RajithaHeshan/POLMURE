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
            
            TransactionsView()
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
    @StateObject private var notificationsViewModel = NotificationsViewModel()

    var body: some View {
        HStack {
            Image("seller")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text("Hi, \(sessionStore.appUser?.fullName.split(separator: " ").first ?? "User") 👋")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing: 20) {
                NavigationLink(destination: NotificationsView()) {
                    ZStack {
                        Image(systemName: "bell.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        if notificationsViewModel.hasUnreadNotifications {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .offset(x: 10, y: -10)
                        }
                    }
                }
                
                Button(action: {
                    try? sessionStore.signOut()
                }) {
                    Image(systemName: "power")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical)
    }
}


struct YourPropertiesSection: View {
    @StateObject private var viewModel = UserPropertiesViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Properties")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink(destination: PropertyListView()) {
                    HStack(spacing: 4) {
                        Text("All")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                }
            }
            
            if viewModel.properties.isEmpty {
                // Show a message if the seller has no properties
                Text("You haven't added any properties yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(16)
            } else {
                // Show a swipeable list of the seller's properties
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.properties) { property in
                            PropertyCardView(property: property)
                        }
                    }
                }
            }
        }
    }
}


struct PropertyCardView: View {
    let property: Property
    
    var body: some View {
        HStack(spacing: 16) {
            // Using the "seller" image from your assets, as requested
            Image("seller")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 150)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 8) {
                // All the text is now dynamic, coming from the property object
                Text(property.sellerName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                PropertyDetailRow(key: "Property Name:", value: property.propertyName)
                PropertyDetailRow(key: "City:", value: property.cityName)
                PropertyDetailRow(key: "Estimate Harvest:", value: "\(property.estimateHarvestUnits) units")
                PropertyDetailRow(key: "Next Harvest:", value: "\(property.daysUntilNextHarvest) days")
                PropertyDetailRow(key: "Status:", value: "Available", valueColor: .green)
            }
            .font(.footnote)
            
            Spacer()
        }
        .frame(width: 320)
        .padding()
        .background(Color.white)
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
            NavigationLink(destination: BuyersListView()) {
                QuickActionCard(title: "Buyers", imageName: "Buyer", isSymbol: false)
            }
            
            NavigationLink(destination: SellersListView()) {
                QuickActionCard(title: "Sellers", imageName: "seller", isSymbol: false)
            }

            NavigationLink(destination: SellerBidsDetailsView()) {
                QuickActionCard(title: "BIDS", imageName: "Bids", isSymbol: false)
            }
            
            NavigationLink(destination: MyOffersDetailsView()) {
                QuickActionCard(title: "Offers", imageName: "offers", isSymbol: false)
            }
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
                        .font(.system(size: 40)) //
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit() // Changed to scaledToFit to avoid stretching
                        .padding(20) // Added padding to give the image some space
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
