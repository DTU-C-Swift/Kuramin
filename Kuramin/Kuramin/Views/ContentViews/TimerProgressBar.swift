//
//  TimerPrgressBar.swift
//  Kuramin
//
//  Created by MD. Zahed on 26/03/2023.
//

// Source:  https://sarunw.com/posts/swiftui-circular-progress-bar/


import SwiftUI

struct TimerProgressBar: View {
    @State var progress: Double = 0
    var progressTime: Int
    let interval = 0.20
    
    let timer = Timer.publish(every: 0.20, on: .main, in: .common).autoconnect()
    
    
    /// - progressTime: Time in seconds
    init(progressTime: Int) {
        self.progressTime = progressTime
    }
    
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.green.opacity(0.5),
                    lineWidth: 8
                )
            
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
            
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
                .onReceive(timer) { _ in
                    progress += 1 / Double(progressTime) * interval
                    if progress >= 1 {
                        timer.upstream.connect().cancel()
                    }
                }
            
        }
//        .padding(.all, 20)
    }
    
    
    
}

struct TimerPrgressBar_Previews: PreviewProvider {
    static var previews: some View {
        
        TimerProgressBar(progressTime: 20)
        
    }
}
