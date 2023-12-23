//
//  ContentView.swift
//  OperationStack
//
//  Created by Jairam Babu on 21/12/23.
//

import SwiftUI

struct ContentView: View {
    
    let viewModel = ViewModel()

    var body: some View {
        
        Spacer()
        VStack {
            Spacer()
            Button("Network Operation cancel") {
                
                viewModel.cancelAllOperation()
            }.padding(10)
           
            Button("Add Stack priority task") {
                
                viewModel.addOperationInStack()
            }.padding(10)
            
            Button("Add In Queue priority task") {
                
                viewModel.addOperationInQueue()
            }.padding(10)
           
            Button("Add Operation Individual task") {
                
                viewModel.addOperationIndividual()
            }.padding(10)
            
            Spacer()
        }
        Spacer()
        
    }
}

#Preview {
    ContentView()
}
