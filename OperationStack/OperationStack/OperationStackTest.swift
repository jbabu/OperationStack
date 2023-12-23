//
//  OperationStackTest.swift
//  OpeartionStack
//
//  Created by Jairam Babu on 09/12/23.
//

import Foundation

var numberOfOperation = 0

class ViewModel {
    
    let stack : JBOperationStack = {
        
        let operation = JBOperationStack()
        operation.maxConcurrentOperationCount = 1
        return operation
        
    }()

    let serialQueue = DispatchQueue(label: "serialQueue")


    func cancelAllOperation() {
        print("OperationStack Operation start ")
        
        self.stack.cancelAllOperations()
        
    }
    
    
   
    func addOperationInQueue(){
        
            
            for _ in 0..<1 {
                
                self.serialQueue.async { [weak self] in
                
                    let operation = JBOperationStack.JBOperation()

                    operation.name = "addOperationInQueue"
                    numberOfOperation += 1
                    
                    operation.index = numberOfOperation
                    operation.queuePriorityOperation = .inQueue
                    operation.completionStartOperation = {  operation in
                        
                        print("****************************************** Queue Operation started \(operation?.index) ******************************************")
                        let randomInt = Int.random(in: 1..<10)
                        sleep(UInt32(randomInt))
                        operation?.completeOperation()
                           
                        
                    }
                    
                    operation.completionFinishedOperation = {  operation in
                        
                        print("****************************************** Queue Operation ended \(operation?.index) ******************************************")
                    }
                   
                    print("******************************************  Operation added in Queue \(operation.index) ******************************************")

                    self?.stack.addOperation(operation)
                    
                }
        
                
               
            }
            
    
    }
    
  
    func addOperationInStack(){
        
            
            for _ in 0..<1 {
                
                self.serialQueue.async { [weak self] in
                 
                    numberOfOperation += 1
                    let operation = JBOperationStack.JBOperation()

                    operation.name = "addOperationInStack"
                   
                   
                                    
                    operation.index = numberOfOperation
                    
                    operation.queuePriorityOperation = .inStack
                    operation.completionStartOperation = {  operation in
                        
                        print("****************************************** Stack Operation started \(operation?.index) ******************************************")
                        let randomInt = Int.random(in: 1..<10)
                        sleep(UInt32(randomInt))
                        operation?.completeOperation()
                           
                        
                    }
                    
                    operation.completionFinishedOperation = {  operation in
                        
                        print("****************************************** Stack Operation ended \(operation?.index) ******************************************")
                    }
                   
                    print("******************************************  Operation added in Stack \(operation.index) ******************************************")
                    self?.stack.addOperation(operation)
                    
                }
            }
            
        
        
    }
    
    func addOperationIndividual(){
        
        
        let operation = JBOperationStack.JBOperation()
        numberOfOperation += 1
        operation.name = "OperationLatest"
        operation.index = numberOfOperation
        operation.queuePriorityOperation = .individual
        operation.completionStartOperation = {  operation in
            
            print("****************************************** Individual Operation started \(operation?.index) ******************************************")
            let randomInt = Int.random(in: 1..<10)
            sleep(UInt32(randomInt))
            operation?.completeOperation()
            
        }
        
        operation.completionFinishedOperation = {  operation in
            
            print("****************************************** Individual Operation ended \(operation?.index) ******************************************")
        }
        
    
        operation.start()
        
        
    }
    
}
    




