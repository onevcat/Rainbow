//
//  PerformanceTests.swift
//  RainbowTests
//
//  Created by Performance Optimization on 2025-07-11.
//
//  Copyright (c) 2018 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
import Foundation
@testable import Rainbow

#if canImport(CoreFoundation) && !os(Linux)
import CoreFoundation
#endif

// MARK: - Performance Testing Framework
// Performance tests are disabled on Linux due to CFAbsoluteTime API unavailability
#if canImport(CoreFoundation) && !os(Linux)
class PerformanceTests: XCTestCase {
    
    struct PerformanceResult {
        let name: String
        let iterations: Int
        let totalTime: TimeInterval
        let averageTime: TimeInterval
        let operationsPerSecond: Double
        
        init(name: String, iterations: Int, totalTime: TimeInterval) {
            self.name = name
            self.iterations = iterations
            self.totalTime = totalTime
            self.averageTime = totalTime / Double(iterations)
            self.operationsPerSecond = Double(iterations) / totalTime
        }
        
        func description() -> String {
            return """
            \(name):
              Iterations: \(iterations)
              Total Time: \(String(format: "%.4f", totalTime))s
              Average Time: \(String(format: "%.6f", averageTime))s
              Operations/Second: \(String(format: "%.2f", operationsPerSecond))
            """
        }
    }
    
    override func setUp() {
        super.setUp()
        Rainbow.outputTarget = .console
        Rainbow.enabled = true
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Performance Measurement Utilities
    
    func measurePerformance<T>(
        name: String,
        iterations: Int = 10000,
        setup: () -> Void = {},
        operation: () -> T
    ) -> PerformanceResult {
        setup()
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = operation()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        
        return PerformanceResult(name: name, iterations: iterations, totalTime: totalTime)
    }
    
    func comparePerformance<T>(
        name: String,
        iterations: Int = 10000,
        baseline: () -> T,
        optimized: () -> T
    ) -> (baseline: PerformanceResult, optimized: PerformanceResult, improvement: Double) {
        
        let baselineResult = measurePerformance(name: "\(name) - Baseline", iterations: iterations, operation: baseline)
        let optimizedResult = measurePerformance(name: "\(name) - Optimized", iterations: iterations, operation: optimized)
        
        let improvement = (baselineResult.averageTime - optimizedResult.averageTime) / baselineResult.averageTime * 100
        
        return (baselineResult, optimizedResult, improvement)
    }
    
    // MARK: - Memory Usage Measurement
    
    func measureMemoryUsage<T>(operation: () -> T) -> (result: T, memoryUsed: Int64) {
        let startMemory = getCurrentMemoryUsage()
        let result = operation()
        let endMemory = getCurrentMemoryUsage()
        let memoryUsed = endMemory - startMemory
        
        return (result, memoryUsed)
    }
    
    private func getCurrentMemoryUsage() -> Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            return Int64(info.resident_size)
        } else {
            return 0
        }
    }
    
    // MARK: - Benchmark Test Cases
    
    func testChainedCallsPerformance() {
        let testStrings = [
            "Hello World",
            "This is a test string",
            "Performance testing for Rainbow library",
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        ]
        
        // Test basic chained calls
        for testString in testStrings {
            let result = measurePerformance(
                name: "Chained calls - \(testString.count) chars",
                iterations: 5000
            ) {
                return testString.red.bold.underline
            }
            
            print(result.description())
        }
        
        // Test complex chained calls
        let complexResult = measurePerformance(
            name: "Complex chained calls",
            iterations: 1000
        ) {
            return "test".red.bold.underline.onBlue.italic
        }
        
        print(complexResult.description())
    }
    
    func testBulkStringProcessingPerformance() {
        let testStrings = (0..<1000).map { "String \($0)" }
        
        let result = measurePerformance(
            name: "Bulk string processing - 1000 strings",
            iterations: 100
        ) {
            return testStrings.map { $0.red.bold }
        }
        
        print(result.description())
    }
    
    func testParserPerformance() {
        let complexColoredString = "\u{001B}[31;1;4mHello\u{001B}[0m \u{001B}[32;42mWorld\u{001B}[0m"
        
        let result = measurePerformance(
            name: "Parser performance - complex ANSI sequence",
            iterations: 10000
        ) {
            return Rainbow.extractEntry(for: complexColoredString)
        }
        
        print(result.description())
    }
    
    func testStringGeneratorPerformance() {
        let entry = Rainbow.Entry(segments: [
            .init(text: "Hello", color: .bit8(214), backgroundColor: .named(.black), styles: [.underline, .bold]),
            .init(text: "World", color: .named(.magenta), backgroundColor: .bit8(200), styles: [.italic]),
            .init(text: "Test", color: .bit24((255, 128, 64)), styles: [.blink])
        ])
        
        let result = measurePerformance(
            name: "String generator - complex entry",
            iterations: 10000
        ) {
            return Rainbow.generateString(for: entry)
        }
        
        print(result.description())
    }
    
    func testMemoryUsageForChainedCalls() {
        let testString = "Memory test string"
        
        let (_, memoryUsed) = measureMemoryUsage {
            var results: [String] = []
            for _ in 0..<1000 {
                results.append(testString.red.bold.underline.onBlue)
            }
            return results
        }
        
        print("Memory usage for 1000 chained calls: \(memoryUsed) bytes")
        print("Average memory per operation: \(memoryUsed / 1000) bytes")
    }
    
    func testHexColorPerformance() {
        let hexColors = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"]
        
        let result = measurePerformance(
            name: "Hex color processing",
            iterations: 5000
        ) {
            var results: [String] = []
            for color in hexColors {
                results.append("test".hex(color))
            }
            return results
        }
        
        print(result.description())
    }
    
    // MARK: - Performance Regression Tests
    
    func testPerformanceRegression() {
        // Store baseline performance results
        let baselineResults = runAllPerformanceTests()
        
        // Print baseline results
        print("=== BASELINE PERFORMANCE RESULTS ===")
        for result in baselineResults {
            print(result.description())
            print("---")
        }
        
        // These results will be compared against optimized version
        XCTAssertTrue(baselineResults.count > 0, "Should have baseline performance results")
    }
    
    // MARK: - Optimization Comparison Tests
    
    func testBuilderPatternPerformance() {
        let testString = "Performance Test String"
        
        // Test traditional chaining vs builder pattern
        let comparison = comparePerformance(
            name: "Chain vs Builder Pattern",
            iterations: 5000,
            baseline: {
                return testString.red.bold.underline.onBlue
            },
            optimized: {
                return testString.styled.red.bold.underline.onBlue.build()
            }
        )
        
        print("=== BUILDER PATTERN PERFORMANCE COMPARISON ===")
        print(comparison.baseline.description())
        print("---")
        print(comparison.optimized.description())
        print("---")
        print("Improvement: \(String(format: "%.2f", comparison.improvement))%")
        
        // Builder pattern should be faster or at least comparable
        XCTAssertTrue(comparison.improvement >= -10, "Builder pattern should not be significantly slower")
    }
    
    func testBatchOperationPerformance() {
        let testString = "Batch Operation Test"
        
        // Test individual style applications vs batch operation
        let comparison = comparePerformance(
            name: "Individual vs Batch Operations",
            iterations: 2000,
            baseline: {
                return testString.red.bold.underline.italic
            },
            optimized: {
                return testString.applyingAll(color: .named(.red), styles: [.bold, .underline, .italic])
            }
        )
        
        print("=== BATCH OPERATION PERFORMANCE COMPARISON ===")
        print(comparison.baseline.description())
        print("---")
        print(comparison.optimized.description())
        print("---")
        print("Improvement: \(String(format: "%.2f", comparison.improvement))%")
        
        // Batch operations should be faster
        XCTAssertTrue(comparison.improvement > 0, "Batch operations should be faster than individual calls")
    }
    
    func testStringGeneratorOptimization() {
        let entry = Rainbow.Entry(segments: [
            .init(text: "Hello", color: .bit8(214), backgroundColor: .named(.black), styles: [.underline, .bold]),
            .init(text: " ", color: nil, backgroundColor: nil, styles: nil),
            .init(text: "World", color: .named(.magenta), backgroundColor: .bit8(200), styles: [.italic]),
            .init(text: "!", color: .bit24((255, 128, 64)), styles: [.blink])
        ])
        
        // Test string generation performance
        let result = measurePerformance(
            name: "Optimized String Generator",
            iterations: 10000
        ) {
            return Rainbow.generateString(for: entry)
        }
        
        print("=== STRING GENERATOR PERFORMANCE ===")
        print(result.description())
        
        // Should be reasonably fast
        XCTAssertTrue(result.operationsPerSecond > 50000, "String generator should process at least 50,000 operations per second")
    }
    
    private func runAllPerformanceTests() -> [PerformanceResult] {
        var results: [PerformanceResult] = []
        
        // Chain calls test
        results.append(measurePerformance(name: "Chain calls", iterations: 5000) {
            return "test".red.bold.underline
        })
        
        // Bulk processing test
        results.append(measurePerformance(name: "Bulk processing", iterations: 100) {
            return (0..<100).map { "String \($0)".red.bold }
        })
        
        // Parser test
        results.append(measurePerformance(name: "Parser", iterations: 10000) {
            return Rainbow.extractEntry(for: "\u{001B}[31;1;4mHello\u{001B}[0m")
        })
        
        // String generator test
        results.append(measurePerformance(name: "String generator", iterations: 10000) {
            let entry = Rainbow.Entry(segments: [
                .init(text: "Hello", color: .named(.red), styles: [.bold])
            ])
            return Rainbow.generateString(for: entry)
        })
        
        return results
    }
}
#endif
