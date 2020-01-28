//
//  Usuario.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 22/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import Foundation

class Usuario{
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String){
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
