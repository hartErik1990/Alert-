//
//  AlarmCOntroller .swift
//  Alarm
//
//  Created by Erik HARTLEY on 1/20/18.
//  Copyright © 2018 Erik HARTLEY. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController {
    
    static var sharedAlarm = AlarmController()
    
    var alarms = [Alarm]()
    
    init() {
        loadFromPersistentStorage()
    }
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        saveToPersistentStorage()
        return newAlarm
        
    }
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStorage()
    }
    func delete(alarm: Alarm) {
        guard let alarm = alarms.index(of: alarm) else { return }
        alarms.remove(at: alarm)
        saveToPersistentStorage()
    }
    
//    init() {
//        let alarm1 = Alarm(fireTimeFromMidnight: 10, name: "alarm1")
//        let alarm2 = Alarm(fireTimeFromMidnight: 20, name: "alarm2")
//        let alarm3 = Alarm(fireTimeFromMidnight: 30000, name: "alarm3")
//        self.alarms = [ alarm1, alarm2, alarm3 ]
//    }
     // MARK: - Data Persistence
    
    private static var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let directoryPath = directories.first as NSString? else { return nil }
        return directoryPath.appendingPathComponent("Alarm.plist")
    }
    private func saveToPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
    }
    private func loadFromPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
        self.alarms = alarms
        
    }

    func toggleEnabled(for alarm: Alarm) {
      alarm.enabled = !alarm.enabled
    }
    
}

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}
extension AlarmScheduler {
    
    var identifier: String { return "NotificationID"}
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = " Hey Time is up"
        notificationContent.body = "get of the floor"
        notificationContent.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: identifier, content: notificationContent, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [alarm.uuid])
    }
    
}











