//
//  AlarmCOntroller .swift
//  Alarm
//
//  Created by Erik HARTLEY on 1/20/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation

class AlarmController {
    
    static var sharedAlarm = AlarmController()
    
    var alarms = [Alarm]()
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) {
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        
    }
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
    }
    func delete(alarm: Alarm) {
        guard let alarm = alarms.index(of: alarm) else { return }
        alarms.remove(at: alarm)
    }
    
    init() {
        let alarm1 = Alarm(fireTimeFromMidnight: 10, name: "alarm1")
        let alarm2 = Alarm(fireTimeFromMidnight: 20, name: "alarm2")
        let alarm3 = Alarm(fireTimeFromMidnight: 30000, name: "alarm3")
        self.alarms = [ alarm1, alarm2, alarm3 ]
    }
    
    func toggleEnabled(for alarm: Alarm) {
      alarm.enabled = !alarm.enabled
    }
    
}
