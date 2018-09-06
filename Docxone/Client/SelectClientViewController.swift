//
//  SelectClientViewController.swift
//  Docxone
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class SelectClientViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print("fbjdhgfjshfjg")
    }
    
     //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var clientID = String()
    var path = String()
    var rootFolder = String()
    var imageName = String()
    var clientArr = NSArray()
    var indexCount = NSInteger()
     var pathArr = NSMutableArray()
    let picker = UIImagePickerController()
    var mg1 = UIImageView()
    let kCellIdentifier = "cell"
    @IBOutlet var shadowView: UIView!
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pathArr.add(rootFolder)
        indexCount = 1
        // Do any additional setup after loading the view.
        getSelectClientAPI()
       
        shadowView.layer.cornerRadius = 2.0
        shadowView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        print(indexCount)
        print( pathArr.count)
         if indexCount == 1{
        self.navigationController?.popViewController(animated: true)
          // indexCount = 0
        }
         else{
            indexCount = indexCount - 1
            pathArr.removeObject(at: indexCount)
        }
       // pathArr.remove(indexCount)
       
       print( pathArr.count)
        print((((pathArr as NSMutableArray).lastObject) as! String))
        if pathArr.count == 0{
         
        }
        else{
            if pathArr.count > 0{
                getSelectClientAPI()
            }
//            rootFolder = ((pathArr as NSMutableArray).object(at: indexCount) as! String)
//            print(rootFolder)
        }
    }
    //MARK: getClientAPI Methods
    func getSelectClientAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print((((pathArr as NSMutableArray).lastObject) as! String))
        let parameters: Parameters = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain,
            "id": clientID,
            "rootFolderPath": (((pathArr as NSMutableArray).lastObject) as! String)
        ]
        
        print(parameters)
        Webservice.apiPost(serviceName: "rootlevelfolders", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            self.clientArr =  (response?.value(forKey: "data") as! NSArray)
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
}
extension SelectClientViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! SelectClientTableViewCell
       cell.lblYear.text = (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
        let aString = (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "dtModified") as! String)
       let toArray = aString.components(separatedBy: "T")
        cell.lblDate.text = toArray[0]
        if String(((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "treeNodeType") as! NSInteger) == "0"{
            cell.img.image = UIImage(named: "folder")
        }
        else{
             cell.img.image = UIImage(named: "file")
        }
        cell.btnPath.tag = indexPath.row
        cell.btnPath.addTarget(self,action:#selector(setPathBtn(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    //MARK: setPath Methods
    @objc func setPathBtn(sender:UIButton!){
        print(sender.tag)
        if sender.imageView?.image == UIImage(named: "unSelect"){
           sender.setImage(UIImage(named: "select"), for: .normal)
        }
        else{
            sender.setImage(UIImage(named: "unSelect"), for: .normal)
        }
    }
    //MARK: Upload Image
     func uploadImage() {
        //addProductAPI()
        //uploadImage()
        let params = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain,
            "destFolderPath": path
                        ] as [String : Any]
        
        //let headers = ["Authorization":"Bearer ZWNvbW1lcmNl"]
        let imageData = UIImageJPEGRepresentation(self.mg1.image!, 0.2)!
        
        let url = "http://192.168.44.2:8090/api/uploadfiles" /* your API url */
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            let now = Date()
            
            let formatter = DateFormatter()
            
            formatter.timeZone = TimeZone.current
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: now)
            print(dateString)
            multipartFormData.append(imageData, withName: "image", fileName: "\(self.imageName)", mimeType: "image/png")
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: nil) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded",response.result.value)
                    if let err = response.error{
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
    //MARK: Select PickerView For Gallery and Camera
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
//        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc"], in: .import)
//        importMenu.delegate = self
//        self.present(importMenu, animated: true, completion: nil)
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageURL.path
        print(imageName!)
        self.imageName = imageName!
        self.mg1.image = pickedImage
        uploadImage()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectClientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rootFolder =  (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String)
        if String(((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "treeNodeType") as! NSInteger) == "1"{
            self.fetchUrlForWebview(urlPAth: (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String))
        }
        else{
            self.pathArr.add(rootFolder)
            indexCount = indexCount + 1
             getSelectClientAPI()
        }
    }
    //MARK: fetchUrlForWebview Methods
    func fetchUrlForWebview(urlPAth: String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain,
            "Tag": "1",
            "rootFolderPath" : urlPAth
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "openfile", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (response?.value(forKey: "status") as? Bool ?? true) {
                let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewViewController") as! WebviewViewController
                addProductVC.urlString = (response?.value(forKey: "data") as! String)
                self.navigationController?.pushViewController(addProductVC, animated: true)
            }
            else{
                
            }
        }
    }
}

