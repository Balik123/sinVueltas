//
//  confirmarCitaViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 02/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage


class confirmarCitaViewController: UIViewController {
    
    @IBOutlet weak var nombreUsuario: UITextField!
    @IBOutlet weak var telefonoUsuario: UITextField!
    @IBOutlet weak var fechaVisita: UIDatePicker!
    
    @IBOutlet weak var tituloTL: UILabel!
    @IBOutlet weak var tituloBtnConfirmar: UIButton!
    @IBOutlet weak var telTL: UILabel!
    @IBOutlet weak var nombreTL: UILabel!
    @IBOutlet weak var subTitulo: UILabel!
    
    
    var db = Firestore.firestore()
    var storageReference: StorageReference!
       
    
    
    let fechaHoy = Date()
    var components = DateComponents()
    let defaults = UserDefaults.standard
    var validado: Bool = false
    var idUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageReference = Storage.storage().reference()
        components.setValue(2, for: .day)
        let fechaMinima = Calendar.current.date(byAdding: components, to: fechaHoy)
        fechaVisita.minimumDate = fechaMinima
        
        verificarRegistro()
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if validado == true{
            tituloTL.adjustsFontSizeToFitWidth = true
            tituloTL.lineBreakMode = .byWordWrapping
            tituloTL.text = "Al agregar nuevas porpiedades, tu fecha de visita puede cambiar!"
            subTitulo.isHidden = true
            nombreTL.isHidden = true
            telTL.isHidden = true
            telefonoUsuario.isHidden = true
            nombreUsuario.isHidden = true
            tituloBtnConfirmar.setTitle("Cambiar Fecha", for: .normal)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func back_propiedades(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func confirmarCita(_ sender: Any) {
        
        if validado == false {
            
        //ESTO PUEDE SER UNA CLASE
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short

        let fechaFinalVisita = dateFormatter.string(from: fechaVisita.date)
        guard let userName = nombreUsuario.text, let userPhone = telefonoUsuario.text else {
            return
        }
        
        let arrProps = self.defaults.stringArray(forKey: "PropiedadesArray") ?? [String]()

        
        if userName != "" && userPhone != "" && arrProps.count != 0{
            
            //ESTO PODRIA SER UNA CLASE
            let datosAGuardar = datosUsuarios(idUsuario: UIDevice.identifier, nombreUsuario: userName, telefonoUsuario: userPhone, propiedadesAVisitar: arrProps, fechaVisita: fechaFinalVisita)
            let db = Firestore.firestore()
            
            db.collection("Usuarios").addDocument(data: [
                "id_Usuario": datosAGuardar.idUsuario,
                "nombre": datosAGuardar.nombreUsuario,
                "telefono": datosAGuardar.telefonoUsuario,
                "propiedades_A_Visitar": datosAGuardar.propiedadesAVisitar,
                "fecha_De_Visita": datosAGuardar.fechaVisita
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Creado con exito")
                    }
                }
            
            let alert = UIAlertController(title: "FELICIDADES!!!", message: "Tu cita esta confirmada, en unos minutos uno de nuestros Asesores se pondra en contacto contigo 😊", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { action in
                   self.dismiss(animated: true, completion: nil)
                }))
            self.present(alert, animated: true, completion: nil)
            
            

        }
        else{
            let alert = UIAlertController(title: "Ups!!!", message: "Lo olvidaste, debes llenar todos los campos 😅", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        
        
        }
        }else{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            let fechaFinalVisita = dateFormatter.string(from: fechaVisita.date)
            let washingtonRef = db.collection("Usuarios").document(idUser)

            washingtonRef.updateData([
                "fecha_De_Visita": fechaFinalVisita
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    let alert = UIAlertController(title: "FELICIDADES!!!", message: "Tu cita esta confirmada, en unos minutos uno de nuestros Asesores se pondra en contacto contigo 😊", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { action in
                           self.dismiss(animated: true, completion: nil)
                        }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        
    }
    
    
    func verificarRegistro(){
        
        db.collection("Usuarios").whereField("id_Usuario", isEqualTo: "-8938262307736497869:D0B92A6C-9BF2-460A-922E-A617C1E3A6BC")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.validado = true
                        self.idUser = document.documentID
                        
                    }
                }
                self.viewWillAppear(true)
        }
        
    }

    
    
}
