//
//  filtrosAplicar.swift
//  SinVueltas
//
//  Created by Jose Olvera on 19/02/20.
//  Copyright © 2020 Jose Olvera. All rights reserved.
//

import Foundation

struct filtrosAplicar: Codable{
    var tipoOperacion: String
    var tipoPropiedad: String
    var habitaciones: Int
    var banos: Int
    var garages: Int
    var amueblado: String
    var precio: Int
    var colonia: String
}
