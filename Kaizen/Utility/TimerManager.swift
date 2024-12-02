//
//  TimerManager.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import Foundation

class TimerManager {
    static let shared = TimerManager()

    // Time interval value updated every second.
    private(set) var currentTime: Date = Date()
    private var timer: Timer?

    private init() {}

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
            NotificationCenter.default.post(name: .timeUpdated, object: nil)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension Notification.Name {
    static let timeUpdated = Notification.Name("timeUpdated")
}
