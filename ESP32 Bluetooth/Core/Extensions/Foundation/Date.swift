//
//  Date.swift
//  RouteNavigator
//
//  Created by Mac Ward on 23/08/2018.
//  Copyright © 2018 webwerks. All rights reserved.
//

import SwiftDate

// MARK: - Date extension
extension Date {

    /// Comvert date to string
    ///
    /// - Parameter str: `String` value
    /// - Returns: return `Date` object or `nil`
    static func fromISODateString(_ str: String) -> Date? {
        return str.toISODate()?.date
    }

    /// Get unix timestamp date
    ///
    /// - Returns: return `Date` object
    static func defaultDate() -> Date {
        return Date(timeIntervalSince1970: 0)
    }

    /// Get UTC date with "M/dd/yyyy h:mm a" format
    ///
    /// - Returns: return `String` value
    func UTCToLocal() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy H:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = formatter.date( from: formatter.string(from: self) )
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd/yyyy h:mm a"

        return formatter.string(from: dt!)
    }

    /// Get string date with "yyyy-MM-dd" format
    ///
    /// - Returns: return `String` value
    func toYearMonthDayFormatString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self)
        return dateString
    }

    /// Get ISO date in string format
    ///
    /// - Returns: return `String` value
    func toISOString() -> String {
        return toISO()
    }

    /// Get a custom descriptive format by enging date
    ///
    /// - Returns: return `String` value
    func toDescriptiveString() -> String {

        var when = ""

        var format = toFormat("E, MMM d")

        if compare(.isToday) {
            when = "Today"
        } else if compare(.isYesterday) {
            when = "Yesterday"
        } else if compare(.isThisWeek) {
            when = "This Week"
        } else if compare(.isLastWeek) {
            when = "Last Week"
        } else if compare(.isThisMonth) {
            when = "This Month"
        } else if compare(.isLastMonth) {
            when = "Last Month"
        } else if compare(.isThisYear) {
            when = "This Year"
            format = toFormat("MMM d, YYYY")
        } else if compare(.isLastYear) {
            when = "Last Year"
            format = toFormat("MMM d, YYYY")
        } else {
            when = "Older"
            format = toFormat("MMM d, YYYY")
        }

        return when + " - " + format
    }

    /// Get date with "EEE  d MMMM, yyyy h:mm a" format
    ///
    /// - Returns: return `String` value
    func toLongDateString() -> String {
        return toFormat("EEE  d MMMM, yyyy h:mm a")
    }

    /// Get time with "hh:mm a" format
    ///
    /// - Returns: return `String` value
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timeStr = formatter.string(from: Date())
        return timeStr
    }
    
    /// Get a custom elapsed date
    ///
    /// - Returns: return `String` value
    func timeAgo() -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month ago"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week ago"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
}
