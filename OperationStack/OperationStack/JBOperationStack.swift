//
//  JBOperationStack.swift
//  OpeartionStack
//
//  Created by Jairam Babu on 09/12/23.
//

import Foundation


extension JBOperationStack {
    
    public enum QueuePriority  {
        
        case inStack
        case inQueue
        case individual
        
    }
    
}

public class JBOperationStack  {
    
    private(set) var operations = [JBOperation?]()
    
    private var operationsInProgress = [JBOperation?]()
    public var maxConcurrentOperationCount: Int = 15
    
    let serialQueue = DispatchQueue(label: "com.OpeartionIn.Queue", qos: .background, attributes: .concurrent)
    
    var name : String?
    
    public init(){}
    
    public func addOperation(_ operation:JBOperation?) {
        
        serialQueue.async(flags: .barrier) { [weak self] in
            guard let self , let operation else { return }

            guard  self.operationsInProgress.count < self.maxConcurrentOperationCount else {
                
                switch operation.queuePriorityOperation {
                case .inStack :
                    self.operations.append(operation)
                case .inQueue :
                    self.operations.insert(operation, at: 0)
                case .individual : break
                    
                }
                
                return
            }
            self.operationsInProgress.append(operation)
            self.addOperationInSlot(operation)
            
        }
        
    }
    
    private func addOperationInSlot(_ operation: JBOperation?) {
        
        if  operation?.isExecuting == false, operation?.isFinished == false {
                            
            operation?.completionFinished = { [weak self] operation in
                print("Finished operation from \(String(describing: operation?.index))")
                
                guard let self else { return }
                
                self.serialQueue.async(flags: .barrier) {
                    
                    if let index = self.operationsInProgress.firstIndex(of: operation) {
                        if self.operationsInProgress.count > index {
                            
                            self.operationsInProgress.remove(at: index)
                            print("remove operation from \(String(describing: operation?.index))")
                        
                        }
                        
                        if  let firstObj = self.operations.last as? JBOperation {
                            print("add operation from \(String(describing: operation?.index))")
                            self.operationsInProgress.append(firstObj)
                            self.addOperationInSlot(firstObj)
                            self.operations.removeLast()
                           
                        }
                        
                    }
                    
                }
                
            }
            
            if self.operationsInProgress.count > 0 {
                operation?.start()
            }
            
            
        }else if operation?.isExecuting == true, operation?.isFinished == true {
            
            print("operation not compplete")
            
            self.serialQueue.async(flags: .barrier) { [weak self] in
               
                guard let self else { return }
                
                if let index = self.operationsInProgress.firstIndex(of: operation) {
                    self.operationsInProgress.remove(at: index)
                    print("remove operation from \(String(describing: operation?.index))")
                    
                }
                
                if let index = self.operations.firstIndex(of: operation) {
                    self.operations.remove(at: index)
                }
                
            }
            
        }
        
    }
    
}

// CancelOperation
extension JBOperationStack {
    
   public func cancelAllOperations(){
        
        self.serialQueue.async(flags: .barrier) { [weak self] in
            
            self?.operations.removeAll()
            
            self?.operationsInProgress.forEach({ operation in
                operation?.cancelOperation()
            })
            
            self?.operationsInProgress.removeAll()
        }
    }
    
}


// Progress Operation
extension JBOperationStack {
    
    public func progress(compilationHandler:(_ totalOperation:Int,_ comletedOperation:Int)->()?){
        
        self.serialQueue.sync {
            compilationHandler(self.operations.count,self.operations.count - self.operationsInProgress.count)
        }
    }
    
}
