//
//  ContentView.swift
//  Mapapp
//
//  2021/12/04.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocation().coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var inputText = ""
    
    init() {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
    }
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode)
            VStack{
                Spacer()
                HStack{
                    TextField("", text: $inputText, prompt: Text("場所を入力"))
                        .border(.secondary)
                        .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .bottom]/*@END_MENU_TOKEN@*/)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            //関数を書く
                            localSearch(inputRegion: region, inputText: inputText, completionHandler: {(outputRegion) in
                                region = outputRegion
                            })
                        }
                    Button(action: {
                        //関数を書く
                    }, label:{ Image(systemName:"location.square")
                            .resizable()
                            .frame(width: /*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)})
                        .padding(/*@START_MENU_TOKEN@*/[.top, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
    
    private func localSearch(inputRegion: MKCoordinateRegion,inputText: String,completionHandler: @escaping (MKCoordinateRegion) -> Void) {
        var outputRegion: MKCoordinateRegion = MKCoordinateRegion()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = inputText
        searchRequest.region = inputRegion
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: {(response,error) in
            guard let targetRegion = response?.mapItems.first?.placemark.coordinate else { return print("検索失敗！")}
            outputRegion.center = targetRegion
            completionHandler(outputRegion)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
