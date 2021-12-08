//
//  akiofile.swift
//  Mapapp
//
//  
//

import SwiftUI
import MapKit

struct AnnotationItemStruct:Identifiable{
    let id = UUID()
    let coordinate:CLLocationCoordinate2D
}

struct AkioView: View {

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900,
                                       longitude: -122.009_020),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )

    @State var annotationItems: [AnnotationItemStruct] = []

    private let locationManager = LocationManager()

    var body: some View {
        VStack {
            Button(
                action: {
                    annotationItems = [
                        .init(coordinate: .init(latitude: 37.334, longitude: -122.009)),
                        .init(coordinate: .init(latitude: 37.335, longitude: -122.008)),
                        .init(coordinate: .init(latitude: 37.332, longitude: -122.007)),
                    ]
                },
                label: { Text("検索") }
            )
                .padding()
            Button(
                action: {
                    locationManager.setup(didUpdate: {
                        region.center = $0.coordinate
                    })
                    locationManager.requestLocation()
                },
                label: { Text("現在地") }
            )
                .padding()
            Map(
                coordinateRegion: $region,
                annotationItems: annotationItems,
                annotationContent: {
                    MapPin(coordinate: $0.coordinate)
                }
            )
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    private var didUpdate: (CLLocation) -> Void = { _ in }

    func setup(didUpdate: @escaping (CLLocation) -> Void) {
        self.didUpdate = didUpdate
    }

    func requestLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else { return }
        didUpdate(first)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

struct AkioView_Previews: PreviewProvider {
    static var previews: some View {
        AkioView()
    }
}
