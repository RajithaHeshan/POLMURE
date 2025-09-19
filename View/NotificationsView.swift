import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.notifications.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No Notifications Yet")
                        .font(.title2)
                }
            } else {
                List(viewModel.notifications) { notification in
                    NotificationRowView(notification: notification)
                        .onTapGesture {
                            viewModel.markAsRead(notification: notification)
                        }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
}

struct NotificationRowView: View {
    let notification: AppNotification
    
    private var iconName: String {
        switch notification.type {
        case .newBid:
            return "gavel.fill"
        case .newOffer:
            return "tag.fill"
        case .offerAccepted:
            return "checkmark.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch notification.type {
        case .newBid:
            return .blue
        case .newOffer:
            return .purple
        case .offerAccepted:
            return .green
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .fontWeight(.bold)
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(notification.createdAt.dateValue().formatted())
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
          
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 8)
    }
}

