//
//  CityVC.swift
//  Pro
//
//  Created by Malek Kabaha on 13/02/2019.
//  Copyright © 2019 Malekk. All rights reserved.
//

import UIKit

class CityVC: UITableViewController  {

    
    var cityList = [String]()
    
    let myUrl = "https://raw.githubusercontent.com/royts/israel-cities/master/israel-cities.json"

    
    func getJesonFromUrl () {
        
        let url = NSURL(string: myUrl)
        URLSession.shared.dataTask(with: (url as? URL)!) { (data, response, error) in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject] {
            
//            if let jsonObj = try? JSONSerialization.   {
//
            
                //printing the json in console
//                print(jsonObj!.value(forKey: "english_name")!)
                
                print("count \(jsonObj?.count)")
                
                
                //getting the avengers tag array from json and converting it to NSArray
//                if let cityArray = jsonObj[!.value(forKey: "english_name")] as? NSArray {
                    //looping through all the elements
                
                for city in jsonObj!{
                        
                        //converting the element to a dictionary
                        if let cityDict = city as? NSDictionary {
                            
                            //getting the name from the dictionary
                            if  cityDict.value(forKey: "name") as! String != "" || cityDict.value(forKey: "name") as! String != nil {
                                let name = cityDict.value(forKey: "name")
                                //adding the name to the array
                                self.cityList.append((name as? String)!)
                            }
                            
                        }
                    }
//                }
                
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.tableView.reloadData()
                })
            }
        }//res
        .resume()
    }//getJesonFromUrl

        
        
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       getJesonFromUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("count: \(cityList.count)")
        return cityList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.backgroundColor = UIColor.gray
        let cityText = cell.viewWithTag(1) as! UITextView
        
        cell.bounds.size.height = cityText.bounds.size.height + 16
        cityText.frame.size.height = cityText.contentSize.height
        cityText.frame.size.width = cityText.contentSize.width
        cityText.backgroundColor = UIColor.clear
        cityText.isUserInteractionEnabled = false 

        print("city: \(cityList[indexPath.row])")
        
        cityText.text = cityList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let preferences = UserDefaults.standard
        preferences.set(cityList[indexPath.row], forKey: "city")
        self.performSegue(withIdentifier: "cityToToremSegue", sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
