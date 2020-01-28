//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Marcello Pontes Domingos on 21/01/20.
//  Copyright © 2020 BRQ. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var senhaConfirmacao: UITextField!
    
    func exibirMensagem(titulo: String, mensagem: String){
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func criarConta(_ sender: Any) {
        if let emailR = self.email.text{
            if let nomeR = self.nome.text{
                if let senhaR = self.senha.text{
                    if let senhaConfirmacaoR = self.senhaConfirmacao.text{
                        
                        //validar senha
                        if senhaR == senhaConfirmacaoR{
                            
                            if nomeR != ""{
                                
                                //cria conta no firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                                    
                                    if erro == nil{
                                        if usuario == nil{
                                            self.exibirMensagem(titulo: "Erro", mensagem: "Tente novamente")
                                        }else{
                                            
                                            let database = Database.database().reference()
                                            let usuarios = database.child("usuarios")
                                            
                                            let usuarioDados = ["nome": nomeR, "email": emailR]
                                            usuarios.child(usuario!.user.uid).setValue(usuarioDados)
                                            
                                            //redirecionando tela
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                        }
                                    }else{
                                        
                                        let erroR = erro! as NSError
                                        if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"]{
                                            let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            
                                            switch erroTexto {
                                            case "ERROR_INVALID_EMAIL":
                                                mensagemErro = "email invalido, digite novamente"
                                                break
                                            case "ERROR_WEAK_PASSWORD":
                                                mensagemErro = "senha fraca, digite novamente"
                                                break
                                            case "ERROR_EMAIL_ALREADY_IN_USE":
                                                mensagemErro = "email ja esta sendo usado, digite novamente"
                                                break
                                            default:
                                                mensagemErro = "dados incorretos, digite novamente"
                                            }
                                            
                                            self.exibirMensagem(titulo: "Dados incorretos", mensagem: mensagemErro)
                                        }
                                    }//fim validacao firebase
                                }
                            }else{
                                self.exibirMensagem(titulo: "nome vazio", mensagem: "digite novamente")
                            }
                        }else{
                            self.exibirMensagem(titulo: "dados incorretos", mensagem: "senhas diferentes, digite novamente")
                        }//fim validacao senha
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
