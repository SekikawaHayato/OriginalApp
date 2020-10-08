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
    dynamic var variableName = ""
    
    // 中身
    dynamic var variableValue = ""
    
    let variableList = List<VariableData>()
    
    // 型を識別する
    @objc private dynamic var moldNameValue = ""
    var mold : moldName{
        get{return moldName(rawValue: moldNameValue) ?? .undefind}
        set{moldNameValue = newValue.rawValue}
    }
    
    enum moldName: String{
        case INT
        case STRING
        case FLOAT
        case OBJECT
        case ARRAY
        case undefind
    }
    
    convenience init(variableName: String,variableValue: String,moldNameValue: String){
        self.init()
        self.variableName = variableName
        self.variableValue = variableValue
        self.moldNameValue = moldNameValue
    }
}

@objcMembers class VariableDataGroup: Object{
    dynamic var fileName = ""
    var variableData = List<VariableData>()
    
    convenience init(fileName: String){
        self.init()
        self.fileName = fileName
    }
}
