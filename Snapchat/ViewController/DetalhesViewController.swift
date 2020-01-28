//
//  DetalhesViewController.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 22/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesViewController: UIViewController {

    var snap = Snap()
    var tempo = 11
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhe: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detalhe.text = "Carregando ..."
        let url = URL(string: snap.urlImagem)
        
        imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            if erro == nil{
                self.detalhe.text = self.snap.descricao
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    self.tempo = self.tempo-1
                    self.contador.text = String(self.tempo)
                    
                    if self.tempo == 0{
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        let autenticacao = Auth.auth()
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(snap.idImagem).jpg").delete { (erro) in
                if erro == nil {
                    //sucesso ao excluir
                }else{
                    //erro ao excluir
                }
            }
        }
    }
}
