//
//  SubFolderViewController.swift
//  Docxone
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class SubFolderViewController: UIViewController {

     // MARK: - IBOutlet and VAriables
    @IBOutlet var tableView: UITableView!
    var clientID = String()
     var folderPath = String()
    var clientArr = NSArray()
    let kCellIdentifier = "cell"
     let picker = UIImagePickerController()
    var mg1 = UIImageView()
     // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         getSubFolderAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: getSubFolderAPI Methods
    func getSubFolderAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain,
            "Id": clientID,
            "rootFolderPath": folderPath
        ]
        
        print(parameters)
        Webservice.apiPost(serviceName: "rootlevelsubfolders", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
extension SubFolderViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! SubFolderTableViewCell
        cell.lblName.text = (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
       // cell.lblDate.text = (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "dtModified") as! String)
        let aString = (((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "dtModified") as! String)
        let toArray = aString.components(separatedBy: "T")
        cell.lblDate.text = toArray[0]
        if String(((self.clientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "treeNodeType") as! NSInteger) == "0"{
            cell.img.image = UIImage(named: "folder")
        }
        else{
            cell.img.image = UIImage(named: "file")
        }
        return cell
    }
}

extension SubFolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
        self.navigationController?.pushViewController(addProductVC, animated: true)
    }
}


