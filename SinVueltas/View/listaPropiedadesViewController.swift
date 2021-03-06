//
//  listaPropiedadesViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 31/01/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

class listaPropiedadesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var propiedadesVal: [propiedades] = []
    var ref: DocumentReference!
    var getRef: Firestore!
    var db = Firestore.firestore()
    var storageReference: StorageReference!
    let defaults = UserDefaults.standard
    var filtros: [filtrosAplicar] = []
    @IBOutlet weak var btnSigConfirmarCita: UIButton!
    


    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRef = Firestore.firestore()
        storageReference = Storage.storage().reference()
        getPropiedades()
        validarBtn()
        let filtrosAplicados: [filtrosAplicar] = defaults.structArrayData(filtrosAplicar.self, forKey: "filtros")
        print(filtrosAplicados)
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRef = Firestore.firestore()
        storageReference = Storage.storage().reference()
        getPropiedades()
        validarBtn()

    }
    
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.validarBtn()
                self.getPropiedades()
            }
        }
    }
 

    func validarBtn(){
        let arrProps = self.defaults.stringArray(forKey: "PropiedadesArray") ?? [String]()
        
        if arrProps.isEmpty{
            btnSigConfirmarCita.isHidden = true
        }else{
            btnSigConfirmarCita.isHidden = false
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return propiedadesVal.count

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 202.0;//Choose your custom row height
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! celdaPropiedadesTableViewCell
    
    let userImageRef = storageReference.child("/fotosProps").child("\(propiedadesVal[indexPath.row].id_Propiedad).jpg")
    
    userImageRef.downloadURL { (url, error) in
    if let error = error{
        print(error.localizedDescription)
    }
        
    }
    
    cell.nombreProp.text = propiedadesVal[indexPath.row].nombre
    cell.tipoProp.text = propiedadesVal[indexPath.row].tipo_propiedad
    cell.tipo_oper.text = propiedadesVal[indexPath.row].tipo_operacion
    cell.habitaciones.text = String(propiedadesVal[indexPath.row].habitaciones)
    cell.banos.text = String(propiedadesVal[indexPath.row].banos)
    cell.garages.text = String(propiedadesVal[indexPath.row].garages)
    cell.imgProp?.sd_setImage(with: userImageRef)
            
    
    return cell
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verMas"{
            let indexPath = tableView.indexPathForSelectedRow
            
            let verMas = segue.destination as? verMasViewController
            verMas?.datosPropiedad = propiedadesVal[(indexPath?.row)!]
        }
    }
   
    
    
    func getPropiedades(){
        
        filtros = defaults.structArrayData(filtrosAplicar.self, forKey: "filtros")
        
        if filtros.isEmpty {
            
            getRef.collection("propiedades").addSnapshotListener{ (querySnapshot, error) in
                
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                self.propiedadesVal.removeAll()
                for document in querySnapshot!.documents{
                    
                let id_Propiedad = document.documentID
                let values = document.data()
                        
                let nombre = values["nombre"] as? String ?? "sin valor"
                let tipo_propiedad = values["tipo_propiedad"] as? String ?? "sin valor"
                let tipo_operacion = values["tipo_Operacion"] as? String ?? "sin valor"
                let amueblado = values["amueblado"] as? String ?? "sin valor"
                let habitaciones = values["habitaciones"] as? Int ?? 0
                let banos = values["banos"] as? Int ?? 0
                let garages = values["garages"] as? Int ?? 0
                let precio = values["precio"] as? Int ?? 0
                let superficie = values["superficie"] as? String ?? "sin valor"
                let colonia = values["colonia"] as? String ?? "sin valor"
                let direccion = values["dirs"] as? String ?? "sin valor"
                            
            
                let prop = propiedades(id_Propiedad:id_Propiedad, nombre: nombre, tipo_propiedad: tipo_propiedad, tipo_operacion: tipo_operacion, amueblado: amueblado, habitaciones: habitaciones, banos: banos, garages: garages, precio: precio, superficie: superficie, colonia: colonia, direccion: direccion)

                self.propiedadesVal.append(prop)
                }
                self.tableView.reloadData()
            }
        }
    }
    else{

            db.collection("propiedades").whereField("colonia", isEqualTo: filtros[0].colonia)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.propiedadesVal.removeAll()
                        for document in querySnapshot!.documents{
                        let id_Propiedad = document.documentID
                        let values = document.data()
                                                
                                
                        let nombre = values["nombre"] as? String ?? "sin valor"
                        let tipo_propiedad = values["tipo_propiedad"] as? String ?? "sin valor"
                        let tipo_operacion = values["tipo_Operacion"] as? String ?? "sin valor"
                        let amueblado = values["amueblado"] as? String ?? "sin valor"
                        let habitaciones = values["habitaciones"] as? Int ?? 0
                        let banos = values["banos"] as? Int ?? 0
                        let garages = values["garages"] as? Int ?? 0
                        let precio = values["precio"] as? Int ?? 0
                        let superficie = values["superficie"] as? String ?? "sin valor"
                        let colonia = values["colonia"] as? String ?? "sin valor"
                        let direccion = values["dirs"] as? String ?? "sin valor"
                        

                            
                        if tipo_propiedad == self.filtros[0].tipoPropiedad &&
                            tipo_operacion == self.filtros[0].tipoOperacion &&
                            amueblado == self.filtros[0].amueblado &&
                            habitaciones >= self.filtros[0].habitaciones &&
                            banos >= self.filtros[0].banos &&
                            garages >= self.filtros[0].garages &&
                            precio <= self.filtros[0].precio{
                                
                            let prop = propiedades(id_Propiedad:id_Propiedad, nombre: nombre, tipo_propiedad: tipo_propiedad, tipo_operacion: tipo_operacion, amueblado: amueblado, habitaciones: habitaciones, banos: banos, garages: garages, precio: precio, superficie: superficie, colonia: colonia, direccion: direccion)
                            self.propiedadesVal.append(prop)
                        }
                                    
                        }
                    
                        self.tableView.reloadData()
                }
        }
            
            
            
            
    }
        
        
    }
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)

        self.tableView.reloadData()
    }
    
    

}
