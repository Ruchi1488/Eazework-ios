//
//  SearchEmployeeListViewController.swift
//  EazeWork
//
//  Created by Mohit Sharma on 16/12/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import SWActivityIndicatorView
import Alamofire

protocol EmployeeSelectorDelegate {
    func didSelectEmployee(employee: EmpList)
}

class SearchEmployeeListViewController: UIViewController,UISearchBarDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    /// Data Array
    var orignalData: [EmpList]? = [EmpList]()
    ///var delegate
    var empDelegate: EmployeeSelectorDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.backgroundColor = SharedManager.shareData().headerBGColor
        
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.layer.borderWidth = 0
        ///glassIconView
        if let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView {
            glassIconView.image = nil
        }
        
        
        
        //clearButton
        if let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor.lightGray
        }
        tblView.tableFooterView = UIView()
        self.searchBar.becomeFirstResponder()
        self.searchBar.changeSearchBarColor(color: UIColor.white)
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        userSearchText = searchBar.text
        
    }
    
    var userSearchText: String? = "" {
        
        willSet {
            print("About to set status to:  \(newValue)")
        }
        
        didSet {
            if userSearchText != oldValue {
                if let data = userSearchText, data != "" {
                    self.getSearchDetails(data: data)
                }
            }
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func getSearchDetails(data: String)  {
        if Connectivity.isConnectedToInternet() {
            let activityIndicatorView = SWActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.view.addSubview(activityIndicatorView)
            
            activityIndicatorView.lineWidth = 2
            activityIndicatorView.autoStartAnimating = true
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.color = SharedManager.shareData().headerBGColor
            activityIndicatorView.center = self.view.center
            activityIndicatorView.startAnimating()
            let urlPath: String = SharedManager.shareData().base_URL + Constants.FILE_WCF_SERVICE + Constants.LeaveServiceParam
            let constant = Constants()
            
            let param = constant.getLeaveParam(str: data)
            
            Alamofire.request(urlPath, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON { response in
                activityIndicatorView.stopAnimating()
                if let json = response.result.value as? [String: Any] {
                    if let resultData: NSDictionary = json["GetLeaveEmpListResult"] as? NSDictionary {
                        if let leaveEmpsList = resultData["LeaveEmps"] as? NSArray {
                            self.orignalData?.removeAll()
                            
                            if leaveEmpsList.count > 0 {
                                self.errorLbl.isHidden = true
                                //create array
                                for obj in leaveEmpsList {
                                    let empList = EmpList(dict: obj as? NSDictionary)
                                    self.orignalData?.append(empList)
                                }
                            } else {
                                self.errorLbl.isHidden = false
                            }
                            //reload
                            self.tblView.reloadData()
                            //.down keybord
                            self.view.endEditing(true)
                        }
                        
                        
                    }
                }
            }
        } else {
            
            self.showAlertMesg(errorMsg: "Internet connection not available")
        }
    }
    
    func showAlertMesg (errorMsg: String) {
        let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel) { _ in
            
        }
        alert.addAction(ok)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SearchEmployeeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchEmpListTableViewCell") as? SearchEmpListTableViewCell
        let emp = orignalData?[indexPath.section]
        cell?.populateData(name: emp?.Name)
        
        cell?.selectBtn.tag = indexPath.section;
        cell?.selectBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orignalData?.count ?? 0
    }
    
    @objc func buttonTapped(sender : UIButton)
    {
        let btnsendtag:UIButton = sender
        
        if let empList = self.orignalData?[btnsendtag.tag] {
            empDelegate?.didSelectEmployee(employee: empList)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SearchEmployeeListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let empList = self.orignalData?[indexPath.section] {
            empDelegate?.didSelectEmployee(employee: empList)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UISearchBar {
    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
}
