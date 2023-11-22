//
//  CadastroViewController.swift
//  Instagram
//
//  Created by Enzo on 15/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CadastroViewController: UIViewController {
    
    
    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    var auth: Auth!
    var firestore: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
    }
    
    
    @IBAction func cadastrar(_ sender: Any) {
        
        if let nome = campoNome.text {
            if let email = campoEmail.text {
                if let senha = campoSenha.text {
                    
                    auth.createUser(withEmail: email, password: senha) { (dadosResultado, erro) in
                        if erro == nil {
                            
                            if let idUsuario = dadosResultado?.user.uid {
                    
                            //salvar dados usuario
                            self.firestore.collection("usuarios")
                                .document(idUsuario)
                                .setData([
                                    "nome": nome,
                                    "email": email
                                ])
                            }
                            print("Sucesso ao cadastrar usuario")
                            
                        }else{
                            print("Erro ao cadaastrar usuario")
                        }
                    }
                    
                }else{
                    print("preencher nome")
                }
            }else{
                print("preencher nome")
            }
        }else{
            print("preencher nome")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?
            .setNavigationBarHidden(false, animated: true)
    }
    
}
