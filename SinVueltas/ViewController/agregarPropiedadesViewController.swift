//
//  agregarPropiedadesViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 20/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

class agregarPropiedadesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dicColonias: [String] = []
    var db = Firestore.firestore()
    var ref: DocumentReference!
    var getRef: Firestore!
    var storageReference: StorageReference!
    
    
    @IBOutlet weak var tipoOperacionSG: UISegmentedControl!
    @IBOutlet weak var tipoPropiedadSG: UISegmentedControl!
    @IBOutlet weak var habitacionesTL: UILabel!
    @IBOutlet weak var banosTL: UILabel!
    @IBOutlet weak var garagesTL: UILabel!
    @IBOutlet weak var habitacionesSTP: UIStepper!
    @IBOutlet weak var banosSTP: UIStepper!
    @IBOutlet weak var garagesSTP: UIStepper!
    @IBOutlet weak var ambuebladoSW: UISwitch!
    @IBOutlet weak var precioTL: UILabel!
    @IBOutlet weak var precioSLID: UISlider!
    @IBOutlet weak var coloniaPV: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitacionesSTP.minimumValue = 1
        habitacionesSTP.maximumValue = 9
        banosSTP.minimumValue = 1
        banosSTP.maximumValue = 9
        garagesSTP.minimumValue = 0
        garagesSTP.maximumValue = 9
        coloniaPV.delegate = self
        coloniaPV.dataSource = self
        precioSLID.value = 0

        // Do any additional setup after loading the view.
        
        getcolonias()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func getcolonias(){
        db.collection("dicColonias").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let values = document.data()
                    
                    let colonias = values["nombre"] as! [String]
                    for col in colonias{
                        self.dicColonias.append(col)
                    }
                    
                }
                self.coloniaPV.reloadAllComponents()
            }
        }
            
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicColonias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dicColonias[row]
    }

    
    
    @IBAction func numHabitaciones(_ sender: UIStepper) {
        
        let value = habitacionesSTP.value
        habitacionesTL.text = String(Int(value))
        
    }
    @IBAction func numBanos(_ sender: UIStepper) {
        let value = banosSTP.value
        banosTL.text = String(Int(value))
    }
    @IBAction func numGarages(_ sender: UIStepper) {
        let value = garagesSTP.value
        garagesTL.text = String(Int(value))
    }
    
    
    @IBAction func calulatePriceFinal(_ sender: UISlider) {
        
    if(tipoOperacionSG.selectedSegmentIndex == 0){
        precioSLID.maximumValue = 50000000
        
        precioSLID.minimumValue = 1000000
        precioTL.text = "1000000"
            let value = precioSLID.value
            precioTL.text = String(Int(value))
        }
    
    if(tipoOperacionSG.selectedSegmentIndex == 1){
        precioSLID.maximumValue = 100000
        precioSLID.minimumValue = 10000
        precioTL.text = "10000"
        
            let value = precioSLID.value
            precioTL.text = String(Int(value))
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let tempTipoOperacion: String
        if tipoOperacionSG.selectedSegmentIndex == 0{
            tempTipoOperacion = "Venta"
        }else{
            tempTipoOperacion = "Renta"
        }
        let tempTipoPropiedad: String
        if tipoPropiedadSG.selectedSegmentIndex == 0 {
            tempTipoPropiedad = "Casa"
        }else{
            tempTipoPropiedad = "Departamento"
        }
        let tempHabitaciones = Int(habitacionesTL.text ?? "1")!
        let tempBanos = Int(banosTL.text ?? "1")!
        let tempGarages = Int(garagesTL.text ?? "1")!
        let tempAmueblado: String
        
        if ambuebladoSW.isOn {
             tempAmueblado = "Si"
        } else {
             tempAmueblado = "No"
        }
        let tempPrecio = Int(precioTL.text ?? "0")!
        let tempColonia = dicColonias[coloniaPV.selectedRow(inComponent: 0)]
        
        let datos: agregarPropiedades = agregarPropiedades(tipoOperacion: tempTipoOperacion, tipoPropiedad: tempTipoPropiedad, habitaciones: tempHabitaciones, banos: tempBanos, garages: tempGarages, amueblado: tempAmueblado, precio: tempPrecio, colonia: tempColonia)
        
        
        
        if segue.identifier == "agregarFoto"{
            let datosFinales = segue.destination as? addFotoFinalViewController
            datosFinales?.datosFinales = datos
        }
        
        
    }
    
    
}
