//
//  GroupTableViewController.swift
//  Alarmadillo
//
//  Created by Eros Campos on 8/3/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController, UITextFieldDelegate {

    var group: Group!
    let playSoundTag = 1001
    let enabledTag = 1002
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarm))
        title = group.name
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return group.alarms.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return nothing if we're the first section
        if section == 0 { return "Group Options" }
        
        //If we're still here, it means we're the second section - do we have at least 1 alarm?
        if group.alarms.count > 0 {
            return "Alarms"
        }
        
        //If we're still here we have 0 alarms, so return nothing
        return nil
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.preservesSuperviewLayoutMargins = true
//        cell.contentView.preservesSuperviewLayoutMargins = true
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        group.alarms.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //1. Pass the hard work onto a different method if we are in the header section
            return createGroupCell(for: indexPath, in: tableView)
        } else {
            //2. If we're here, it means we're an alarm, so pull out a right detail cell for display
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetail", for: indexPath)
            
            //3. Pull out the correct alarm from the alarms array
            let alarm = group.alarms[indexPath.row]
            
            //4. Use the alarm to configure the cell, drawing on DateFormatter's localized date parsing
            cell.textLabel?.text = alarm.name
            cell.detailTextLabel?.text = DateFormatter.localizedString(from: alarm.time, dateStyle: .none, timeStyle: .short)
            return cell
        }
    }
    
    //MARK: - TEXT FIELD DELEGATE
    func textFieldDidEndEditing(_ textField: UITextField) {
        group.name = textField.text!
        title = group.name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Unfocus the textfield and makes the keyboard to dissapear
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - CUSTOM FUNCTIONS
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.tag == playSoundTag {
            group.playSound = sender.isOn
        } else {
            group.enabled = sender.isOn
        }
    }
    
    //Similar to addGroup()
    @objc func addAlarm() {
        let newAlarm = Alarm(name: "Name this alarm", caption: "Add an optional description", time: Date(), image: "")
        group.alarms.append(newAlarm)
        
        performSegue(withIdentifier: "EditAlarm", sender: newAlarm)
    }
    
    func createGroupCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            //This is the first cell: editing the name of the group
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableText", for: indexPath)
            
            //Look for the TextField inside the cell...
            if let cellTextField = cell.viewWithTag(1) as? UITextField {
                //...then give it the group name
                cellTextField.text = group.name
            }
            
            return cell
            
        case 1:
            //This is the "PlaySound" cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switch", for: indexPath)
            
            //Look for bot the label and the switch
            if let cellLabel = cell.viewWithTag(1) as? UILabel, let cellSwitch = cell.viewWithTag(2) as? UISwitch {
                //Configure the cell with correct settings
                cellLabel.text = "Play Sound"
                cellSwitch.isOn = group.playSound
                
                //Set the switch up with the playSoundTag tag so know which one was changed later on
                cellSwitch.tag = playSoundTag
            }
            
            return cell
        
        default:
            //If we're anything else, we must be the "Enabled" switch, which is basically the same as the "PlaySound" switch
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switch", for: indexPath)
            
            //Look for bot the label and the switch
            if let cellLabel = cell.viewWithTag(1) as? UILabel, let cellSwitch = cell.viewWithTag(2) as? UISwitch {
                //Configure the cell with correct settings
                cellLabel.text = "Enabled"
                cellSwitch.isOn = group.enabled
                
                //Set the switch up with the playSoundTag tag so know which one was changed later on
                cellSwitch.tag = enabledTag
            }
            
            return cell
        }
    }

    
    //MARK: - SEGUE ACTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let alarmToEdit: Alarm
        
        if sender is Alarm {
            alarmToEdit = sender as! Alarm
        } else {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            alarmToEdit = group.alarms[selectedIndexPath.row]
        }
        
        if let alarmViewController = segue.destination as? AlarmTableViewController {
            alarmViewController.alarm = alarmToEdit
        }
    }
}
