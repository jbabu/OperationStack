//
//  JBOperation.swift
//  OpeartionStack
//
//  Created by Jairam Babu on 09/12/23.
//


import UIKit



extension JBOperationStack {
    
    open class JBOperation: Operation, Identifiable {
        
        public var index      : Int = 0
        
        public var id               = UUID()
                
        open var queuePriorityOperation : JBOperationStack.QueuePriority = .inStack
        
        public var completionStartOperation: ((JBOperation?) -> ())?
        
        
        public var completionFinishedOperation: ((JBOperation?) -> ())?
        var completionFinished: ((JBOperation?) -> ())?
        
        
        open override var isAsynchronous: Bool  { return super.isAsynchronous}
        
        fileprivate var _executing = false
        open override var isExecuting: Bool{
            get{
                return _executing
            }
            set{
                if _executing != newValue{
                    self.willChangeValue(forKey: "isExecuting")
                    _executing = newValue
                    self.didChangeValue(forKey: "isExecuting")
                    
                    if _executing {
                        
                        DispatchQueue.global(qos: .background).async {
                            if let completionStartOperation = self.completionStartOperation{
                                completionStartOperation(self)
                            }
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        fileprivate var _finished : Bool = false
        open override var isFinished: Bool{
            get{
                return _finished
            }
            set{
                if _finished != newValue{
                    self.willChangeValue(forKey: "isFinished")
                    _finished = newValue
                    self.didChangeValue(forKey: "isFinished")
                    
                    if _finished {
                        
                        if let completionFinished = self.completionFinished{
                            completionFinished(self)
                        }
                        
                        if let completionFinishedOperation = self.completionFinishedOperation{
                            completionFinishedOperation(self)
                        }
                        
                    }
                    
                }
            }
        }
        
        open func cancelOperation() -> Void{
            self.isExecuting = false
            self.isFinished = true
        }
        
        open func suspendOperation() -> Void{
            self.isExecuting = false
            self.isFinished = true
        }
        
        open func completeOperation() -> Void{
            if self.isExecuting{
                self.isFinished = true
                self.isExecuting = false
                
            }
        }
        
        func resumeOperation() -> Void {
            self.isExecuting = true
        }
        
        open override func start() {
            if isCancelled{
                self.isFinished = true
                return
            }
            self.isExecuting = true
            main()
        }
        
        public override func main() {
            self.resumeOperation()
        }
        
        deinit {
            print("JBNetworkOperation de-initialized \(self.index)")
        }
        
    }

}


