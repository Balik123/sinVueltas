//
//  celdaUsuarioTableViewCell.swift
//  SinVueltas
//
//  Created by Jose Olvera on 02/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit

class celdaUsuarioTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPropPorVisitar: UIImageView!
    @IBOutlet weak var nombrePropUsuarioRegistrado: UILabel!
    
    @IBOutlet weak var tipoPropiedadPropUsuarioRegistrado: UILabel!
    @IBOutlet weak var tipoOperacionPropUsuarioRegistrado: UILabel!
    @IBOutlet weak var habitacionPropUsuarioRegistrado: UILabel!
    @IBOutlet weak var banosPropUsuarioRegistrado: UILabel!
    @IBOutlet weak var garagePropUsuarioRegistrado: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nombrePropUsuarioRegistrado.adjustsFontSizeToFitWidth = true
        nombrePropUsuarioRegistrado.lineBreakMode = .byCharWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
