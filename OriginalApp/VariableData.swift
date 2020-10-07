//
//  VariableData.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/05.
//  Copyright © 2020 関川隼人. All rights reserved.
//

//import Foundation
import RealmSwift

@objcMembers class VariableData: Object {

    // 名前
    dynamic var VariableName = ""
    
    // 中身
    dynamic var VariableValue = ""
    
    let VariableList = List<VariableData>()
    
    // 型を識別する
    @objc private dynamic var MoldNameValue = ""
    var mold : MoldName{
        get{return MoldName(rawValue: MoldNameValue) ?? .undefind}
        set{MoldNameValue = newValue.rawValue}
    }
    
    enum MoldName: String{
        case INT
        case STRING
        case FLOAT
        case OBJECT
        case ARRAY
        case undefind
    }
    
    convenience init(VariableName: String,VariableValue: String,MoldNameValue: String){
        self.init()
        self.VariableName = VariableName
        self.VariableValue = VariableValue
        self.MoldNameValue = MoldNameValue
    }
}

@objcMembers class VariableDataGroup: Object{
    dynamic var fileName = ""
    var VariableData = List<VariableData>()
    
    convenience init(fileName: String){
        self.init()
        self.fileName = fileName
    }
    
}
