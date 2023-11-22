//
//  PostagemViewController.swift
//  Instagram
//
//  Created by Enzo on 19/11/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PostagemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    var auth: Auth!
    var firestore: Firestore!
    var idUsuario: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firestore = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        imagePicker.delegate = self
    }
    
    @IBAction func selecionarImagem(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imagem.image = imagemRecuperada
    
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    // Salvar imagens
    
    @IBAction func salvarPostagem(_ sender: Any) {
    
        let imagens = storage.reference().child("imagens")
        
        
       let imagemSelecionada = self.imagem.image
        if let imagemUpload = imagemSelecionada?.jpegData(compressionQuality: 0.3) {
            
            let identificadorUnico = UUID().uuidString
                        
                        let imagemPostagemRef = imagens
                            .child("postagens")
                            .child("\(identificadorUnico).jpg")
                        
                        imagemPostagemRef.putData(imagemUpload, metadata: nil) { (metaData, erro) in
                        if erro == nil {
                                
                            imagemPostagemRef.downloadURL { (url, erro) in
                                    if let urlImagem = url?.absoluteString {
                                        if let descricao = self.descricao.text {
                                           if let usuarioLogado = self .auth.currentUser {
                                                
                                                let idUsuario = usuarioLogado.uid
                                                
                                                self.firestore.collection("postagem")
                                                    .document(idUsuario)
                                                    .collection("postagem_usuario")
                                                    .addDocument(data: ["descricao" : descricao,
                                                                        "url": urlImagem
                                                                       ]) { (erro) in
                                                        if erro == nil {
                                                            self.navigationController?.popViewController(animated: true)
                                                        }
                                                    }
                                            }
                                    }
                                   }
                                }

                                print("Sucesso")
                            }else{
                                print("Erro ao fazer upload")
                            }
                        }
                    }
                }
                
            }

