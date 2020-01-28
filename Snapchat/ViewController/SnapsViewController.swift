//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 21/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let autenticacao = Auth.auth()
    var snaps: [Snap] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sair(_ sender: Any) {

        do {
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            //erro
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.observe(DataEventType.childAdded) { (snapshot) in
                let dados = snapshot.value as? NSDictionary
                
                let snap = Snap()
                snap.identificador = snapshot.key
                snap.nome = dados?["nome"] as! String
                snap.descricao = dados?["descricao"] as! String
                snap.urlImagem = dados?["urlImagem"] as! String
                snap.idImagem = dados?["idImagem"] as! String
                
                self.snaps.append(snap)
                self.tableView.reloadData()
            }
            
            snaps.observe(DataEventType.childRemoved) { (snapshot) in
                var indice = 0
                for snap in self.snaps{
                    if snap.identificador == snapshot.key{
                        self.snaps.remove(at: indice)
                    }
                    indice += 1
                }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let totalSnaps = snaps.count
        if totalSnaps == 0{
            return 1
        }
        return totalSnaps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        let totalSnaps = snaps.count
        
        if totalSnaps == 0 {
            celula.textLabel?.text = "Nenhum snap para você 😜"
        }else{
            let snap = self.snaps[indexPath.row]
            celula.textLabel?.text = snap.nome
        }
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalheSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalheSegue"{
            let detalheViewController = segue.destination as! DetalhesViewController
            detalheViewController.snap = sender as! Snap
        }
    }
}
