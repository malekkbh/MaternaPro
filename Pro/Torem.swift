////
////  Torem.swift
////  Materna
////
////  Created by Malek Kabaha on 22/02/2018.
////  Copyright © 2018 Malekk. All rights reserved.
//
//
import UIKit
import AVFoundation
import CoreLocation
import MapKit
import Firebase
import MessageUI
//import SearchTextField









class Torem: UITableViewController , AVCaptureMetadataOutputObjectsDelegate  , CLLocationManagerDelegate  {
    
    
    @IBAction func bcTf(_ sender: UITextField) {
        
        if(sender.text != nil && sender.text != ""){
            findBarCode(sender.text as! String)}
        print("tf change\(sender.text as! String)")
    }
    
    let preferences = UserDefaults.standard
    
    func findBarCode(_ barCode: String) {
       var val: [String:String] = [:]
        var prodName: String = ""
        let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 4))
        
        let tff = cell!.viewWithTag(5) as! UITextField
                Database.database().reference().child("products").child(barCode).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
                    if ( snapshot.exists()){
            val = snapshot.value as! [String:String]
            
            
            if val != nil {
                tff.text = val["productName"] as! String
                        }}
            else {
                var alert = UIAlertController(title: "NO such barCode", message: "please check the barCode agine , if the barCode is correct,please finish the forum - product will be examined", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    tff.text = ""
                self.present(alert, animated: true, completion: nil)
                
            }
            print("val\(val)")
        }, withCancel: { (err) in
            print("fuck! no data ")
            print(err.localizedDescription)
        })
        
        
        
    }
    

    var adress = ""
    
    //used for barCode reader
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    //
    
    func empty(_ str:String){
        
        var alert = UIAlertController(title: str, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnDoneClick(_ sender: UIBarButtonItem) {
        var lableText = ""
        var tfText = ""
        var ref = Database.database().reference().child("unDeleverd").childByAutoId()
        
        var items: [String:String] = [:]
        
        var cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0))
        var tf = cell?.viewWithTag(2) as! UITextField
       
        if(tf.text == nil || tf.text == "" ){
            return empty("please fill the Adress fild")
        }
        items["adress"] = tf.text
        
        
        
         cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 2))
         var mLable = cell?.viewWithTag(3) as! UILabel
        print ("lable?\(mLable.text)")
        if(mLable.text == "  שיטת משלוח" ){
            return empty("please fill the Delevry fild")
        }
        items["delevry"] = mLable.text
        
        
         cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 3))
         tf = cell?.viewWithTag(4) as! UITextField
        
        if(tf.text == nil || tf.text == "" ){
            return empty("please fill the BarCode fild")
        }
        
        items["barCode"] = tf.text
        
        
        cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 4))
        tf = cell?.viewWithTag(5) as! UITextField
        
        if(tf.text == nil || tf.text == "" ){
            return empty("please fill the Prodact Name fild")
        }
        
        items["prodactName"] = tf.text
        
        
        
        
        cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 5))
        tf = cell?.viewWithTag(6) as! UITextField
        
        if(tf.text == nil || tf.text == "" ){
            items["nots"] = " "
        }
        
        items["nots"] = tf.text
        
        
        cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 6))
        tf = cell?.viewWithTag(7) as! UITextField
        
        if(tf.text == nil || tf.text == "" ){
            return empty("please fill the Name fild")
        }
        
        items["fullName"] = tf.text
        
        
        cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 7))
        tf = cell?.viewWithTag(8) as! UITextField
        
        if(tf.text == nil || tf.text == "" ){
            return empty("please fill the Phone number fild")
        }
        
        items["phone"] = tf.text
        
        
        items["isDeleverd"] = "false"
        
        
        
        
        items["deliveryID"] = ref.key
        
        ref.setValue(items)
        Database.database().reference().child("allProdacts").childByAutoId().setValue(items)

        
        var alert = UIAlertController(title: "מספר פנייה - נא לרשום אותו על החבילה ", message: ref.key , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
            
            var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            indicator.center = self.view.center
            indicator.backgroundColor = UIColor.lightGray
            self.view.addSubview(indicator)
            self.view.bringSubview(toFront: indicator)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            indicator.startAnimating() ;
//
            self.performSegue(withIdentifier: "toremToFirstSeg", sender: nil)

            print("send")

        }))
        print("mmmmmmmmm\(items)")
        

        present(alert, animated: true, completion: nil)
        sendEmail(itemTostring(items))
        
        //toremToFirstSeg

        
    }//Done
    
    
    func yes () {
        
        self.performSegue(withIdentifier: "toremToFirstSeg", sender: nil)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() //+ delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    
    func itemTostring(_ item:[String:String]) -> String {
        
        var name = String(describing: item["fullName"]) as! String
        var phone = String (describing: item["phone"] ) as! String
        var adress = String(describing: item["adress"]) as! String
    
        
        var st:String = ( "DeliveryID: \(item["deliveryID"]! )<br>Name: \((name))<br>Phone: \(phone)<br>Address: \(adress)")
        
        return st != nil ? st : ""
        
        
    }
    
    
    var tag = 0
    var delevary = ["" ,"תרומה בכסף" , "מסירה אישית בנקודת איסוף/מחסן","איסוף עם שליח"]
    var text = "non"
  
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tag = -1
        
        // Do any additional setup after loading the view.
        
      //  view.backgroundColor = UIColor.black
        
      
        
        
       call4Reader()
        
        print("end of bar ")
        
        findLocation()
        print(location.latitude)
        getAddressFromLatLon(pdblLatitude: location.latitude , withLongitude: location.longitude)
        
    }// view did load
    
    //barCodeReader
    
    func call4Reader(){
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return notFound() }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }//call4reader
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return failed()}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        
        let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 2))
        
        let tff = cell!.viewWithTag(4) as! UITextField
        tff.text = code
        
        findBarCode(code)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func notFound(){
        var alert = UIAlertController(title: "UnAble to get data please fill the barcode fild ", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(ok )
        
        present(alert, animated: true, completion: nil)

    }
    
    
    //barCodeReader
    

    
    //location
    
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    func findLocation() {
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            location = locationManager.location!.coordinate
            print("locations = \(location.latitude) \(location.longitude)")

        }else
        {print("no location")}
    
        
    
    }//find location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        location = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        print("getAdress")
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                print("po.count= \(pm.count)")
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    
                    
            
                    self.text = addressString
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0))
                    
                    let tff = cell!.viewWithTag(2) as! UITextField
                    tff.text = self.text
                    
                    print("the adress is : \(addressString)")
                }
                
                

        })
        
    }


    
    //location
    
    
    
    
    
    
    func call4Picker (_ text: String , _ path: IndexPath){
        
        var alert = UIAlertController(title: text , message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert);
        //   alert.isModalInPopover = true;
        
        var pickerFrame: CGRect = CGRect(x: 0, y:52, width: 270, height: 150)
        //   CGRect (17.0, 52.0, 270.0, 100.0 ) // CGRectMake(left), top, width, height) - left and top are like margins
        
        var picker: UIPickerView = UIPickerView(frame: pickerFrame )
        //UIPickerView()
        
        picker.delegate = self;
        picker.dataSource = self;
        
        
        
        picker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        
        alert.view.addSubview(picker);
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        let ok = UIAlertAction(title: "SAVE", style: .destructive, handler: { (action) -> Void in
            
            let cell = self.tableView.cellForRow(at: path)
            
                let label = cell!.viewWithTag(self.tag + 1) as! UILabel
                label.text = self.text
            
        })
        
        
        alert.addAction(cancel)
        alert.addAction(ok)
        //
        present(alert, animated: true, completion: {
            picker.frame.size.width = alert.view.frame.size.width
            
        } )
        
        
        
    }//call4Picker
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   1
        
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell =   tableView.dequeueReusableCell(withIdentifier: "checkListItem\(0)" , for: indexPath) as! UITableViewCell

        
        if( indexPath.section == 1 ) {
            var cell1 =   tableView.dequeueReusableCell(withIdentifier: "checkListItem" , for: indexPath) as! UITableViewCell
            let cityText = cell1.viewWithTag(1230) as! UITextView
            cityText.isUserInteractionEnabled = false 
            if ( preferences.string(forKey: "city") != nil) {
            cityText.text = preferences.string(forKey: "city") as! String
            }
            else {
                cityText.text = ""
            }
            cell1.layer.borderColor = UIColor.darkGray.cgColor
            cell1.layer.borderWidth = 1.3
            cell1.layer.cornerRadius = 20
            cell1.clipsToBounds = true
            return cell1
        }
        
            
        else {
            var section = indexPath.section
            
            if ( indexPath.section != 0 ){
                
                section = (indexPath.section) - 1
            }
            
         cell =   tableView.dequeueReusableCell(withIdentifier: "checkListItem\(section)" , for: indexPath) as! UITableViewCell

        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1.3
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        }
        
        return cell
        }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            tag = indexPath.section
        
        if( tag == 1 ) {
            self.performSegue(withIdentifier: "toremToCitySegue", sender: nil)
        }
        
        if(tag == 2){
            call4Picker("בחר שיטת משלוח" , indexPath)
        }
        
        if( tag == 3 ){
            let cell = self.tableView.cellForRow(at: indexPath )
            
            let tff = cell!.viewWithTag(4) as! UITextField
            tff.text = "3"
            call4Reader()
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension Torem :  UIPickerViewDelegate , UIPickerViewDataSource   {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ( tag == 2 ){
            return delevary.count}
        
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ( tag == 2 ){
            return delevary[row]}
       
        
        
       return "no data !"
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //toremToCitySegue
        
        
        
        
        if ( tag == 2 ){
            text = delevary[row]
            
            if text == "תרומה בכסף" {
                var alert = UIAlertController(title: "Thaks!", message: "giving with mony is throu our serves agents , clik OK to start the call", preferredStyle:  .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (achtion) in
                    if let url = URL(string: "tel://0525998572") {
                        UIApplication.shared.openURL(url)
                    }
                }))
                
                print("hat msare")
            }//if text = mony
            
           
        }//if tage == 2
        
    
       
    }
    
    func sendEmail(_ body:String!){
        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = "smtp.gmail.com"
        smtpSession.username = "malek.kbh@gmail.com"
        smtpSession.password = "malekana"
        smtpSession.port = 465
        smtpSession.authType = MCOAuthType.saslPlain
        smtpSession.connectionType = MCOConnectionType.TLS
        smtpSession.connectionLogger = {(connectionID, type, data) in
            if data != nil {
                if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    NSLog("Connectionlogger: \(string)")
                }
            }
        }
        let builder = MCOMessageBuilder()
        builder.header.to = [MCOAddress(displayName: "Malek", mailbox: "malek.kbh@gmail.com")]
        builder.header.from = MCOAddress(displayName: "Malek", mailbox: "Maretna@gmail.com")
        builder.header.subject = "Test Email"
        builder.htmlBody="<p>\(body!)</p>"
        
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
                
                
            } else {
                NSLog("Successfully sent email!")
                
                
            }
        }
        
    
}//send email
    
    


    
   
}

