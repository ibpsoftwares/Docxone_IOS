//
//  ClientViewController.swift
//  Docxone
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class ClientViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
     @IBOutlet var shadowView: UIView!
     @IBOutlet var btnSearch: UIButton!
    let kCellIdentifier = "cell"
    var getClientArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getClientAPI()
        shadowView.layer.cornerRadius = 2.0
         btnSearch.layer.cornerRadius = 2.0
       shadowView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: getClientAPI Methods
    func getClientAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain
        ]
        
        print(parameters)
        Webservice.apiPost(serviceName: "getclients", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            
            print(response!)
            self.getClientArr =  (response?.value(forKey: "data") as! NSArray)
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
                self.tableView.reloadData()
            })
        }
    }
    @IBAction func btnAdvancedSearch(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdvancedSearchViewController") as! AdvancedSearchViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
}
extension ClientViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getClientArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! ClientTableViewCell
        if (indexPath.row % 2 == 0)
        {
           cell.backgroundColor = UIColor.white
        }
        else{
            cell.backgroundColor = UIColor(red: 201/255.0, green: 221/255.0, blue: 227/255.0, alpha: 1)
        }
        cell.lblName.text = (((self.getClientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Title") as! String)
        return cell
    }
}

extension ClientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selctClientVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectClientViewController") as! SelectClientViewController
        selctClientVC.clientID = (((self.getClientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Id") as! String)
        selctClientVC.rootFolder = (((self.getClientArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "rootFolderPath") as! String)
        self.navigationController?.pushViewController(selctClientVC, animated: true)
    }
}
extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
