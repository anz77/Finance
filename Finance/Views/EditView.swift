//
//  EditView.swift
//  Finance
//
//  Created by Andrii Zuiok on 19.06.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import SwiftUI
import UIKit

class EditTableViewController: UIViewController {

    @ObservedObject var mainViewModel: MainViewModel
    var symbolsLists: [SymbolsList]
    var symbolsForDeleting: [String] = []
    var editListsEnabled: Bool = false
    
//MARK: - INIT
    init(mainViewModel: ObservedObject<MainViewModel>) {
        _mainViewModel = mainViewModel
        self.symbolsLists = mainViewModel.wrappedValue.symbolsLists

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - UI
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 100, right: 0)
        tableView.isEditing = true
        //tableView.contentInset.bottom += 40
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func cancel() {
        
        mainViewModel.chartViewModels.forEach{ viewModel in
            viewModel.start()
        }
        
        self.dismiss(animated: true) {}
    }
    
    lazy var saveButton: UIButton = {
        var button = UIButton()
        button.setTitle("Save", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(save), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
    @objc func save() {
        
        if symbolsLists != mainViewModel.symbolsLists {
            mainViewModel.symbolsLists = symbolsLists
        }
        
        for symbol in symbolsForDeleting {
            for index in 0..<mainViewModel.chartViewModels.count {
                if mainViewModel.chartViewModels[index].symbol == symbol {
                    mainViewModel.chartViewModels[index].cancelSubscriptions()
                    mainViewModel.chartViewModels.remove(at: index)
                    break
                }
            }
        }
        
        let files = StorageService.getSymbolsFiles()
        
        for file in files {
            
            var deleteFile = true
            
            for list in mainViewModel.symbolsLists {
                for symbol in list.symbolsArray {
                    if file == symbol + "_FUNDAMENTAL" {
                        deleteFile = false
                        break
                    }
                }
            }
            
            if deleteFile {
                do {
                    try StorageService.removeFile(name: file)
                } catch {
                    switch error {
                    case let error as StorageError:
                        debugPrint(error.errorDescription!)
                    default:
                         debugPrint(error.localizedDescription)
                    }
                }
              
            }
            
        }
        
        mainViewModel.chartViewModels.forEach{ viewModel in
            viewModel.start()
        }
        
        //debugPrint(mainViewModel.chartViewModels.count)
        self.dismiss(animated: true) {}
    }
    
    lazy var editListsButton: UIButton = {
        var button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Edit Lists", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editLists), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func editLists() {
        
        if editListsEnabled == true {
            editListsButton.setTitle("Edit Lists", for: UIControl.State.normal)
            editListsEnabled = false
            tableView.reloadData()
            
        } else {
            editListsButton.setTitle("Edit Symbols", for: UIControl.State.normal)
            editListsEnabled = true
            tableView.reloadData()

        }
    }
    
    lazy var addNewListButton: UIButton = {
        var button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Add New List", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewList), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func addNewList() {
        
        let list = SymbolsList(name: "New List", symbolsArray: [])
        //self.symbolsLists.append(list)
        self.symbolsLists.insert(list, at: 0)
        tableView.reloadData()
    }
    
//MARK: - VIEW LIFECICLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
         tableView.delegate = self
         tableView.dataSource = self
         view.addSubview(tableView)
         NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
             tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
             tableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)])
         
         view.addSubview(cancelButton)
         NSLayoutConstraint.activate([
             cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
             cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)])
         
         view.addSubview(saveButton)
         NSLayoutConstraint.activate([
             saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
             saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
         
         view.addSubview(editListsButton)
         NSLayoutConstraint.activate([
             editListsButton.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 50),
             editListsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
        
        view.addSubview(addNewListButton)
        NSLayoutConstraint.activate([
            addNewListButton.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 50),
            addNewListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)])
     }
        
    enum KeyboardState {
        case unknown, entering, exiting
    }

    func keyboardState(for userInfo: [AnyHashable: Any], in view: UIView?) -> (KeyboardState, CGRect?) {
        var rold = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        var rnew = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        var keyboardState : KeyboardState = .unknown
        var newRect : CGRect? = nil
        if let view = view {
            let coordinateSpace = UIScreen.main.coordinateSpace
            rold = coordinateSpace.convert(rold, to: view)
            rnew = coordinateSpace.convert(rnew, to: view)
            newRect = rnew
            if !rold.intersects(view.bounds) && rnew.intersects(view.bounds) {
                keyboardState = .entering
            }
            if rold.intersects(view.bounds) && !rnew.intersects(view.bounds) {
                keyboardState = .exiting
            }
        }
        return (keyboardState, newRect)
    }
    
    var oldContentInset: UIEdgeInsets = UIEdgeInsets.zero
    var oldIndicatorInset: UIEdgeInsets = UIEdgeInsets.zero
    var oldOffset: CGPoint = .zero
    
    @objc func keyboardShow(_ notification: Notification) {
        debugPrint("keyboardShow")
        let d = notification.userInfo!
        let (state, rnew) = keyboardState(for: d, in: self.view)
        debugPrint(state)

        if state == .entering {
            debugPrint(state)
            self.oldOffset = self.tableView.contentOffset
            self.oldContentInset = self.tableView.contentInset
            self.oldIndicatorInset = self.tableView.verticalScrollIndicatorInsets
        }
        if let rnew = rnew {
            let h = rnew.intersection(self.tableView.bounds).height
            self.tableView.contentInset.bottom = h + 100
            self.tableView.verticalScrollIndicatorInsets.bottom = h + 100
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        debugPrint("keyboardHide")

        let d = notification.userInfo!
        let (state, _) = keyboardState(for: d, in: self.view)
        debugPrint(state)

        if state == .exiting {
            debugPrint(state)
            self.tableView.contentOffset = self.oldOffset
            self.tableView.verticalScrollIndicatorInsets = self.oldIndicatorInset
            self.tableView.contentInset = self.oldContentInset
        }
    }
}

//MARK: - UITEXTFIELDDELEGATE
extension EditTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return true}
        symbolsLists[textField.tag].name = text
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UITableViewDelegate
extension EditTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if !editListsEnabled {
            let element = symbolsLists[sourceIndexPath.section].symbolsArray[sourceIndexPath.row]
            self.symbolsLists[sourceIndexPath.section].symbolsArray.remove(at: sourceIndexPath.row)
            self.symbolsLists[destinationIndexPath.section].symbolsArray.insert(element, at: destinationIndexPath.row)
        } else {
            let element = symbolsLists[sourceIndexPath.row]
            self.symbolsLists.remove(at: sourceIndexPath.row)
            self.symbolsLists.insert(element, at: destinationIndexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if !editListsEnabled {
            switch editingStyle {
            case .delete:
                tableView.performBatchUpdates({
                    self.symbolsForDeleting.append(symbolsLists[indexPath.section].symbolsArray[indexPath.row])
                    symbolsLists[indexPath.section].symbolsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                })
            default: break
            }
        } else {
            switch editingStyle {
            case .delete:
                tableView.performBatchUpdates({
                    for symbol in symbolsLists[indexPath.row].symbolsArray {
                        self.symbolsForDeleting.append(symbol)
                    }
                    symbolsLists.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                })
            default: break
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView(reuseIdentifier: "Header")
        
        if !editListsEnabled {
            let textfield = UITextField()
            textfield.clearButtonMode = .always
            textfield.tag = section
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.delegate = self
            textfield.text = self.symbolsLists[section].name
            headerView.contentView.addSubview(textfield)
            textfield.borderStyle = .roundedRect
            //textfield.keyboardAppearance = .dark
            textfield.returnKeyType = .done
            textfield.enablesReturnKeyAutomatically = true
            textfield.autocorrectionType = .no
            NSLayoutConstraint.activate([
                textfield.topAnchor.constraint(equalTo: headerView.contentView.topAnchor, constant: 0),
                textfield.leadingAnchor.constraint(equalTo: headerView.contentView.leadingAnchor, constant: 15),
                textfield.trailingAnchor.constraint(equalTo: headerView.contentView.trailingAnchor, constant: -15),
                textfield.heightAnchor.constraint(equalToConstant: 30)
            ])
            
        }
        return headerView
    }
    
}


//MARK: - UITableViewDataSource
extension EditTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return editListsEnabled ? 1 : symbolsLists.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editListsEnabled ? symbolsLists.count : symbolsLists[section].symbolsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        if editListsEnabled {
            cell.textLabel?.text = symbolsLists[indexPath.row].name
        } else {
            cell.textLabel?.text = symbolsLists[indexPath.section].symbolsArray[indexPath.row]
        }
        return cell
    }
}


//MARK: - EditView (UIViewControllerRepresentable)
struct EditView: UIViewControllerRepresentable {
    
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var mainViewModel: MainViewModel
    
    func makeUIViewController(context: Context) -> EditTableViewController {
        return EditTableViewController(mainViewModel: _mainViewModel)
    }
    
    func updateUIViewController(_ contentViewController: EditTableViewController, context: Context) {}

}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(mainViewModel: MainViewModel(from: "AAPL"))
    }
}
