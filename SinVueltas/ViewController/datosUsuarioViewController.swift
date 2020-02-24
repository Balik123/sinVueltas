//
//  datosUsuarioViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 22/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


class datosUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nombreUsuarioTL: UILabel!
    @IBOutlet weak var telUsuarioTL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var db = Firestore.firestore()
    var storageReference: StorageReference!
    
    let defaults = UserDefaults.standard
    var propaMostrar: [String] = []
    var propTable: [propiedades] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageReference = Storage.storage().reference()
        getDatosUsuario()

        
    }
    
     override func viewWillAppear(_ animated: Bool) {
           storageReference = Storage.storage().reference()
           getPropiedades()
        
           
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
        return propTable.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 202.0;//Choose your custom row height
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! celdaUsuarioTableViewCell
        
        let userImageRef = storageReference.child("/fotosProps").child("\(propTable[indexPath.row].id_Propiedad).jpg")

           userImageRef.downloadURL { (url, error) in
           if let error = error{
               print(error.localizedDescription)
           }else{
               print("imagen descargada")
               }
           }


        cell.nombrePropUsuarioRegistrado.text = propTable[indexPath.row].nombre
        cell.tipoOperacionPropUsuarioRegistrado.text = propTable[indexPath.row].tipo_operacion
        cell.tipoPropiedadPropUsuarioRegistrado.text = propTable[indexPath.row].tipo_propiedad
        cell.habitacionPropUsuarioRegistrado.text = String(propTable[indexPath.row].habitaciones)
        cell.banosPropUsuarioRegistrado.text = String(propTable[indexPath.row].banos)
        cell.garagePropUsuarioRegistrado.text = String(propTable[indexPath.row].garages)
        cell.imgPropPorVisitar?.sd_setImage(with: userImageRef)
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verMasPropAVisitar"{
            let indexPath = tableView.indexPathForSelectedRow
            
            let verMasPropAVisitar = segue.destination as? verMasPropiAVisitarViewController
            verMasPropAVisitar?.datosPropiedad = propTable[(indexPath?.row)!]
        }
    }
    
    
    
    /*func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Borrar") {  (contextualAction, view, boolValue) in
            
            let indexPath = tableView.indexPathForSelectedRow
            print(indexPath?.row)

            print(self.defaults.stringArray(forKey: "PropiedadesArray"))
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
        
        
    }*/
    
    
    
    func getDatosUsuario(){
        var propSelecUsuario: [String] = []
        
        db.collection("Usuarios").whereField("id_Usuario", isEqualTo: UIDevice.identifier)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let val = document.data()
                        
                        let nombreUsuario = val["nombre"] as? String ?? "Desconocido"
                        let telUsuario = val["telefono"] as? String ?? "Desconocido"
                        propSelecUsuario = (val["propiedades_A_Visitar"] as? [String])!
                        let fechaVisitaUsuario = val["fecha_De_Visita"] as? String ?? "Desconocido"
                        
                        self.nombreUsuarioTL.text = nombreUsuario
                        self.telUsuarioTL.text = telUsuario
                    }
                    
                    for pv in propSelecUsuario{
                        self.propaMostrar.append(pv)
                    }
                }
                self.viewWillAppear(true)
        }
        
    }
    
    
    
    
    func getPropiedades(){
        self.propTable.removeAll()
        for datos in propaMostrar{
            
            db.collection("propiedades").document(datos).getDocument { (document, error) in
                if let document = document, document.exists{
                    let id_propiedad = document.documentID
                    let val = document.data()
                    
                    let nombre = val?["nombre"] as? String ?? "sin valor"
                    let tipo_propiedad = val?["tipo_propiedad"] as? String ?? "sin valor"
                    let tipo_operacion = val?["tipo_Operacion"] as? String ?? "sin valor"
                    let amueblado = val?["amueblado"] as? String ?? "sin valor"
                    let habitaciones = val?["habitaciones"] as? Int ?? 0
                    let banos = val?["banos"] as? Int ?? 0
                    let garages = val?["garages"] as? Int ?? 0
                    let precio = val?["precio"] as? Int ?? 0
                    let superficie = val?["superficie"] as? String ?? "sin valor"
                    let colonia = val?["colonia"] as? String ?? "sin valor"
                    let direccion = val?["dirs"] as? String ?? "sin valor"
                    
                    let prop: propiedades = propiedades(id_Propiedad: id_propiedad, nombre: nombre, tipo_propiedad: tipo_propiedad, tipo_operacion: tipo_operacion, amueblado: amueblado, habitaciones: habitaciones, banos: banos, garages: garages, precio: precio, superficie: superficie, colonia: colonia, direccion: direccion)
                    
                    self.propTable.append(prop)
                }
                else{
                    print("El documento no existe")
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    

}
