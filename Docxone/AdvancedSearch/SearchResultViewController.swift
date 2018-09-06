//
//  SearchResultViewController.swift
//  Docxone
//
//  Created by Apple on 16/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class SearchResultViewController: UIViewController {

    // MARK: - IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var searchResultArr = NSArray()
    let kCellIdentifier = "cell"
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         tableView.tableFooterView = UIView()
        print(searchResultArr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
 // MARK: - Extension
extension SearchResultViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! SearchResultTableViewCell
         cell.lblName.text = (((self.searchResultArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
         cell.lblUrl.text = (((self.searchResultArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String)
         cell.lblModifyBy.text = (((self.searchResultArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "modifiedby") as! String)
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate {
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 30
   // }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        fetchUrlForWebview(urlPAth: (((self.searchResultArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String))
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
