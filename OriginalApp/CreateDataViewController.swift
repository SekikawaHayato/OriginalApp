//
//  CreateDataViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit

class CreateDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    @IBAction func backMainController(){
        dismiss(animated: true, completion: nil)
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
