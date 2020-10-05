//
//  ViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift

//struct Stack<Element: Equatable>:Equatable{
//    private var internalStrage:[Element] = []
//    var isEmpty: Bool{
//        return peek() == nil
//    }
//
//    init(){}
//    init(_ elements:[Element]){
//        self.internalStrage = elements
//    }
//
//    mutating func push(_ element: Element){
//        self.internalStrage.append(element)
//    }
//
//    @discardableResult
//    mutating func pop() -> Element?{
//        return self.internalStrage.popLast()
//    }
//
//    func peek() -> Element?{
//        return self.internalStrage.last
//    }
//}

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var realm:Realm!
    var results: Results<VariableDataGroup>!
//    // Index番号を保存しておく？
//    var stack: Stack<Int>!
    
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
        
        realm = try! Realm()
        
        if realm.objects(VariableDataGroup.self).count == 0{
            print("Init")
            let firstData = VariableDataGroup()
            firstData.fileName = "sample"
//            let variableData = VariableData()
//            variableData.VariableName = "data01"
//            variableData.mold = .STRING
//            variableData.VariableValue = "sample"
//            firstData.VariableData.append(variableData)
            try! realm.write(){
                realm.add(firstData)
            }
        }

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        results = realm.objects(VariableDataGroup.self)

//        try! realm.write(){
//            realm.delete(results)
//        }
    }
    
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "ModalSegue", sender: nil)
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
        print(results[indexPath.row].fileName)
        //条件分岐
//        if results[indexPath.row].mold.rawValue == ""{
//            //cell.moldImageView.image = UIImage(named: "")
//        }else{
//            //cell.moldImageView.image = UIImage(named: "")
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        if results[indexPath.row].mold.rawValue == ""{
//
//        }
    }
    
    
}
