//
//  TimerManager.swift
//  TimeTimer
//
//  Created by Wayne Dahlberg on 4/19/25.
//

import Foundation
import Combine

class TimerManager: ObservableObject {
  // MARK: - Published Properties
  @Published var isRunning = false
  @Published var elapsedSeconds: TimeInterval = 0
  @Published var cumulativeTimeToday: TimeInterval = 0
  
  // MARK: - Private Properties
  private var timer: AnyCancellable?
  private var startTime: Date?
  private var lastPauseTime: TimeInterval = 0
  private var savedCumulativeTime: TimeInterval = 0
  private var lastTick: Date?
  private let userDefaults = UserDefaults.standard
  private let todayDateKey = "todayDate"
  private let cumulativeTimeKey = "cumulativeTime"
  
  init() {
    loadSavedTime()
    checkForNewDay()
  }
  
  // MARK: - Public Methods
  func toggleTimer() {
    isRunning.toggle()
    
    if isRunning {
      startTimer()
    } else {
      pauseTimer()
    }
  }
  
  // MARK: - Private Methods
  private func startTimer() {
    startTime = Date()
    lastTick = Date()
    
    timer = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self, let startTime = self.startTime else { return }
        
        // Calculate elapsed time for display
        self.elapsedSeconds = self.lastPauseTime + Date().timeIntervalSince(startTime)
        
        // Update cumulative time incrementally
        if let lastTick = self.lastTick {
          let incrementalTime = Date().timeIntervalSince(lastTick)
          self.cumulativeTimeToday += incrementalTime
        }
        self.lastTick = Date()
        
        // Save periodically (not every tick to avoid excessive writes)
        if Int(self.elapsedSeconds) % 15 == 0 {
          self.saveCurrentTime()
        }
      }
  }
  
  private func pauseTimer() {
    timer?.cancel()
    timer = nil
    
    if let startTime = startTime {
      lastPauseTime += Date().timeIntervalSince(startTime)
      self.startTime = nil
    }
    
    // Always save when pausing
    saveCurrentTime()
  }
  
  private func saveCurrentTime() {
    userDefaults.set(cumulativeTimeToday, forKey: cumulativeTimeKey)
    userDefaults.set(Date(), forKey: todayDateKey)
  }
  
  private func loadSavedTime() {
    cumulativeTimeToday = loadSavedCumulativeTime()
  }
  
  private func loadSavedCumulativeTime() -> TimeInterval {
    return userDefaults.double(forKey: cumulativeTimeKey)
  }
  
  private func checkForNewDay() {
    guard let savedDate = userDefaults.object(forKey: todayDateKey) as? Date else {
      resetForNewDay()
      return
    }
    
    let calendar = Calendar.current
    if !calendar.isDate(savedDate, inSameDayAs: Date()) {
      resetForNewDay()
    }
  }
  
  private func resetTimer() {
    elapsedSeconds = 0
    lastPauseTime = 0
    startTime = nil
    lastTick = nil
    timer?.cancel()
    timer = nil
    isRunning = false
  }
  
  private func resetForNewDay() {
    resetTimer()
    cumulativeTimeToday = 0
    savedCumulativeTime = 0
    userDefaults.set(0.0, forKey: cumulativeTimeKey)
    userDefaults.set(Date(), forKey: todayDateKey)
  }
}


