//
//  filtrosViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 19/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit

class filtrosViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var misFiltros: filtrosAplicar!
    let colors = ["Red","Yellow","Green","Blue"]
    var tempColonia: String = ""

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
    garagesStepper.value = 0
    coloniasSelector.delegate = self
    coloniasSelector.dataSource = self
        
        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        tempColonia = colors[row]
        return colors[row]
    }

    
    @IBAction func aplicarFiltros(_ sender: UIButton) {
        let tempTipoOperacion = tipoOperacion.selectedSegmentIndex
        let tempTipoPropiedad = tipoPropiedad.selectedSegmentIndex
        let tempHabitaciones = Int(habitacionesTextLabel.text!)
        let tempBanos = Int(banosTextLabel.text!)
        let tempGarages = Int(garagesTextLabel.text!)
        let tempAmueblado: Int
        
        if amuebladoSwitch.isOn {
             tempAmueblado = 1
        } else {
             tempAmueblado = 0
        }
        
        
        
        print(tempTipoOperacion)
        print(tempTipoPropiedad)
        print(tempHabitaciones!)
        print(tempBanos!)
        print(tempGarages!)
        print(tempAmueblado)
        print(tempColonia)
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
        dismiss(animated: true, completion: nil)
    }
    
    
}
