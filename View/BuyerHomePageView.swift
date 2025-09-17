import SwiftUI

struct BuyerHomePageView: View {
    var body: some View {
        TabView {
            BuyerHomeContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Transactions Screen")
                .tabItem {
                    Label("Transactions", systemImage: "dollarsign.circle.fill")
                }
            
            Text("Account Screen")
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
        }
    }
}

struct BuyerHomeContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    BuyerHeaderView()
                    
                    RecentViewsSection()
                    
                    BuyerActionsGridView()
                    
                    BuyerCustomSegmentedPicker()
                    
                    BuyerInformationSection()
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
        }
    }
}

struct BuyerHeaderView: View {
    @EnvironmentObject var sessionStore: SessionStore

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                Text("Hi, Ishan 👋")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                try? sessionStore.signOut()
            }) {
                Image(systemName: "power.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
    }
}

struct RecentViewsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recent Views")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button("See All") {}
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { _ in
                        RecentViewCard()
                    }
                }
            }
        }
    }
}

struct RecentViewCard: View {
    var body: some View {
        HStack {
            Image("seller") // Placeholder
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text("Heshan Dunumala")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("City: Warakapola")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Phone No: 071107161")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}


struct BuyerActionsGridView: View {
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            NavigationLink(destination: BuyersListView()) {
                 BuyerQuickActionCard(title: "Buyers", imageName: "person.2.fill")
            }
            
            NavigationLink(destination: SellersListView()) {
                BuyerQuickActionCard(title: "sellers", imageName: "person.badge.plus")
            }

             //This is the key change: The "BIDS" card now navigates to the details view
            NavigationLink(destination: MyBidsDetailsView()) {
                BuyerQuickActionCard(title: "BIDS", imageName: "gavel.fill")
            }
            
            BuyerQuickActionCard(title: "Offers", imageName: "tag.fill")
        }
    }
}

struct BuyerQuickActionCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 12)
        }
        .frame(height: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}


struct BuyerCustomSegmentedPicker: View {
    @State private var selectedIndex = 0
    let options = ["About Us", "Events"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedIndex = index
                    }
                }) {
                    Text(options[index])
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(selectedIndex == index ? Color.blue : Color.clear)
                        .foregroundColor(selectedIndex == index ? .white : .blue)
                }
            }
        }
        .background(Color(.systemGray5))
        .clipShape(Capsule())
    }
}

struct BuyerInformationSection: View {
    var body: some View {
        VStack(spacing: 16) {
            BuyerInformationCard(
                title: "Automated Bid Notification",
                iconName: "bell.badge.fill",
                description: "Get instant notifications on your mobile device when a new bid is placed on your property."
            )
            BuyerInformationCard(
                title: "Bid Tracking",
                iconName: "arrow.up.right.circle.fill",
                description: "Easily track the status of your bids and get updates on counter-offers from sellers."
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

 //MARK: - Preview
struct BuyerHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerHomePageView()
            .environmentObject(SessionStore())
    }
}



