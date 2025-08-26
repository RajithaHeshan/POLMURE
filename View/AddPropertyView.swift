import SwiftUI
import MapKit

struct AddPropertyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var propertyName = "warakapola1"
    @State private var address = ""
    @State private var estimateHarvestUnits = 3200
    @State private var nextHarvestDate = Date()
    @State private var selectedLocation = "Warakapola"
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.1525, longitude: 80.2547),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    FormField(label: "PROPERTY Name") {
                        TextField("Enter property name", text: $propertyName)
                    }
                    
                    FormField(label: "Address") {
                        TextField("Enter property address", text: $address)
                    }
                    
                    FormField(label: "Estimate Harvest") {
                        HStack {
                            TextField("Units", value: $estimateHarvestUnits, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                            Text("units")
                                .foregroundColor(.secondary)
                            Spacer()
                            Stepper("", value: $estimateHarvestUnits, in: 0...10000)
                        }
                    }
                    
                    FormField(label: "Next Harvest") {
                        HStack {
                            DatePicker(
                                "",
                                selection: $nextHarvestDate,
                                displayedComponents: .date
                            )
                            Spacer()
                        }
                    }
                    
                    FormField(label: "Photos (Optional)") {
                        Button(action: {}) {
                            VStack {
                                Image(systemName: "plus")
                                Text("Add Photo")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(width: 120, height: 120)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    
                    FormField(label: "Select your Location") {
                        Map(coordinateRegion: $region, annotationItems: [
                            LocationPin(coordinate: region.center)
                        ]) { pin in
                            MapMarker(coordinate: pin.coordinate, tint: .red)
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                    }
                    
                    FormField(label: "Enter Area Prefer to Collecting From/ Nearest City") {
                        Picker(selectedLocation, selection: $selectedLocation) {
                            Text("Warakapola").tag("Warakapola")
                            Text("Colombo").tag("Colombo")
                            Text("Kandy").tag("Kandy")
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {}) {
                        Text("Confirm")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.top)

                }
                .padding()
            }
            .navigationTitle("Add Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct FormField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        }
    }
}

struct LocationPin: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct AddPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        AddPropertyView()
    }
}
