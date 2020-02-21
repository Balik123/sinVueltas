//
//  usuarioViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 02/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseCore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

class usuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var db = Firestore.firestore()
    var ref: DocumentReference!
    var getRef: Firestore!
    var storageReference: StorageReference!

    var propAVisitar: [String] = []
    var propiedadesVal: [propiedades] = []
    
    @IBOutlet weak var label_Nombre: UILabel!
    @IBOutlet weak var label_Telefono: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getRef = Firestore.firestore()
        storageReference = Storage.storage().reference()
        getDatosUsuario()
        getPropiedadesVisita()
        
}

    
    override func viewWillAppear(_ animated: Bool) {
        getRef = Firestore.firestore()
        storageReference = Storage.storage().reference()
        getPropiedadesVisita()
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
        
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propAVisitar.count
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 202.0;//Choose your custom row height
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! celdaUsuarioTableViewCell
        
         let userImageRef = storageReference.child("/fotosProps").child("\(propiedadesVal[indexPath.row].id_Propiedad).jpg")

           userImageRef.downloadURL { (url, error) in
           if let error = error{
               print(error.localizedDescription)
           }else{
               print("imagen descargada")
               }
           }


        cell.nombrePropUsuarioRegistrado.text = propiedadesVal[indexPath.row].nombre
        cell.tipoOperacionPropUsuarioRegistrado.text = propiedadesVal[indexPath.row].tipo_operacion
        cell.tipoPropiedadPropUsuarioRegistrado.text = propiedadesVal[indexPath.row].tipo_propiedad
        cell.habitacionPropUsuarioRegistrado.text = String(propiedadesVal[indexPath.row].habitaciones)
        cell.banosPropUsuarioRegistrado.text = String(propiedadesVal[indexPath.row].banos)
        cell.garagePropUsuarioRegistrado.text = String(propiedadesVal[indexPath.row].garages)
        cell.imgPropPorVisitar?.sd_setImage(with: userImageRef)
     
     return cell
     
     }
    
    
    
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verMasPropAVisitar"{
            let indexPath = tableView.indexPathForSelectedRow
            
            let verMasPropAVisitar = segue.destination as? verMasPropiAVisitarViewController
            verMasPropAVisitar?.datosPropiedad = propiedadesVal[(indexPath?.row)!]
        }
    }



    
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let contextItem = UIContextualAction(style: .destructive, title: "Borrar") {  (contextualAction, view, boolValue) in
            
            
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
        
        
    }
    
    
    
    func getPropiedadesVisita(){
        
        for data in propAVisitar{
            
            let docRef = db.collection("propiedades").document(data)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let id_Propiedad = document.documentID
                    let values = document.data()
                                    
                    let nombre = values?["nombre"] as? String ?? "sin valor"
                    let tipo_propiedad = values?["tipo_propiedad"] as? String ?? "sin valor"
                    let tipo_operacion = values?["tipo_Operacion"] as? String ?? "sin valor"
                    let amueblado = values?["amueblado"] as? String ?? "sin valor"
                    let habitaciones = values?["habitaciones"] as? Int ?? 0
                    let banos = values?["banos"] as? Int ?? 0
                    let garages = values?["garages"] as? Int ?? 0
                    let precio = values?["precio"] as? Int ?? 0
                    let superficie = values?["superficie"] as? String ?? "sin valor"
                    let colonia = values?["colonia"] as? String ?? "sin valor"
                    let direccion = values?["dirs"] as? String ?? "sin valor"
                                    
                    
                    let prop = propiedades(id_Propiedad:id_Propiedad, nombre: nombre, tipo_propiedad: tipo_propiedad, tipo_operacion: tipo_operacion, amueblado: amueblado, habitaciones: habitaciones, banos: banos, garages: garages, precio: precio, superficie: superficie, colonia: colonia, direccion: direccion)

                    self.propiedadesVal.append(prop)
                    
                } else {
                    print("Document does not exist")
                }
                
                self.tableView.reloadData()
                
            }
        }
        
        
    }
    
    

    
    
    
    func getDatosUsuario() {
        
        var propiedadesAVisitar: [String] = []
        //agregar id de dispositivo
        db.collection("Usuarios").whereField("id_Usuario", isEqualTo: "7856450342074890904:31C3CC5E-2BEF-452C-A6F8-25E97259C626")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let values = document.data()
                        
                        let nombreUsuario = values["nombre"] as? String ?? "sin valor"
                        let telefonoUsuario = values["telefono"] as? String ?? "sin valor"
                        propiedadesAVisitar = values["propiedades_A_Visitar"] as! [String]
                        let fechaVisita = values["fecha_De_Visita"] as? String ?? "sin valor"
                        
                        
                        self.label_Telefono.text = telefonoUsuario
                        self.label_Nombre.text = nombreUsuario
                        
                        self.propAVisitar = propiedadesAVisitar
                        
                    }
                    
                    self.viewWillAppear(true)
                }
               
        }
        
}
    
    
    


}
