//
//  ViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var realmService: RealmService!
    var results: Results<VariableDataGroup>!
    // Index番号を保存しておく？
    static var stackIndex: StackIndex!
    
    @IBOutlet var table: UITableView!
    //ファイルの書き出しなどを管理
    let dir = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        
        table.delegate = self
        
        table.rowHeight = 100
        
        realmService = RealmService.shared
        ViewController.stackIndex = StackIndex.shared
        
        if realmService.count(VariableDataGroup.self) == 0{
            let firstData = VariableDataGroup()
            firstData.fileName = "sample"
            let variableData = VariableData()
            variableData.variableName = "data01"
            variableData.mold = .STRING
            variableData.variableValue = "sample"
            firstData.variableData.append(variableData)
            realmService.create(firstData)
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        results = realmService.resultGroup()
        
        //realmService.deleteAll(VariableDataGroup.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
                print("apper")
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("Layout")
    }
    
    @IBAction func button(_ sender: Any) {
        if ViewController.stackIndex.peek() == nil{
            performSegue(withIdentifier: "CreateFileSegue", sender: nil)
        }else{
        performSegue(withIdentifier: "CreateDataSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateDataSegue" {
            let nextVC = segue.destination as! CreateDataViewController
            if ViewController.stackIndex.peek()==nil{
               nextVC.hierarchy = "Top"
            }else{
                nextVC.hierarchy = "During"
                
            }
        }
    }
    // ファイルの書き出し / 上書き保存
    func createFile(fileName: String,text: String){
        // ファイルURLを作成
        let fileUrl = dir.appendingPathComponent(fileName + ".json")
        // ファイルが存在するならば
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            // ファイルの上書き
            do {
                try text.write(to: fileUrl, atomically: false, encoding: .utf8)
            } catch {
                print("Error: \(error)")
            }
        }else{
            // 新しいファイルを作成
            FileManager.default.createFile(
                atPath: fileUrl.path,
                contents: text.data(using: .utf8),
                attributes: nil
            )
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        cell.contentTextLabel.text = results[indexPath.row].fileName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //        if results[indexPath.row].mold.rawValue == ""{
        //
        //        }
    }
    
    func updateView(){
        table.reloadData()
    }
}
