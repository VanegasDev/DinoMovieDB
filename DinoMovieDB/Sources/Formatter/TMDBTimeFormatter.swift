//
//  TMDBTimeFormatter.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/29/21.
//

class TMDBTimeFormatter {
    func formatMinutesToHourMinutes(from int: Int) -> String {
        let hours = abs(int / 60)
        let minutes = int - (hours * 60)
        
        return hours > 0 ? "\(hours)h \(minutes)min" : "\(minutes)min"
    }
}

extension TMDBTimeFormatter {
    static let `default` = TMDBTimeFormatter()
}
