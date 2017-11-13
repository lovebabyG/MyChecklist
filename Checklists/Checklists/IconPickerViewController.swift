//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Yijia Gong on 13/11/17.
//  Copyright © 2017 Zhaofei Yin. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = ["No Icon",
                 "Appointments",
                 "Birthdays",
                 "Chores",
                 "Drinks",
                 "Folder",
                 "Groceries",
                 "Inbox",
                 "Photos",
                 "Trips"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count;
    }
}
