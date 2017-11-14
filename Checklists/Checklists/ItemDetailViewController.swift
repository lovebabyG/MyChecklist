//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Yijia Gong on 07/11/17.
//  Copyright © 2017 Zhaofei Yin. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController,
                             UITextFieldDelegate
{
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dueDate = Date()
    
    var datePickerVisible = false
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn // add this
            item.dueDate = dueDate
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn // add this
            item.dueDate = dueDate
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            showDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView,
                               indentationLevelForRowAt: newIndexPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length > 0 {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor =
                dateCell.detailTextLabel!.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: false)
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
}
