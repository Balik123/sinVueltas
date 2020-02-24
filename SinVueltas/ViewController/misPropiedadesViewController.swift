//
//  misPropiedadesViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 23/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


class misPropiedadesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var db = Firestore.firestore()
    var storageReference: StorageReference!
    var validacionCount:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    let defaults = UserDefaults.standard
    
    var misPropTable: [propiedades] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if validacionCount == false{
            return misPropTable.count
    }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 202.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! celdaMisPropiedadesUICellTableViewCell
        
        print(validacionCount)
        let userImageRef = storageReference.child("/fotosProps").child("\(misPropTable[indexPath.row].id_Propiedad).jpg")

           userImageRef.downloadURL { (url, error) in
           if let error = error{
               print(error.localizedDescription)
           }else{
               print("imagen descargada")
               }
           }


        cell.nombreProp.text = misPropTable[indexPath.row].nombre
        cell.tipo_oper.text = misPropTable[indexPath.row].tipo_operacion
        cell.tipoProp.text = misPropTable[indexPath.row].tipo_propiedad
        cell.habitaciones.text = String(misPropTable[indexPath.row].habitaciones)
        cell.banos.text = String(misPropTable[indexPath.row].banos)
        cell.garages.text = String(misPropTable[indexPath.row].garages)
        cell.imgProp?.sd_setImage(with: userImageRef)
        
        
        return cell
    }
    
    
    
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Eliminar") {  (contextualAction, view, boolValue) in
            
            let miProp = self.defaults.array(forKey: "misPropSubidas")
            var temPropFinal: [String] = []
            
            self.db.collection("propiedades").document(miProp![indexPath.row] as! String).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            
            for mP in miProp as! [String]{
                
                if mP != "\(miProp![indexPath.row])"{
                    temPropFinal.append(mP)
                }

            }
            
            self.defaults.removeObject(forKey: "misPropSubidas")
            self.defaults.set(temPropFinal, forKey: "misPropSubidas")
            
            self.getPropiedades()
            self.tableView.reloadData()
            
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verMasMisPropAVisitar"{
            let indexPath = tableView.indexPathForSelectedRow
            
            let verMasPropAVisitar = segue.destination as? verMasMisPropiedadesViewController
            verMasPropAVisitar?.datosPropiedad = misPropTable[(indexPath?.row)!]
        }
    }
    
    
    
    
    func getPropiedades(){
        self.misPropTable.removeAll()
        if defaults.array(forKey: "misPropSubidas") != nil {
            let idProp = defaults.array(forKey: "misPropSubidas")!
            
            for idPropiedades in idProp{
                
                db.collection("propiedades").document(idPropiedades as! String)
                    .getDocument { (document, error) in
                    if let document = document, document.exists {
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
                            
                            self.misPropTable.append(prop)
                    } else {
                        print("Document does not exist")
                    }
                        
                    self.tableView.reloadData()
                }
                
            }
            
        }else{
            self.validacionCount = true
            self.tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func backPerfil(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
