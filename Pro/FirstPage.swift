//
//  FirstPage.swift
//  Pro
//
//  Created by Malek Kabaha on 31/01/2019.
//  Copyright © 2019 Malekk. All rights reserved.
//

import UIKit
import Firebase

class FirstPage: UIViewController {
    
    let preferences = UserDefaults.standard


    @IBAction func giveBtn(_ sender: Any) {
        //shoToremSeg
        self.performSegue(withIdentifier: "shoToremSeg", sender: nil)

    }
    
    @IBAction func profileBtn(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(title: "this section is for Amota Volunteers Only! ", message:"" , preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK" , style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "firstToSignUpSegue", sender: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func takeBtn(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://www.2help.org.il/food")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferences.set("", forKey:"city" )

        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "firstToVcSegue", sender: nil)
        }

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
