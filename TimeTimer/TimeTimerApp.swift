//
//  TimeTimerApp.swift
//  TimeTimer
//
//  Created by Wayne Dahlberg on 4/19/25.
//

import SwiftUI

@main
struct TimerApp: App {
  @StateObject private var timerManager = TimerManager()
  
  var body: some Scene {
    MenuBarExtra("Timer", systemImage: "clock.badge.fill") {
      TimerView()
        .environmentObject(timerManager)
    }
    .menuBarExtraStyle(.window)
  }
}
