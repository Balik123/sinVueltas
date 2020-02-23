//
//  verMasViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 01/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI


class verMasViewController: UIViewController {
    
    var datosPropiedad: propiedades!
    var storageReference: StorageReference!
    
    
    @IBOutlet weak var imgPropVerMAs: UIImageView!
    @IBOutlet weak var nombreVerMAs: UILabel!
    @IBOutlet weak var tipoPropVerMas: UILabel!
    @IBOutlet weak var tipoOperVerMas: UILabel!
    @IBOutlet weak var habitacionesVerMas: UILabel!
    @IBOutlet weak var banosVerMas: UILabel!
    @IBOutlet weak var garageVerMas: UILabel!
    @IBOutlet weak var precioVerMas: UILabel!
    @IBOutlet weak var amuebladoVerMas: UILabel!
    @IBOutlet weak var direccionVerMas: UILabel!
    @IBOutlet weak var btnQuieroVisitar: UIButton!
    
    let defaults = UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storageReference = Storage.storage().reference()
        nombreVerMAs.adjustsFontSizeToFitWidth = true
        nombreVerMAs.lineBreakMode = .byCharWrapping
        direccionVerMas.adjustsFontSizeToFitWidth = true
        direccionVerMas.lineBreakMode = .byCharWrapping
        
        nombreVerMAs.text = datosPropiedad.nombre
        tipoPropVerMas.text = datosPropiedad.tipo_propiedad
        tipoOperVerMas.text = datosPropiedad.tipo_operacion
        habitacionesVerMas.text = String(datosPropiedad.habitaciones)
        banosVerMas.text = String(datosPropiedad.banos)
        garageVerMas.text = String(datosPropiedad.garages)
        amuebladoVerMas.text = datosPropiedad.amueblado
        direccionVerMas.text = datosPropiedad.direccion
        precioVerMas.text = String(datosPropiedad.precio)
        
        let arrProps = self.defaults.stringArray(forKey: "PropiedadesArray") ?? [String]()
        for elementosPropiedades in arrProps{
            if datosPropiedad.id_Propiedad == elementosPropiedades{
                btnQuieroVisitar.isEnabled = false
                btnQuieroVisitar.setTitle("Por Visitar", for: .normal)
            }
            else{
                btnQuieroVisitar.isEnabled = true
                btnQuieroVisitar.setTitle("Quiero Visitar !", for: .normal)
            }
        }
        
        let userImageRef = storageReference.child("/fotosProps/\(datosPropiedad.id_Propiedad).jpg")
        
        userImageRef.downloadURL { (url, error) in
        if let error = error{
            print(error.localizedDescription)
        }else{
            print("imagen descargada")
            }
        }
        
        imgPropVerMAs?.sd_setImage(with: userImageRef)
        self.performSegue(withIdentifier: "updateProp", sender: self)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: "updateProp", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func backVerMas(_ sender: Any) {
        self.performSegue(withIdentifier: "updateProp", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func quieroVisitar(_ sender: Any) {
        
        let idPropiedad = datosPropiedad.id_Propiedad
        var arrProps = self.defaults.stringArray(forKey: "PropiedadesArray") ?? [String]()
        defaults.removeObject(forKey: "PropiedadesArray")
        
        // PUEDE SER UNA CLASE / CONTROLLER
        if arrProps.count != 0{
            for elementosPropiedades in arrProps{
                if idPropiedad != elementosPropiedades{
                    arrProps.append(idPropiedad)
                    defaults.set(arrProps, forKey: "PropiedadesArray")
                }
            }
                
        }
        else{
            arrProps.append(idPropiedad)
            defaults.set(arrProps, forKey: "PropiedadesArray")
        }
        self.performSegue(withIdentifier: "updateProp", sender: self)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    

}
