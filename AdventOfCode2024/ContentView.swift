//
//  ContentView.swift
//  AdventOfCode2024
//
//  Created by Matthew Waller on 12/1/24.
//

import SwiftUI



@Observable
class AdventCalendar {
    static let shared = AdventCalendar()
    var problems: [Problem] = Problem.allProblems
}

struct ContentView: View {
    @State private var calendar = AdventCalendar.shared
    var body: some View {
        List(calendar.problems) { problem in
            ProblemView(problem: problem)
        }
        
    }
}

struct ProblemView: View {
    @State private var solution = ""
    let problem: Problem
    var body: some View {
        VStack {
            Button("Problem \(problem.number)") {
                solution = problem.function()
            }
            Text("Solution: \(solution)")
        }
    }
}

#Preview {
    ContentView()
}
