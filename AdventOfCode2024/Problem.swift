//
//  Problem.swift
//  AdventOfCode2024
//
//  Created by Matthew Waller on 12/2/24.
//


import SwiftUI
import RegexBuilder

struct Problem: Identifiable {
    var id: Int {
        number
    }
    
    let number: Int
    
    var function: () -> String
    
    static func parseDay1Data() -> (firstColumn: [Int], secondColumn: [Int])? {
        // Access the data from the asset catalog
        guard let asset = NSDataAsset(name: "Day1Data") else {
            print("Error: Could not find data asset")
            return nil
        }
        
        // Convert data to string
        guard let contents = String(data: asset.data, encoding: .utf8) else {
            print("Error: Could not convert data to string")
            return nil
        }
        
        // Initialize our column arrays
        var firstColumn: [Int] = []
        var secondColumn: [Int] = []
        
        // Split the contents into lines
        let lines = contents.components(separatedBy: .newlines)
        
        // Parse each line
        for line in lines {
            guard !line.isEmpty else { continue }
            
            // Split by three spaces
            let components = line.components(separatedBy: "   ")
            
            // Verify we have exactly two components
            guard components.count == 2,
                  let firstNumber = Int(components[0].trimmingCharacters(in: .whitespaces)),
                  let secondNumber = Int(components[1].trimmingCharacters(in: .whitespaces)) else {
                continue
            }
            
            firstColumn.append(firstNumber)
            secondColumn.append(secondNumber)
        }
        
        // Only return if we successfully parsed some data
        guard !firstColumn.isEmpty else { return nil }
        
        return (firstColumn, secondColumn)
    }
    
    static func parseDay2Data() -> [[Int]]? {
        // Access the data from the asset catalog
        guard let asset = NSDataAsset(name: "Day2Data") else {
            print("Error: Could not find data asset")
            return nil
        }
        
        // Convert data to string
        guard let contents = String(data: asset.data, encoding: .utf8) else {
            print("Error: Could not convert data to string")
            return nil
        }
        
        // Split the contents into lines
        let lines = contents.components(separatedBy: .newlines)
        
        // Parse each line
        
        var reports: [[Int]] = []
        for line in lines {
            guard !line.isEmpty else { continue }
            
            // Split by three spaces
            let report = line.components(separatedBy: " ").compactMap { string in
                if let integer = try? Int(string, format: .number) {
                    return integer
                } else {
                    return nil
                }
                
            }
            
            reports.append(report)
        }
        
        return reports
    }
    
    static func parseDay3Data() -> String? {
        // Access the data from the asset catalog
        guard let asset = NSDataAsset(name: "Day3Data") else {
            print("Error: Could not find data asset")
            return nil
        }
        
        
        return String(data: asset.data, encoding: .utf8)
    }
    
    static let allProblems: [Problem] = [
        Problem(number: 1, function: {
            guard let data = Problem.parseDay1Data() else {
                return ""
            }
            
            let columnOne = data.firstColumn
            let columnTwo = data.secondColumn
            
            let sortedColumnOne = columnOne.sorted()
            let sortedColumnTwo = columnTwo.sorted()
            
            var totalDifference: Int = 0
            for (index, value) in sortedColumnOne.enumerated() {
                let difference = value - sortedColumnTwo[index]
                totalDifference += abs(difference)
            }
            return "\(totalDifference)"
        }),
        Problem(number: 2, function: {
            guard let data = Problem.parseDay1Data() else {
                return ""
            }
            
            let columnOne = data.firstColumn
            let columnTwo = data.secondColumn
            
            var columnTwoCountDictionary: [Int:Int] = [:]
            for value in columnTwo {
                columnTwoCountDictionary[value, default: 0] += 1
            }
            
            var similarityScore: Int = 0
            for value in columnOne {
                let existingCount = columnTwoCountDictionary[value] ?? 0
                similarityScore += existingCount * value
            }
            
            return "\(similarityScore)"
        }),
        Problem(number: 3, function: {
            guard let reports = Problem.parseDay2Data() else { return "" }
            
            var numberOfSafeReports: Int = 0
            
            for report in reports {
                var isSafe = true
                var isDescreasing: Bool? = nil
                var isIncreasing: Bool? = nil
                for (levelIndex, level) in report.enumerated() {
                    if levelIndex < report.count - 1 {
                        let nextLevel = report[levelIndex + 1]
                        if level > nextLevel {
                            isDescreasing = true
                        } else if level < nextLevel {
                            isIncreasing = true
                        }
                        
                        if let isIncreasing, let isDescreasing {
                            if isIncreasing && isDescreasing {
                                isSafe = false
                            }
                        }
                        
                        let difference = abs(level - nextLevel)
                        if difference < 1 || difference > 3 {
                            isSafe = false
                        }
                        
                        
                    }
                }
                
                if isSafe {
                    numberOfSafeReports += 1
                }
            }
            
            return "\(numberOfSafeReports)"
        }),
        Problem(number: 4, function: {
            guard let reports = Problem.parseDay2Data() else { return "" }
            
            var numberOfSafeReports: Int = 0
            
            func isReportSafe(_ report: [Int]) -> Bool {
                var isSafe = true
                var isDescreasing: Bool? = nil
                var isIncreasing: Bool? = nil
                for (levelIndex, level) in report.enumerated() {
                    if levelIndex < report.count - 1 {
                        let nextLevel = report[levelIndex + 1]
                        if level > nextLevel {
                            isDescreasing = true
                        } else if level < nextLevel {
                            isIncreasing = true
                        }
                        
                        if let isIncreasing, let isDescreasing {
                            if isIncreasing && isDescreasing {
                                isSafe = false
                            }
                        }
                        
                        let difference = abs(level - nextLevel)
                        if difference < 1 || difference > 3 {
                            isSafe = false
                        }
                    }
                }
                
                return isSafe
            }
            
            for report in reports {
                let isSafe = isReportSafe(report)
                
                if isSafe {
                    numberOfSafeReports += 1
                } else {
                    var reportsWithLevelRemoved = [[Int]]()
                    for levelIndex in 0..<report.count {
                        var reportCopy = report
                        reportCopy.remove(at: levelIndex)
                        reportsWithLevelRemoved.append(reportCopy)
                    }
                    
                    for reportsWithLevelRemove in reportsWithLevelRemoved {
                        if isReportSafe(reportsWithLevelRemove) {
                            numberOfSafeReports += 1
                            break
                        }
                    }
                }
            }
            
            return "\(numberOfSafeReports)"
        }),
        Problem(number: 5, function: {
            guard let reports = Problem.parseDay3Data() else { return "" }
            
            let mulPattern = Regex {
                "mul("
                Capture {
                    OneOrMore {
                        .digit
                    }
                }
                ","
                Capture {
                    OneOrMore {
                        .digit
                    }
                }
                ")"
            }
            
            guard let text = Problem.parseDay3Data() else { return "" }
            
            var total = 0
            for match in text.matches(of: mulPattern) {
                if let firstDigit = Int(match.output.1), let secondDigit = Int(match.output.2) {
                    total += firstDigit * secondDigit
                }
            }
            
            return "\(total)"
        }),
        Problem(number: 6, function: {
            guard let reports = Problem.parseDay3Data() else { return "" }
            
            let mulPattern = Regex {
                ChoiceOf {
                    Regex {
                        "mul("
                        Capture {
                            OneOrMore {
                                .digit
                            }
                        }
                        ","
                        Capture {
                            OneOrMore {
                                .digit
                            }
                        }
                        ")"
                    }
                    "don't"
                    "do"
                }
                
            }
            
            guard let text = Problem.parseDay3Data() else { return "" }
            
            var total = 0
            var lastOutputWasDont = false
            for match in text.matches(of: mulPattern) {
                if match.output.0 == "don't" {
                    lastOutputWasDont = true
                } else if match.output.0 == "do" {
                    lastOutputWasDont = false
                }
                
                if lastOutputWasDont { continue }
                if let firstOutput = match.output.1,
                    let secondOutput = match.output.2,
                   let firstDigit = Int(firstOutput),
                   let secondDigit = Int(secondOutput)
                {
                    total += firstDigit * secondDigit
                    
                }
            }
            
            return "\(total)"
        })
    ]
        
}
