//
//  Stack.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/08.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit

struct Stack<Element: Equatable>:Equatable{
    private var internalStrage:[Element] = []
    var isEmpty: Bool{
        return peek() == nil
    }

    init(){}
    init(_ elements:[Element]){
        self.internalStrage = elements
    }

    mutating func push(_ element: Element){
        self.internalStrage.append(element)
    }

    @discardableResult
    mutating func pop() -> Element?{
        return self.internalStrage.popLast()
    }

    func peek() -> Element?{
        return self.internalStrage.last
    }
}

class StackIndex {

    private init(){}
    static let shared = StackIndex()
    var stack = Stack<Int>()
    
    func push(_ add: Int){
        stack.push(add)
    }
    
    func pop() -> Int?{
        return stack.pop()
    }
    
    func peek() -> Int?{
        return stack.peek()
    }
}
