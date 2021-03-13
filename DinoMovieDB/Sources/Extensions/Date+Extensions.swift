//
//  Date+Extensions.swift
//  DinoMovieDB
//
//  Created by Mario Vanegas on 3/13/21.
//

import Foundation

extension DateFormatter {
    static func tmdbDatePreviewFormat(from string: String) -> String {
        let formatterInput = DateFormatter()
        let formatterOutput = DateFormatter()
        formatterInput.dateFormat = "yyyy-MM-dd"
        formatterOutput.dateFormat = "MMMM dd, yyyy"
        
        guard let date = formatterInput.date(from: string) else {
            return "Error"
        }
        
        return formatterOutput.string(from: date)
    }
}
