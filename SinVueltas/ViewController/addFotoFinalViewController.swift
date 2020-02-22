//
//  addFotoFinalViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 21/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MobileCoreServices
import FirebaseFirestore
import FirebaseStorage
import FirebaseCore
import CoreLocation


class addFotoFinalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    let db = Firestore.firestore()
    var idPropiedad: String = ""
    var datosFinales: agregarPropiedades!
   let locationManager = CLLocationManager()
    
    @IBOutlet weak var impProp: UIImageView!
    
    var ref: DocumentReference!
    var getRef: Firestore!
    
    var optimizedImage: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        getRef = Firestore.firestore()
        
        idPropiedad = db.collection("propiedades").document().documentID
        locationManager.delegate = self
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
    
       CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in

           guard let placemark = placemarks?.first else {
               let errorString = error?.localizedDescription ?? "Unexpected Error"
               print("Unable to reverse geocode the given location. Error: \(errorString)")
               return
           }

           let reversedGeoLocation = ReversedGeoLocation(with: placemark)
           print(reversedGeoLocation.formattedAddress)
        
       }
    }
    
    
    struct ReversedGeoLocation {
        let name: String
        let streetName: String
        let streetNumber: String
        let city: String
        let state: String
        let zipCode: String
        let country: String
        let isoCountryCode: String

        var formattedAddress: String {
            return """
            \(name),
            \(streetNumber) \(streetName),
            \(city), \(state) \(zipCode)
            \(country)
            """
        }

        init(with placemark: CLPlacemark) {
            self.name           = placemark.name ?? ""
            self.streetName     = placemark.thoroughfare ?? ""
            self.streetNumber   = placemark.subThoroughfare ?? ""
            self.city           = placemark.locality ?? ""
            self.state          = placemark.administrativeArea ?? ""
            self.zipCode        = placemark.postalCode ?? ""
            self.country        = placemark.country ?? ""
            self.isoCountryCode = placemark.isoCountryCode ?? ""
        }
    }

    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

           let location = locations[locations.count - 1]
           if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let Longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            let speed = location.speed
            let floor = location.floor
            let timeStamp = location.timestamp
            let courseDirection = location.course
            let hightFromSeaLevel = location.altitude
           }
       }
    
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
       }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func selectImage(_ sender: UIButton){
        
        let photoImage = UIImagePickerController()
        
        photoImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        //Se selecciona la imagen y se obtiene el nombre del archivo
        photoImage.mediaTypes = [kUTTypeImage as String]
        photoImage.delegate = self
        
        present(photoImage, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info trae los datos de la imagen que se acaba de seleccionar
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = imageSelected.jpegData(compressionQuality: 0.7){
            
            impProp.image = imageSelected
            optimizedImage = optimizedImageData
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImage(imageData: Data){
        
        let storageReference = Storage.storage().reference()
        
        let userImageRef = storageReference.child("/fotosProps").child( "\(idPropiedad).jpg")
        
        let uploadMetadata = StorageMetadata()
        
        uploadMetadata.contentType = "image/jpeg"
        
        
        userImageRef.putData(imageData, metadata: uploadMetadata){
            (StorageMetadata, error) in
            
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("metadata:", StorageMetadata?.path)
            }
            
            
            
        }
        
    }
    

    
    @IBAction func agregarPropiedad(_ sender: UIButton) {
        
        print(idPropiedad)
        let nombreProp = "\(datosFinales.tipoPropiedad ) en \(datosFinales.tipoOperacion) en \(datosFinales.colonia)"
        
        uploadImage(imageData: optimizedImage)
        
        db.collection("propiedades").addDocument(data: [
            
            "amueblado": datosFinales.amueblado,
            "banos": datosFinales.banos,
            "colonia": datosFinales.colonia,
            //"dirs"
            "garages": datosFinales.garages,
            "habitaciones":datosFinales.habitaciones,
            "nombre": nombreProp,
            "precio": datosFinales.precio,
            //"superficie":
            "tipo_Operacion": datosFinales.tipoOperacion,
            "tipo_propiedad":datosFinales.tipoPropiedad

            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print( "Cargado con exito" )
                }
            }
    }
    

}
