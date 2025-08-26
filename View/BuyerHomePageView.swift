import SwiftUI

struct BuyerHomePageView: View {
    var body: some View {
        TabView {
            BuyerHomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
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

struct BuyerHomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    BuyerHeaderView()
                    RecentViewsSection()
                    MainActionsGridView()
                    BuyerCustomSegmentedPicker()
                    BuyerInformationCardsSection()
                }
                .padding(.horizontal, 16)
                .padding(.top)
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
        }
    }
}

struct BuyerHeaderView: View {
    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 36))
                .foregroundColor(.gray)
            
            Text("Hi, Ishan 👋")
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

struct RecentViewsSection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Recent Views")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button("See All") {}
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    RecentSellerCard(
                        imageName: "https://placehold.co/100x100/d9c4b3/a1887f?text=Coconuts",
                        sellerName: "Heshan Dunumala",
                        city: "Warakapola",
                        phone: "071107161"
                    )
                    RecentSellerCard(
                        imageName: "https://placehold.co/100x100/d9c4b3/a1887f?text=Coconuts",
                        sellerName: "Heshan Dunumala",
                        city: "Warakapola",
                        phone: "071107161"
                    )
                }
                .padding(.bottom, 5)
            }
        }
    }
}

struct RecentSellerCard: View {
    let imageName: String
    let sellerName: String
    let city: String
    let phone: String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: imageName)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(sellerName)
                    .font(.footnote)
                    .fontWeight(.bold)
                Text("City: \(city)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Phone No: \(phone)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}

struct MainActionsGridView: View {
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ActionCard(
                title: "Buyers",
                imageURL: "https://placehold.co/400x300/a1e0b8/3d8c5b?text=Buyers"
            )
            ActionCard(
                title: "sellers",
                imageURL: "https://placehold.co/400x300/f0e4c8/c4a777?text=Sellers"
            )
            ActionCard(title: "BIDS", customIcon: .bid)
            ActionCard(title: "Offers", customIcon: .offers)
        }
    }
}

struct ActionCard: View {
    enum CustomIcon { case bid, offers }
    
    let title: String
    var imageURL: String? = nil
    var customIcon: CustomIcon? = nil

    var body: some View {
        VStack {
            if let url = imageURL {
                AsyncImage(url: URL(string: url)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
            } else if let icon = customIcon {
                ZStack {
                    switch icon {
                    case .bid:
                        Image(systemName: "gavel.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        Text("BID")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .background(Color.red)
                            .offset(y: 2)
                    case .offers:
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .offset(x: 15, y: -15)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Text(title.capitalized)
                .font(.headline)
                .padding(.bottom, 12)
        }
        .frame(height: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .clipped()
    }
}

struct BuyerCustomSegmentedPicker: View {
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

struct BuyerInformationCardsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            BuyerInformationCard(
                title: "Automated Bid Notification",
                iconName: "bell.badge.fill",
                description: "You will be automatically notified via SMS for every bid you receive instantly. Your advertisement will be posted by polmure.lk."
            )
            BuyerInformationCard(
                title: "Bid Tracking",
                iconName: "text.bubble.fill",
                description: "You will be automatically notified via SMS for every bid you receive instantly. Your advertisement will be posted by polmure.lk."
            )
        }
    }
}

struct BuyerInformationCard: View {
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

struct BuyerHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerHomePageView()
            .environmentObject(SessionStore())
    }
}

