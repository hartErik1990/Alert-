//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Erik HARTLEY on 1/20/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // toggle the alarm
    func switchCellValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedAlarm.alarms[indexPath.row]
        if alarm.enabled == true {
            scheduleUserNotifications(for: alarm)
        } else {
            scheduleUserNotifications(for: alarm)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedAlarm.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell ?? SwitchTableViewCell()
        cell.alarm = AlarmController.sharedAlarm.alarms[indexPath.row]
        cell.delegate = self 
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedAlarm.alarms[indexPath.row]
            AlarmController.sharedAlarm.delete(alarm: alarm)
            cancelUserNotifications(for: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailVC" {
            guard let toAlarmDetailVC = segue.destination as? AlarmDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let alarm = AlarmController.sharedAlarm.alarms[indexPath.row]
            toAlarmDetailVC.alarm = alarm
        }
    }
}

extension UITableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}









