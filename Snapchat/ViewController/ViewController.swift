//
//  ViewController.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 21/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        
//        do {
//            try autenticacao.signOut()
//        } catch {
//            print("erro")
//        }
        
        
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            if let usuarioLogado = usuario{
                self.performSegue(withIdentifier: "initSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }


}

