//
//  DetailView.swift
//  citiesTableView
//
//  Created by Anvita Lingampalli on 3/4/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct DetailView: View {
   
    @State var lat: Double
    @State var lon: Double
    
    @State private static var defaultLocation = CLLocationCoordinate2D(
        latitude: 33.4255,
        longitude: -111.9400
    )

    // state property that represents the current map region
    @State private var region = MKCoordinateRegion(
        center: defaultLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    // state property that stores marker locations in current map region
//    @State private var markers = [
//        Location(name: "Tempe", coordinate: defaultLocation)
//    ]
    @State private var markers: [Location] = []
    @Environment(\.dismiss) private var dismiss
    
    let city: String
    let cityDescription: String
    let image: String
    @ObservedObject  var cModel : cityViewModel
    
    
    var body: some View {
        Text("\(city)")
        Map(coordinateRegion: $region,
            interactionModes: .all,
            annotationItems: markers
        ){ location in
            MapAnnotation(coordinate: location.coordinate){
                Text(location.name)
                Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(x: 0, y: -5)
            }
        }
        let _ = forwardGeocoding(addressStr: city)
        Text("Latitude \(lat)")
        Text("Longitude \(lon)")
        
        Image(image)
        Text("Description of \(city):")
        Text("\(cityDescription)")
            .navigationTitle(city)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        let x = cModel.findCity(city: city)
                        print(x)
                        cModel.removeCity(at: x)
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }

                }
            }
        searchBar
    }
    @State private var searchText = ""
    private var searchBar: some View {
        HStack {
            Button {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = searchText
                searchRequest.region = region
                
                MKLocalSearch(request: searchRequest).start { response, error in
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    region = response.boundingRegion
                    markers = response.mapItems.map { item in
                        Location(
                            
                            name: item.name ?? "",
                            coordinate: item.placemark.coordinate
                        )
                    }
                }
            } label: {
                Image(systemName: "location.magnifyingglass")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
            }
            TextField("Search e.g. Mill Cue Club", text: $searchText)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
        }
        .padding()
    }
    
    func forwardGeocoding(addressStr: String)
    {
        let geoCoder = CLGeocoder();
        let addressString = addressStr
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
                                            {(placemarks, error) in
            
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                lat = coords.latitude
                lon = coords.longitude
                
                DispatchQueue.main.async
                    {
                        region.center = coords
//                        markers[0].name = placemark.locality ?? city
//                        markers[0].coordinate = coords
                    }
            }
        })
        
        
    }
}


//location in MapMarker(coordinate: location.coordinate)
