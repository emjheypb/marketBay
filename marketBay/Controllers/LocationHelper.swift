//
//  LocationHelper.swift
//  marketBay
//
//  Created by EmJhey PB on 3/13/24.
//

import Foundation
import CoreLocation
import Contacts

class LocationHelper: ObservableObject {
    
    private let geocoder = CLGeocoder()
    
    func convertAddressToCoordinates(address: String, completionHandler: @escaping(Bool, Double, Double) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Error: Unable to geocode address")
                completionHandler(false, 0, 0)
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Update latitudeIn and longitudeIn accordingly
            completionHandler(true, latitude, longitude)
            return
        }
    }
    
    func convertCoordinatesToAddress(latitude: Double, longitude: Double, completionHandler: @escaping(String) -> Void) {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
            placemarks, error in
            if(error != nil) {
                print(#function, "No Address Found")
            } else {
                if let place = placemarks?.first {
                    let matchedLocation = place.postalAddress
                    completionHandler("\(matchedLocation?.street ?? ""), \(matchedLocation?.city ?? ""), \(matchedLocation?.country ?? "")")
                    return
                }
            }
            
            completionHandler("N/A")
        }
    }
}
