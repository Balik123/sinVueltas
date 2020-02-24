//
//  filtrosViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 19/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

class filtrosViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
        
    var dicColonias: [String] = []
    var db = Firestore.firestore()
    var ref: DocumentReference!
    var getRef: Firestore!
    var storageReference: StorageReference!
    let defaults = UserDefaults.standard
    


    @IBOutlet weak var tipoOperacion: UISegmentedControl!
    @IBOutlet weak var tipoPropiedad: UISegmentedControl!
    
    @IBOutlet weak var habitacionesTextLabel: UILabel!
    @IBOutlet weak var banosTextLabel: UILabel!
    @IBOutlet weak var garagesTextLabel: UILabel!
    
    @IBOutlet weak var amuebladoSwitch: UISwitch!
    @IBOutlet weak var precioTextLabel: UILabel!
    @IBOutlet weak var coloniasSelector: UIPickerView!
    
    @IBOutlet weak var habitacionesStepper: UIStepper!
    @IBOutlet weak var banosStepper: UIStepper!
    @IBOutlet weak var garagesStepper: UIStepper!
    @IBOutlet weak var calculatePriceSlider: UISlider!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    habitacionesStepper.minimumValue = 1
    habitacionesStepper.maximumValue = 9
    banosStepper.minimumValue = 1
    banosStepper.maximumValue = 9
    garagesStepper.minimumValue = 0
    garagesStepper.maximumValue = 9
    coloniasSelector.delegate = self
    coloniasSelector.dataSource = self
    
    validacionDeFiltros()
    self.performSegue(withIdentifier: "updateFiltros", sender: self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        getcolonias()
        validacionDeFiltros()        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         self.performSegue(withIdentifier: "updateFiltros", sender: self)
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
        
        self.dicColonias.removeAll()
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
                self.coloniasSelector.reloadAllComponents()
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

    
    @IBAction func aplicarFiltros(_ sender: UIButton) {
        let tempTipoOperacion: String
        if tipoOperacion.selectedSegmentIndex == 0{
            tempTipoOperacion = "Venta"
        }else{
            tempTipoOperacion = "Renta"
        }
        let tempTipoPropiedad: String
        if tipoPropiedad.selectedSegmentIndex == 0 {
            tempTipoPropiedad = "Casa"
        }else{
            tempTipoPropiedad = "Departamento"
        }
        let tempHabitaciones = Int(habitacionesTextLabel.text!)!
        let tempBanos = Int(banosTextLabel.text!)!
        let tempGarages = Int(garagesTextLabel.text!)!
        let tempAmueblado: String
        
        if amuebladoSwitch.isOn {
             tempAmueblado = "Si"
        } else {
             tempAmueblado = "No"
        }
        let tempPrecio = Int(precioTextLabel.text!)!
        
        let tempColonia = dicColonias[coloniasSelector.selectedRow(inComponent: 0)]
        
        let filtroAAplicar: [filtrosAplicar] = [filtrosAplicar(tipoOperacion: tempTipoOperacion, tipoPropiedad: tempTipoPropiedad, habitaciones: tempHabitaciones, banos: tempBanos, garages: tempGarages, amueblado: tempAmueblado, precio: tempPrecio, colonia: tempColonia)]
        
        defaults.removeObject(forKey: "filtros")
        defaults.setStructArray(filtroAAplicar, forKey: "filtros")
        self.performSegue(withIdentifier: "updateFiltros", sender: self)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func numHabitaciones(_ sender: UIStepper) {
        
        let value = habitacionesStepper.value
        habitacionesTextLabel.text = String(Int(value))
        
    }
    @IBAction func numBanos(_ sender: UIStepper) {
        let value = banosStepper.value
        banosTextLabel.text = String(Int(value))
    }
    @IBAction func numGarages(_ sender: UIStepper) {
        let value = garagesStepper.value
        garagesTextLabel.text = String(Int(value))
    }
    
    
    @IBAction func calulatePriceFinal(_ sender: UISlider) {
        
    if(tipoOperacion.selectedSegmentIndex == 0){
        calculatePriceSlider.maximumValue = 50000000
        calculatePriceSlider.minimumValue = 1000000
        
            let value = calculatePriceSlider.value
            precioTextLabel.text = String(Int(value))
        }
    
    if(tipoOperacion.selectedSegmentIndex == 1){
        calculatePriceSlider.maximumValue = 100000
        calculatePriceSlider.minimumValue = 10000
        
        
            let value = calculatePriceSlider.value
            precioTextLabel.text = String(Int(value))
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func filtrosBackToSerch(_ sender: Any) {
        self.performSegue(withIdentifier: "updateFiltros", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    
    func validacionDeFiltros(){
        
        if defaults.object(forKey:"filtros") != nil {
            let filtrosAplicados: [filtrosAplicar] = defaults.structArrayData(filtrosAplicar.self, forKey: "filtros")
            
            habitacionesTextLabel.text = String(filtrosAplicados[0].habitaciones)
            habitacionesStepper.value = Double(filtrosAplicados[0].habitaciones)
            banosTextLabel.text = String(filtrosAplicados[0].banos)
            banosStepper.value = Double(filtrosAplicados[0].banos)
            garagesTextLabel.text = String(filtrosAplicados[0].garages)
            garagesStepper.value = Double(filtrosAplicados[0].garages)
            precioTextLabel.text = String(filtrosAplicados[0].precio)
            
            if filtrosAplicados[0].amueblado == "Si"{
                amuebladoSwitch.isOn = true
            }else{
                amuebladoSwitch.isOn = false
            }
            if filtrosAplicados[0].tipoOperacion == "Venta" {
                tipoOperacion.selectedSegmentIndex = 0
            }else{
                tipoOperacion.selectedSegmentIndex = 1
            }
            if filtrosAplicados[0].tipoPropiedad == "Casa"{
                tipoPropiedad.selectedSegmentIndex = 0
            }else{
                tipoPropiedad.selectedSegmentIndex = 1
            }
            
        }
        
            
        else{
            habitacionesTextLabel.text = "1"
            banosTextLabel.text = "1"
            garagesTextLabel.text = "0"
            precioTextLabel.text = "0"
            amuebladoSwitch.isOn = false
            tipoOperacion.selectedSegmentIndex = 0
            tipoPropiedad.selectedSegmentIndex = 0
            
        }
    }
    
    
    @IBAction func borrarFiltros(_ sender: Any) {
        defaults.removeObject(forKey: "filtros")
        self.performSegue(withIdentifier: "updateFiltros", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
