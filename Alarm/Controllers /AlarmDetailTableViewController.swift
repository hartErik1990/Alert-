//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Erik HARTLEY on 1/20/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

   var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    @IBOutlet weak var datePickerLabel: UIDatePicker!
    @IBOutlet weak var textFieldLabel: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        hideKeyboardWhenTappedAround()
        
    }

   // MARK: - Table view data source

   private func updateViews() {
        guard let alarm = alarm, let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            isViewLoaded else {
            enableButton.isHidden = false
            return
        }
    
        datePickerLabel.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        textFieldLabel.text = alarm.name
    
        enableButton.isHidden = false
        if alarm.enabled {
            enableButton.setTitle("Disable", for: UIControlState())
            enableButton.setTitleColor( .white, for: UIControlState())
            enableButton.backgroundColor = .red
        } else {
            enableButton.setTitle("Enable", for: UIControlState())
            enableButton.setTitleColor(.blue, for: UIControlState())
            enableButton.backgroundColor = .white
        }
        self.title = alarm.name

    }
 
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = textFieldLabel.text, let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = datePickerLabel.date.timeIntervalSince(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.sharedAlarm.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
        } else {
            AlarmController.sharedAlarm.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)

        }
        navigationController?.popViewController(animated: true)
    }
 
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else { return }
        AlarmController.sharedAlarm.toggleEnabled(for: alarm)
        enableButton.showsTouchWhenHighlighted = true 

        updateViews()
    }

}