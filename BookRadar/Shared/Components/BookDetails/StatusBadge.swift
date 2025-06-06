//
//  StatusBadge.swift
//  BookRadar
//
//  Created by Agata Przykaza on 05/06/2025.
//

import SwiftUI

struct StatusBadge: View {
    
   var status: ReadingStatus?
    
    var statusColor: Color {
        guard let status = status else { return .gray }
        switch status {
        case .wantToRead: return .blue
        case .currentlyReading: return .orange
        case .finished: return .green
        case .pause: return .gray
        }
    }
    
    var statusEmoji: String {
        guard let status = status else { return "📚" }
        switch status {
        case .wantToRead: return "📚"
        case .currentlyReading: return "📖"
        case .finished: return "✅"
        case .pause: return "⏸️"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(statusEmoji)
            Text(status?.displayName ?? "Wybierz")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(statusColor.opacity(0.2))
        .foregroundColor(statusColor)
        .cornerRadius(8)
    }
}

 
