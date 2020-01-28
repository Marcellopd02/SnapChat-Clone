//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 21/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    @IBOutlet weak var texto: UITextField!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var botaoProximo: UIButton!
    
    @IBAction func capturarFoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func enviarSnap(_ sender: Any) {
        self.botaoProximo.isEnabled = false
        self.botaoProximo.setTitle("carregando...", for: .normal)
        self.botaoProximo.backgroundColor = UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        
        //recuperar imagem
        if let imagemSelecionada = foto.image{
            
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.5){
                let imagemR = imagens.child("\(self.idImagem).jpg")
                imagemR.putData(imagemDados, metadata: nil) { (metadados, erro) in
                    if erro == nil{
                        imagemR.downloadURL { (url, erro) in
                            if erro == nil{
                                let URL = url?.absoluteString
                                self.performSegue(withIdentifier: "selecionarUserSegue", sender: URL)
                            }
                            self.botaoProximo.isEnabled = true
                            self.botaoProximo.setTitle("Proximo", for: .normal)
                            self.botaoProximo.backgroundColor = UIColor(displayP3Red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
                        }
                    }else{
                        print("falha up")
                        let alerta = Alerta(titulo: "upload falhou", mensagem: "tente novamente")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUserSegue" {
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            usuarioViewController.descricao = self.texto.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.botaoProximo.isEnabled = false
        self.botaoProximo.backgroundColor = UIColor(displayP3Red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagem = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        foto.image = imagem
        imagePicker.dismiss(animated: true, completion: nil)
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(displayP3Red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
    }
}
