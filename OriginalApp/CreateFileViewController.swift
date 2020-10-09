//
//  CreateFileViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/08.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit

class CreateFileViewController: UIViewController {
    
    var realmService: RealmService!
    @IBOutlet var fileNameTextField: UITextField!
    
    override func viewDidLoad() {
        realmService = RealmService.shared
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0 ,blue: 0, alpha: 0.7)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backMainController(){
        back()
    }
    
    @IBAction func createFileButton(){
        if fileNameTextField.text != "" {
            let variableDataGroup = VariableDataGroup()
            variableDataGroup.fileName = fileNameTextField.text!
            let variableData = VariableData()
            variableData.variableName = "newObject"
            variableData.mold = .STRING
            variableDataGroup.variableDataList.append(variableData)
            realmService.create(variableDataGroup)
            
            updateViewController()
            back()
        }
    }
    
    func back(){
        dismiss(animated: true, completion: nil)
    }
    
    func updateViewController(){
        let parentVC = self.presentingViewController as! ViewController
        parentVC.updateView()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
