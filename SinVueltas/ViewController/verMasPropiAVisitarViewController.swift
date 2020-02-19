//
//  verMasPropiAVisitarViewController.swift
//  SinVueltas
//
//  Created by Jose Olvera on 03/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI


class verMasPropiAVisitarViewController: UIViewController {
    
    var datosPropiedad: propiedades!
    var storageReference: StorageReference!
    
    @IBOutlet weak var imgPropVerMAsPropAVisitar: UIImageView!
    @IBOutlet weak var nombreVerMAsPropAVisitar: UILabel!
    @IBOutlet weak var tipoPropVerMasPropAVisitar: UILabel!
    @IBOutlet weak var tipoOperVerMasPropAVisitar: UILabel!
    @IBOutlet weak var habitacionesVerMasPropAVisitar: UILabel!
    @IBOutlet weak var banosVerMasPropAVisitar: UILabel!
    @IBOutlet weak var garageVerMasPropAVisitar: UILabel!
    @IBOutlet weak var precioVerMasPropAVisitar: UILabel!
    @IBOutlet weak var amuebladoVerMasPropAVisitar: UILabel!
    @IBOutlet weak var direccionVerMasPropAVisitar: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageReference = Storage.storage().reference()
        nombreVerMAsPropAVisitar.adjustsFontSizeToFitWidth = true
        nombreVerMAsPropAVisitar.lineBreakMode = .byCharWrapping
        direccionVerMasPropAVisitar.adjustsFontSizeToFitWidth = true
        direccionVerMasPropAVisitar.lineBreakMode = .byCharWrapping
        
        
        nombreVerMAsPropAVisitar.text = datosPropiedad.nombre
        tipoPropVerMasPropAVisitar.text = datosPropiedad.tipo_propiedad
        tipoOperVerMasPropAVisitar.text = datosPropiedad.tipo_operacion
        habitacionesVerMasPropAVisitar.text = String(datosPropiedad.habitaciones)
        banosVerMasPropAVisitar.text = String(datosPropiedad.banos)
        garageVerMasPropAVisitar.text = String(datosPropiedad.garages)
        amuebladoVerMasPropAVisitar.text = datosPropiedad.amueblado
        direccionVerMasPropAVisitar.text = datosPropiedad.direccion

        // Do any additional setup after loading the view.
        
        let userImageRef = storageReference.child("/fotosProps/\(datosPropiedad.id_Propiedad).jpg")
        
        userImageRef.downloadURL { (url, error) in
        if let error = error{
            print(error.localizedDescription)
        }else{
            print("imagen descargada")
            }
        }
        
        imgPropVerMAsPropAVisitar?.sd_setImage(with: userImageRef)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func back_btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
