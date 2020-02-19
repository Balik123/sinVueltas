//
//  celdaPropiedadesTableViewCell.swift
//  SinVueltas
//
//  Created by Jose Olvera on 31/01/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import UIKit

class celdaPropiedadesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProp: UIImageView!
    @IBOutlet weak var nombreProp: UILabel!
    @IBOutlet weak var tipoProp: UILabel!
    @IBOutlet weak var tipo_oper: UILabel!
    @IBOutlet weak var habitaciones: UILabel!
    @IBOutlet weak var banos: UILabel!
    @IBOutlet weak var garages: UILabel!

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nombreProp.adjustsFontSizeToFitWidth = true
        nombreProp.lineBreakMode = .byCharWrapping

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
