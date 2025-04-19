//
//  TimerView.swift
//  TimeTimer
//
//  Created by Wayne Dahlberg on 4/19/25.
//

import SwiftUI

struct TimerView: View {
  @EnvironmentObject private var timerManager: TimerManager
  
  var body: some View {
    VStack(spacing: 12) {
      // App Title
      Text("Timer app")
        .font(.title2)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
      
      Divider()
        .padding(.vertical, 4)
      
      // Timer Display
      Text(formattedElapsedTime)
        .font(.system(size: 32, weight: .bold))
        .foregroundColor(timerManager.isRunning ? .primary : .gray.opacity(0.5))
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // Status Indicator
      Text(timerManager.isRunning ? "Active" : "**Paused**")
        .font(.title2)
        .fontWeight(.medium)
        .foregroundColor(timerManager.isRunning ? .green : .orange)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // Cumulative Time Today
      Text("\(formattedCumulativeTime) Today")
        .font(.title3)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
      
      Divider()
        .padding(.vertical, 4)
      
      // Button Row
      HStack {
        // Quit Button
        Button("Quit Timer App") {
          NSApplication.shared.terminate(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
        
        // Toggle Button
        Button {
          timerManager.toggleTimer()
        } label: {
          Image(systemName: timerManager.isRunning ? "pause.rectangle.fill" : "play.rectangle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 44, height: 44)
            .foregroundColor(timerManager.isRunning ? .red : .green)
        }
        .buttonStyle(.plain)
      }
    }
    .padding()
    .frame(width: 300)
  }
  
  // MARK: - Computed Properties
  private var formattedElapsedTime: String {
    formatTimeInterval(timerManager.elapsedSeconds)
  }
  
  private var formattedCumulativeTime: String {
    formatTimeInterval(timerManager.cumulativeTimeToday)
  }
  
  // MARK: - Helper Methods
  private func formatTimeInterval(_ interval: TimeInterval) -> String {
    let hours = Int(interval) / 3600
    let minutes = (Int(interval) % 3600) / 60
    let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
    
    return "\(hours)h \(minutes)m \(seconds)s"
  }
}

#Preview {
  TimerView()
}
