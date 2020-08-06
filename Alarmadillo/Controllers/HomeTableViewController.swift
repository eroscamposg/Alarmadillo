//
//  HomeTableViewController.swift
//  Alarmadillo
//
//  Created by Eros Campos on 8/3/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var groups = [Group]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Groups", style: .plain, target: nil, action: nil)
    }

    func initialSetup() {
        groups.append(Group(name: "Enabled Group", playSound: true, enabled: true, alarms: []))
        groups.append(Group(name: "Disabled Group", playSound: true, enabled: false, alarms: []))
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    //Delete a row and the group
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        groups.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath)
        
        //Obtain the correct group of alarms
        let group = groups[indexPath.row]
        cell.textLabel?.text = group.name
        
        //If its enabled, make its color black, else red
        if group.enabled == true {
            cell.textLabel?.textColor = UIColor.black
        } else {
            cell.textLabel?.textColor = UIColor.red
        }
        
        if group.alarms.count == 1 {
            cell.detailTextLabel?.text = "1 alarm"
        } else {
            cell.detailTextLabel?.text = "\(group.alarms.count) alarms"
        }
        
        return cell
    }
    
    @objc func addGroup(){
        let newGroup = Group(name: "Name this group", playSound: true, enabled: false, alarms: [])
        groups.append(newGroup)
        
        performSegue(withIdentifier: "EditGroup", sender: newGroup)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let groupToEdit: Group
        
        if sender is Group {
            //We were called from addGroup(); use what it sent us
            groupToEdit = sender as! Group
        } else {
            //We were called by a tableviewcell; figure out which group we're attached to send that
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            groupToEdit = groups[selectedIndexPath.row]
        }
        
        //Unwrap our destination from segue
        if let groupViewController = segue.destination as? GroupTableViewController {
            //Gve it whatever group was selected above
            groupViewController.group = groupToEdit
        }
    }
}
