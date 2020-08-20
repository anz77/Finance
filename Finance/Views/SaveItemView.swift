//
//  SaveItemView.swift
//  Finance
//
//  Created by Andrii Zuiok on 17.08.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI
import Combine

struct SaveItemView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @ObservedObject var viewModel: DetailChartViewModel
    
    @Binding var storeSymbolToListMode: Bool
    
    //@State var createNewListMode: Bool = false
    
    @State var textForListName: String = "List"
    
    
    @State var keyboardYOffset: CGFloat = 0
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 30) {
                Spacer()
                
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Create List:")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemGray))
                    
                    Spacer().frame(height: 30)
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        TextField("Enter text", text: self.$textForListName, onEditingChanged: { boolValue in}) {}
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        //.background(Color(.secondarySystemFill))
                        .frame(width: 200)
                        
                        Spacer()
                        
                        Button(action: {
                            
                            guard let symbol = self.viewModel.symbol else {return}
                            
                            var index: Int = 0
                            
                            if let i = self.mainViewModel.symbolsLists.firstIndex(where: { $0.name == self.textForListName}) {
                                index = i
                                self.mainViewModel.symbolsLists[index].symbolsArray.append(symbol)
                            } else {
                                self.mainViewModel.symbolsLists.insert(SymbolsList(name: self.textForListName, symbolsArray: [symbol], isActive: true), at: index)
                            }
                                                        
                            self.mainViewModel.addNewModelWithSimbol(symbol, from: self.viewModel, toListWithIndex: index)
                            
                            self.storeSymbolToListMode.toggle()
                            
                        }) {
                            Text("Save")
                        }
                        
                    }
                    
                }
                
                Spacer().frame(height: 30)
                
                if mainViewModel.symbolsLists.count > 0 {
                    Text("Save item into List:")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemGray))
                    
                    ForEach(self.mainViewModel.symbolsLists, id: \.id) { list in
                        
                        Button(action: {
                            
                            guard let symbol = self.viewModel.symbol else {return}
                            
                            guard let index = self.mainViewModel.symbolsLists.firstIndex(where: { $0.id == list.id}) else {return}
                            
                            self.mainViewModel.symbolsLists[index].symbolsArray.append(symbol)
                            
                            self.mainViewModel.addNewModelWithSimbol(symbol, from: self.viewModel, toListWithIndex: index)
                            
                            self.storeSymbolToListMode.toggle()
                            
                        }) {
                            Text(list.name)
                                .font(.body)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Spacer()
                .frame(height: 30)
                
            }
            .padding([.leading, .trailing], 30)
            
            
        }//.onKeyboard($keyboardYOffset)
        
        
    }
}


extension View {
    func onKeyboard(_ keyboardYOffset: Binding<CGFloat>) -> some View {
        return ModifiedContent(content: self, modifier: KeyboardModifier(keyboardYOffset))
    }
}

struct SaveItemView_Previews: PreviewProvider {
    static var previews: some View {
        SaveItemView(viewModel: DetailChartViewModel(withJSON: "AAPL"), storeSymbolToListMode: .constant(true)).environmentObject(MainViewModel(from: "AAPL"))
    }
}



struct KeyboardModifier: ViewModifier {
    @Binding var keyboardYOffset: CGFloat
    let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    init(_ offset: Binding<CGFloat>) {
        _keyboardYOffset = offset
    }

    func body(content: Content) -> some View {
        return content.offset(x: 0, y: -$keyboardYOffset.wrappedValue)
            .animation(.easeInOut(duration: 0.33))
            .onReceive(keyboardWillAppearPublisher) { notification in
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }
                    .first

                let yOffset = keyWindow?.safeAreaInsets.bottom ?? 0

                let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero

                self.$keyboardYOffset.wrappedValue = keyboardFrame.height - yOffset
        }.onReceive(keyboardWillHidePublisher) { _ in
            self.$keyboardYOffset.wrappedValue = 0
        }
    }
}
