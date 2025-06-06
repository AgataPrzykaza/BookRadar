//
//  StatusView.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI



struct StatusView: View {
    
    var statusSelected: ReadingStatus
    let onStatusChange: (ReadingStatus) -> Void
    
    var body: some View{
        
        Menu {
            ForEach(ReadingStatus.allCases, id: \.self) { status in
                Button {
                    onStatusChange(status)
                } label: {
                   
                        Text("\(getStatusEmoji(status)) \(status.displayName)")
                    
                }
            }
        } label: {
            HStack(spacing: 8) {
                StatusBadge(status: statusSelected)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
       
    }
    
    private func getStatusEmoji(_ status: ReadingStatus) -> String {
        switch status {
        case .wantToRead: return "📚"
        case .currentlyReading: return "📖"
        case .finished: return "✅"
        case .pause: return "⏸️"
        }
    }
}

//#Preview {
//    StatusView(statusSelected:.currentlyReading)
//}
