//
//  ViewController.swift
//  ToyStore
//
//  Created by Julio Pascoato on 03/05/24.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var toy: ToyItem?
    
    let collection = "toyStore"
       
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldDonor: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var segmentControlConditionType: UISegmentedControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var buttonAddEdit: UIButton!
    
      
    override func viewDidLoad() {
        super.viewDidLoad()
        if let toy = toy {
            title = "Edição"
            textFieldName.text = toy.name
            textFieldDonor.text = toy.donor
            textFieldAddress.text = toy.address
            textFieldPhoneNumber.text = toy.phoneNumber
            segmentControlConditionType.selectedSegmentIndex = toy.condition
            buttonAddEdit.setTitle("Alterar brinquedo", for: .normal)
            
        }
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
                         
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        
               
        guard let name = textFieldName.text,
              let donor = textFieldDonor.text,
              let address = textFieldAddress.text,
              let phoneNumber = textFieldPhoneNumber.text else {return}
        
        let data: [String: Any] = [
            "name": name,
            "donor": donor,
            "address": address,
            "phoneNumber": phoneNumber,
            "condition": segmentControlConditionType.selectedSegmentIndex
        ]
        
        if let toy = toy {
            Firestore.firestore().collection(self.collection).document(toy.id).updateData(data) { error in
                if error != nil{return}
                self.alert(title: "\(toy.name)", message: "Brinquedo atualizado com sucesso")
            }
            
            
        }else{
            Firestore.firestore().collection(self.collection).addDocument(data: data) { error in
                if error != nil{return}
                self.alert(title: "\(self.textFieldName.text!)", message: "Brinquedo cadastrado com sucesso")
                   
            }
        }
               
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {return}
        
        let bottomMargin = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomMargin
        scrollView.verticalScrollIndicatorInsets.bottom = bottomMargin
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    


}

