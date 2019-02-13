//
//  LogInController.swift
//  Pro
//
//  Created by Malek Kabaha on 29/01/2019.
//  Copyright © 2019 Malekk. All rights reserved.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signUpBtn2: UIButton!
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    
    @IBAction func signInAction(_ sender: Any) {
        self.login(self.userNameTextFiled.text!, self.passTextField.text!)
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        if self.phoneTF.isHidden {
            self.enableSignUp()
        }
        else {
            self.signUp(self.fullNameTF.text!, self.phoneTF.text!, self.emailTF.text!, self.passTF.text!)
            self.enableSignUp()
        }
    }
    
    @IBAction func signUpBtn2Action(_ sender: Any) {
        if self.phoneTF.isHidden {
            self.enableSignUp()
        }
        else {
        self.signUp(self.fullNameTF.text!, self.phoneTF.text!, self.emailTF.text!, self.passTF.text!)
        self.enableSignUp()
        }
    }
    
    func enableSignUp() {
        let f = self.phoneTF.isHidden
        self.phoneTF.isHidden = !f
        self.fullNameTF.isHidden = !f
        self.emailTF.isHidden = !f
        self.passTF.isHidden = !f
        self.signUpBtn2.isHidden = !f
    }
    
    
    func login(_ user: String , _ pass: String) {
        
        Auth.auth().signIn(withEmail: user, password: pass) {
            user , error in
            if error != nil {
                var alert =  UIAlertController(title: "Oop's❗️", message: error?.localizedDescription as! String, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default ))
                
                self.present(alert, animated: true, completion: nil)
            }//IF
            else {
                self.performSegue(withIdentifier: "log2MainSeg", sender: nil)
            }
            
        }//Auth.signin
   
    }//login
    
    
    func signUp (_ name: Any , _ phone: Any , _ email: Any , _ pass: Any) {
        
        Auth.auth().createUser( withEmail: (email as! String) , password: pass as! String){
            user , error in
            if ( error != nil ){
                var alert1 =  UIAlertController(title: "Oop's❗️", message: error?.localizedDescription as! String, preferredStyle: .actionSheet)
                alert1.addAction(UIAlertAction(title: "OK", style: .default))
                // self.getData(alertSU)
                self.present(alert1, animated: true, completion: nil)
                
            }
            }
        }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
