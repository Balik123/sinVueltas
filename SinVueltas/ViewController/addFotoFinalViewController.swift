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


class addFotoFinalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let db = Firestore.firestore()
    var idPropiedad: String = ""
    var datosFinales: agregarPropiedades!
    var indicador: String = ""
    let defaults = UserDefaults.standard

    let activityIndicator = UIActivityIndicatorView.init(style: .large)
        
    @IBOutlet weak var superficieTF: UITextField!
    @IBOutlet weak var calleTF: UITextField!
    @IBOutlet weak var impProp: UIImageView!
    @IBOutlet weak var vistaIndicador: UIView!
    
    var ref: DocumentReference!
    var getRef: Firestore!
    
    var optimizedImage: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        getRef = Firestore.firestore()
        
        idPropiedad = db.collection("propiedades").document().documentID
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.color = .white
        vistaIndicador.isHidden = true
        
      
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
        self.vistaIndicador.isHidden = false
        self.activityIndicator.startAnimating()
        let storageReference = Storage.storage().reference()
        let userImageRef = storageReference.child("/fotosProps").child( "\(idPropiedad).jpg")
        let uploadMetadata = StorageMetadata()
        
        uploadMetadata.contentType = "image/jpeg"
        
        
        userImageRef.putData(imageData, metadata: uploadMetadata){
            (StorageMetadata, error) in
            
            
            if let error = error{
                print(error.localizedDescription)
            }else{
                self.activityIndicator.removeFromSuperview()
                self.vistaIndicador.isHidden = true
                self.dismiss(animated: true, completion: nil)
            }

        }
    
    }
    
    

    
    @IBAction func agregarPropiedad(_ sender: UIButton) {
        
        
        if superficieTF.text != "" && impProp.image != nil  {

        let direccion:String = "\(datosFinales.colonia),\(calleTF.text ?? "")"
        let nombreProp:String = "\(datosFinales.tipoPropiedad ) en \(datosFinales.tipoOperacion) en \(datosFinales.colonia)"
        
        uploadImage(imageData: optimizedImage)
        
        db.collection("propiedades").document(idPropiedad).setData([
            
            "amueblado": datosFinales.amueblado,
            "banos": datosFinales.banos,
            "colonia": datosFinales.colonia,
            "dirs": direccion,
            "garages": datosFinales.garages,
            "habitaciones":datosFinales.habitaciones,
            "nombre": nombreProp,
            "precio": datosFinales.precio,
            "superficie": superficieTF.text ?? "",
            "tipo_Operacion": datosFinales.tipoOperacion,
            "tipo_propiedad":datosFinales.tipoPropiedad

            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print( "Cargado con exito" )
                    
                    if self.defaults.array(forKey: "misPropSubidas") == nil{
                        self.defaults.set([self.idPropiedad], forKey: "misPropSubidas")
                    }else{
                        let tempUserDef = self.defaults.array(forKey: "misPropSubidas")!
                        var tempMisProp:[String] = []
                        
                        for tU in tempUserDef{
                            tempMisProp.append(tU as! String)
                        }
                        tempMisProp.append(self.idPropiedad)
                        self.defaults.removeObject(forKey: "misPropSubidas")
                        self.defaults.set(tempMisProp, forKey: "misPropSubidas")
                    }
                    
                    
                    //var tempMisProp = self.defaults.array(forKey: "misPropSubidas") as! [String]
                    
                    //print(tempMisProp)
                    
                    /*if tempMisProp.isEmpty{
                        
                    }else{
                        print("aqui")
                        
                    }*/
                    
                }
            }
        }
    
        else if superficieTF.text != "" && impProp.image == nil{
            let alert = UIAlertController(title: "Ups!!!", message: "Lo olvidaste, debes cargar una foto 😢", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if superficieTF.text == "" && impProp.image != nil{
            let alert = UIAlertController(title: "Ups!!!", message: "Lo olvidaste, debes llenar la superficie... no sabemos cuanto mide tu casa 😩", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else{
            
            let alert = UIAlertController(title: "Ups!!!", message: "Lo olvidaste, debes llenar todos los campos 😅", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
    
    @IBAction func cancelUploadProp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
