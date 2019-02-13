//
//  ViewController.swift
//  Materna
//
//  Created by Malek Kabaha on 22/02/2018.
//  Copyright © 2018 Malekk. All rights reserved.
//

import UIKit
//
import Firebase



class ViewController: UITableViewController  {
    
    
    var mUser = Auth.auth().currentUser
    
    
    func getDAtaAsUser(){
        
        if Auth.auth().currentUser == nil {
            self.cleanUserDuflts()
        }
        
        var userName: String = ""
        
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "auth") == nil {
            //  Doesn't exist
            userName = ""
        } else {
            userName = preferences.string(forKey: "auth")!
        }
        
        getDataArry("allProdacts")
        
//        if ( userName == "manager"){
//            getDataArry("allProdacts")
//        }
//
//        if ( userName == "volunteer"){
//            getDataArry("Deleverd")
//        }
//
//        if ( userName == "storWorker"){
//            getDataArry("unDeleverd")
//        }
//
//        if ( userName == "" ){
//            getDataArry("")
//        }
//
        
        
    }
    
    
    @IBAction func searchBtn(_ sender: UIBarButtonItem) {
        
        var id = ""
        var alert = UIAlertController(title: "Enter the product ID", message: "", preferredStyle: .alert)
        
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Product ID"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            id = alert.textFields![0].text as! String
            
            self.searchForPushID(id)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) in
            self.getDAtaAsUser()
        }))
        
        
        present(alert, animated: true, completion: nil)
    }//searchBtn
    
    
    @IBAction func sideMenuBtn(_ sender: UIBarButtonItem) {
        sideMenu()
    }
    
    func searchForPushID(_ id: String){
        
        for i in self.itemsArry {
            if (i["deliveryID"] as! String == id){
                self.itemsArry.removeAll()
                self.itemsArry.append(i)
                print("found!: \(self.itemsArry)")
                
                self.tableView.reloadData()
                return
            }//if
        }//for
        
        // no data have been found
        var alert = UIAlertController(title: "no such product", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel ))
        self.getDAtaAsUser()
        present(alert, animated: true, completion: nil)
        
        
    }//search
    
    func sideMenu () {
        let alert = UIAlertController(title: "Filter", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "unDeleverd", style: .default, handler: {
            (action) in
            self.getDataArry("unDeleverd")
        }))
        
        alert.addAction(UIAlertAction(title: "Delevred", style: .default, handler: {
            (action) in
            self.getDataArry("Deleverd")
        }))
        
        alert.addAction(UIAlertAction(title: "All products", style: .default, handler: {
            (action) in
            self.getDataArry("allProdacts")
            self.tableView.reloadData()
        }))
        
        
        alert.addAction(UIAlertAction(title: "sent products", style: .default, handler: {
            (action) in
            self.getDataArry("sent")
        }))
        
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { (action) in
            self.getDAtaAsUser()
        }))
        
        alert.addAction(UIAlertAction(title: "🔙", style: .default ))
        
        present(alert, animated: true, completion: nil)
        
    }//sideMenu
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        getDAtaAsUser()
        
        
    }
    
    var section = 0
    
    @IBAction func infoBtn(_ sender: UIButton) {
        
        var name: String = "Name: \(self.itemsArry[self.section]["fullName"] as! String)"
        var phone: String = "Phone: \(self.itemsArry[self.section]["phone"] as! String)"
        var delevary: String = "Sent As: \(self.itemsArry[self.section]["delevry"] as! String)"
        var adress: String = "Adress: \(self.itemsArry[self.section]["adress"] as! String)"
        
        var message: String = "\(name)\n\(phone)\n\(delevary)\n\(adress)"
        
        var alert = UIAlertController(title: "Contact info", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "✔️", style: .default , handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func showAuth(textField: UITextField) {
        getData(presentedViewController as! UIAlertController)
        print("XXX")
        var alert = UIAlertController(title: "Choose the user Auth! ", message: "user wiil be Approved by Manager", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "AMOTA Manager", style: .default, handler: { (action) in
            self.auth = "manager"
            self.signUpUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Volunteer", style: .default, handler: { (action) in
            self.auth = "volunteer"
            self.signUpUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Stror Worker", style: .default, handler: { (action) in
            self.auth = "storWorker"
            self.signUpUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ,  handler: { (action) in
            self.signUpUser()
        }))
        
        
        
        
        
        
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        } else{
            self.dismiss(animated: false) { () -> Void in
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }//Auth show
    
    func logInUser() {
        
        let alert = UIAlertController (title: "LogIn", message: "enter Youer userName and pass ", preferredStyle: .alert )
        
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        
        
        subview.backgroundColor = UIColor.green

        
        let login = UIAlertAction (title: "Login", style: .default , handler: { (action) -> Void in
            
            var user = alert.textFields![0].text
            var pass = alert.textFields![1].text
            Auth.auth().signIn(withEmail: user!, password: pass!) {
                user , error in
                if error != nil {
                    var alert =  UIAlertController(title: "Oop's❗️", message: error?.localizedDescription as! String, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default ))
                    
                    self.present(alert, animated: true, completion: nil)
                }//IF
                
            }//Auth.signin
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default , handler: { (action) -> Void in })
        
        
        
        alert.addTextField { (userTF: UITextField) in
            userTF.placeholder = "User Name"
            userTF.backgroundColor = UIColor.blue
            userTF.borderStyle = .roundedRect
        }
        
        alert.addTextField { (passTF: UITextField) in
            passTF.isSecureTextEntry = true
            passTF.placeholder="Pass"
        }
        
        alert.addAction(UIAlertAction(title: "SignUp", style: .default, handler: { (action) -> Void in
            self.signUpUser()
        }))
        
        
        alert.addAction(login)
        alert.addAction(cancel)
        
//        present(alert, animated: true, completion: nil)
    } // logInUser
    
    
    var name = ""
    var lName = ""
    var phone = ""
    var email = ""
    var auth = ""
    var passW = ""
    
    func getData (_ alertSU: UIAlertController){
        
        self.name = alertSU.textFields![0].text!
        self.lName = alertSU.textFields![1].text!
        self.phone = alertSU.textFields![2].text!
        self.email = alertSU.textFields![3].text!
        self.passW = alertSU.textFields![4].text!
        self.auth =  alertSU.textFields![4].text!
    }
    
    func signUpUser () {
        
        var alertSU = UIAlertController (title: "SignUP", message: "", preferredStyle: .alert)
        
        alertSU.addTextField(configurationHandler: { (nameTF:UITextField) in
            if (self.name != ""){
                nameTF.text = self.name
            }else{
                nameTF.placeholder = "שם" }
            
            if nameTF.endEditing(true){
                self.name = nameTF.text!
            }
        })
        
        alertSU.addTextField(configurationHandler: { (lName:UITextField) in
            if self.lName != "" {
                lName.text = self.lName
            }
            lName.placeholder="שם משפחה"
        })
        
        alertSU.addTextField(configurationHandler: { (phoneTF:UITextField) in
            if ( self.phone != ""){
                phoneTF.text = self.phone
            }
            phoneTF.placeholder = "טלפון"
            phoneTF.keyboardType = .numberPad
        })
        
        alertSU.addTextField(configurationHandler: { (emailTF:UITextField) in
            if ( self.email != ""){
                emailTF.text = self.email
            }
            emailTF.placeholder="email"
            emailTF.keyboardType = .emailAddress
        })
        
        alertSU.addTextField(configurationHandler: { (newPssTF:UITextField) in
            if ( self.passW != ""){
                newPssTF.text =  self.passW
            }
            newPssTF.placeholder = "pass"
            newPssTF.isSecureTextEntry = true
        })
        
        alertSU.addTextField { (userAuth: UITextField ) in
            if self.auth != "" {
                userAuth.text = self.auth
            }
            else {
                userAuth.placeholder = "user Auth"
                userAuth.addTarget(self, action: #selector(self.showAuth), for: .touchDown)
            } // if auth == nil
        }
        
        alertSU.addAction(UIAlertAction(title: "Done!", style: .default, handler: { (action) -> Void in
            
            var userOb: [String:String] = [:]
            
            Auth.auth().createUser(withEmail: alertSU.textFields![3].text! , password: alertSU.textFields![4].text! ){
                user , error in
                if ( error != nil ){
                    var alert =  UIAlertController(title: "Oop's❗️", message: error?.localizedDescription as! String, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.signUpUser()
                    }))
                    self.getData(alertSU)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                 userOb = ([
                    "name":alertSU.textFields![0].text!  ,
                    "lName":alertSU.textFields![1].text! ,
                    "phone":alertSU.textFields![2].text!,
                    "email":alertSU.textFields![3].text! ,
                    "auth":alertSU.textFields![5].text!
                    ])
                
                if user != nil {
                    Database.database().reference().child("user").child((Auth.auth().currentUser!.uid)).setValue(userOb)
                    
                    var  changer = Auth.auth().currentUser?.createProfileChangeRequest()
                    
                    changer?.displayName = userOb["name"]!
                    print("changer?.displayName = \(userOb["name"]!)")
                    
                    Auth.auth().signIn(withEmail: alertSU.textFields![3].text!, password: alertSU.textFields![4].text!)
                }//if user!=nil
                
            }// handler Creat user
            
            if ( userOb.count > 0  ){
            let preferences = UserDefaults.standard
            preferences.set( userOb["name"] as! String , forKey: "name")
            preferences.set( Auth.auth().currentUser?.uid , forKey: "UID")
            preferences.set( userOb["auth"] , forKey: "auth")
            }
            
        })) // save the signUP (Done Action)
        
        alertSU.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in }))
        
        self.present(alertSU, animated: true, completion: nil )
    }//end signUpUsr
    
    
    @IBAction func loginBtnClick(_ sender: Any) {
        if ( Auth.auth().currentUser == nil) {
            var firstAlert = UIAlertController(title: "This section is for the AMOTA Volnteers! ", message: "", preferredStyle: .alert)
            
            firstAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                self.logInUser()
                self.performSegue(withIdentifier: "loginseguwe", sender: nil)

            }))
            
            present(firstAlert, animated: true, completion: nil)
            
        } // end user== nil
            
            
        else {// user!=null
            
            var userName: String = ""
            
            let preferences = UserDefaults.standard
            
            if preferences.object(forKey: "name") == nil {
                //  Doesn't exist
                userName = ""
            } else {
                userName = preferences.string(forKey: "name")!
            }
            
            var logedInAlert = UIAlertController(title: "Profile", message: "\n\(userName)", preferredStyle: .alert)
            
            
            
            logedInAlert.addAction(UIAlertAction(title: "LogOut", style: .default, handler: { (action) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                
                self.cleanUserDuflts()
                
                self.performSegue(withIdentifier: "vcToFirstSegue", sender: nil)

                //vcToFirstSegue
            })) //logOutAction
            
            logedInAlert.addAction(UIAlertAction(title: "Cancell", style: .cancel, handler: nil))
            
            present(logedInAlert, animated: true, completion: nil)
        }// else user!=nil
    }//logInBtn
    
    func cleanUserDuflts() {
        
        let preferences = UserDefaults.standard
        
        preferences.set( "" , forKey: "name")
        preferences.set( "" , forKey: "UID" )
        preferences.set( "" , forKey: "auth")
        preferences.set("", forKey: "city")
    }
    
    @IBAction func plusOnClick(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "מטרנה",
                                      message: "",
                                      preferredStyle: .alert)
        
        if ( Auth.auth().currentUser == nil){
            Auth.auth().signInAnonymously(completion: {
                (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        }//if user== nil
        var userAuth = ""
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey: "auth") == nil {
            //  Doesn't exist
        } else {
            userAuth = preferences.string(forKey: "auth")!
        }
        
        if userAuth == "manager" {
            
            alert.addAction(UIAlertAction(title: "Add new product barCode", style: .default, handler: { (action) in
                var newAlert = UIAlertController (title: "New Product" , message: "", preferredStyle: .alert)
                
                newAlert.addTextField(configurationHandler: { (barCodeTF: UITextField) in
                    barCodeTF.placeholder = "barCode"
                })
                
                newAlert.addTextField(configurationHandler: { (nameTF: UITextField) in
                    nameTF.placeholder = "Product Name"
                })
                
                newAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    var newProduct: [String:String] = [:]
                    newProduct["barCode"] = newAlert.textFields![0].text!
                    newProduct["productName"] = newAlert.textFields![1].text!
                    Database.database().reference().child("products").child(newProduct["barCode"]!).setValue(newProduct)
                }))
                
                newAlert.addAction(UIAlertAction(title: "Cancel" , style: .cancel))
                
                self.present(newAlert, animated: true, completion: nil)
                
            }))//add product action
        }//if manager
        
        
        
        
        let action1 = UIAlertAction(title: "רוצה לתרום", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "segueToTorem", sender: nil)
        })
        
        
        
        let action2 = UIAlertAction(title: " מבקש תרומה - מעבר לדף הרשמה ", style: .default, handler: { (action) -> Void in
            //self.performSegue(withIdentifier: "segueToMekabel", sender: nil)
            UIApplication.shared.openURL(URL(string: "https://www.2help.org.il/food")!)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }//plusOnClick
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.view.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        getDAtaAsUser()
        print("main")
        
        var val: [String:String] = [:]
        
        if ( Auth.auth().currentUser != nil ){
            Database.database().reference().child("user").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                if (snapshot.exists()) {
                val = snapshot.value as! [String:String]
                let preferences = UserDefaults.standard
                if val != nil {
                    var name = "\(val["name"] as! String)\(val["lName"] as! String)"
                    preferences.set( name as! String , forKey: "name")
                    preferences.set( Auth.auth().currentUser?.uid , forKey: "UID")
                    preferences.set( val["auth"] , forKey: "auth")
                }
                print("val\(val)")
            }
            }, withCancel: { (err) in
                print(err.localizedDescription)
            })
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //TableView
    
    var itemsArry: [[String:Any]] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("arrayB: \(self.itemsArry.count)")
        
        return self.itemsArry.count
    }
    
    func getDataArry (_ child: String){
        
        if child == "" {
            self.itemsArry.removeAll()
            self.tableView.reloadData()
            return
        }
        Database.database().reference().child(child).observeSingleEvent(of: .value, with: {
            snapshot  in
            
            var arr: [[String:Any]] = []
            
            self.itemsArry.removeAll()
            
            for item in snapshot.children  {
                
                var i: DataSnapshot = item as! DataSnapshot
                arr.append(i.value as! [String:Any])
            }//for
            
            print("arrayA: \(self.itemsArry.count)")
            self.itemsArry = arr
            self.tableView.reloadData()
            
            
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.section = indexPath.section
        
        var cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        var item: [String:Any] = [:]
        item = self.itemsArry[indexPath.section]
        
        
        print("**\(self.itemsArry[indexPath.section])")
        print("**it\(item["isDeleverd"])")
        
        if ( item["isDeleverd"] as! String == "false"){
            
            let alert = UIAlertController(title: "Approve product in the system?", message: "product ID: \(self.itemsArry[indexPath.section]["deliveryID"] as! String)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) in
                var ref: DatabaseReference =  Database.database().reference().child("unDeleverd").child(item["deliveryID"] as! String)
                self.itemsArry[indexPath.section]["isDeleverd"] = "true"
                
                ref.removeValue()
                
                Database.database().reference().child("Deleverd").child( item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                
                Database.database().reference().child("allProdacts").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                
                print("**\(self.itemsArry[indexPath.section]["isDeleverd"])")
                self.getDAtaAsUser()
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
            
        } // if is NOT Deleverd
            
        else {
            //if delevred
            
            let alert = UIAlertController(title: "unChick product ?", message: "Are you sure you want to unChick the product?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes, it have never arrived", style: .default, handler: {
                (action) in
                self.itemsArry[indexPath.section]["isDeleverd"] = "false"
                print("**IIIII: \(self.itemsArry[indexPath.section])")
                Database.database().reference().child("unDeleverd").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                Database.database().reference().child("allProdacts").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                Database.database().reference().child("Deleverd").child(item["deliveryID"] as! String).removeValue()
                Database.database().reference().child("sent").child(item["deliveryID"] as! String).removeValue()
                
                
                self.getDAtaAsUser()
                self.tableView.reloadData()
            }))
            
            if ( item["isDeleverd"] as! String == "true"){
            alert.addAction(UIAlertAction(title: "Yes, the product have been given", style: .default, handler: {
                (action) in
                
                self.itemsArry[indexPath.section]["isDeleverd"] = "sent"
                
                Database.database().reference().child("Deleverd").child(self.itemsArry[indexPath.section]["deliveryID"] as! String).removeValue()
                Database.database().reference().child("allProdacts").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                Database.database().reference().child("sent").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                
                
                var al = UIAlertController(title: "Product have been givin", message: "", preferredStyle: .alert)
                al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
                
                self.getDAtaAsUser()
                self.tableView.reloadData()
                self.present(al, animated: true, completion: nil)
            }))
            }// product have been given ( isDeleverd == true )
            
            
          if ( item["isDeleverd"] as! String == "sent"){
            
            alert.addAction(UIAlertAction(title: "Product have been returned/Still in Stor", style: .default, handler: { (action) in
                
                    
                    self.itemsArry[indexPath.section]["isDeleverd"] = "true"
                    
                    Database.database().reference().child("sent").child(self.itemsArry[indexPath.section]["deliveryID"] as! String).removeValue()
                    Database.database().reference().child("allProdacts").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                    Database.database().reference().child("Deleverd").child(item["deliveryID"] as! String).setValue(self.itemsArry[indexPath.section])
                    
                    
                    var al = UIAlertController(title: "Product is back to DB", message: "", preferredStyle: .alert)
                    al.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in }))
                    
                    self.getDAtaAsUser()
                    self.tableView.reloadData()
                    self.present(al, animated: true, completion: nil)
            }))
            }
            
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in }))
            
            present(alert, animated: true, completion: nil)
            
        }// else - unCkeck prodact
        
        
        var infoBtn = cell.viewWithTag(333) as! UIButton
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "listItem" , for: indexPath) as! UITableViewCell
        
        let bottomLayer = CALayer()
        
        //cell.backgroundColor = UIColor(red: 222, green: 222, blue: 222, alpha: 0.8)
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        var idLable = cell.viewWithTag(111) as!UILabel
        var pNameLable = cell.viewWithTag(222) as! UILabel
        var imgV = cell.viewWithTag(444) as! UIImageView
        
        
        
        idLable.text = ("ID: '\(self.itemsArry[indexPath.section]["deliveryID"] as! String)'")
        pNameLable.text = ("Product Name: '\(self.itemsArry[indexPath.section]["prodactName"] as! String)'")
        
        
        if (self.itemsArry[indexPath.section]["isDeleverd"] as! String == "false" ){
            imgV.image = #imageLiteral(resourceName: "icons8-checkmark_filled")
        }
        
        if ( self.itemsArry[indexPath.section]["isDeleverd"] as! String == "true"){
            imgV.image = #imageLiteral(resourceName: "icons8-double_tick_filled")
        }
        
        if ( self.itemsArry[indexPath.section]["isDeleverd"] as! String == "sent"){
            imgV.image = #imageLiteral(resourceName: "icons8-gift")
        }
        
        
        print("****\(self.itemsArry[indexPath.section]["isDeleverd"])")
        
        
        
        return cell 
        
    }
    
    
    
}



