# Rainbow Performance Guide

This guide provides best practices for using Rainbow library efficiently and getting the best performance from your colored terminal output.

## Performance Overview

Rainbow v4.2.0+ includes significant performance optimizations that can improve your application's performance by up to **578%** for certain operations.

## Key Performance Improvements

### 1. Builder Pattern (`StyledStringBuilder`)

**Problem**: Traditional chained calls create multiple string copies:
```swift
// ❌ Inefficient - creates 4 intermediate strings
let slow = "Hello".red.bold.underline.onBlue
```

**Solution**: Use the builder pattern for complex styling:
```swift
// ✅ Efficient - lazy evaluation, single string generation
let fast = "Hello".styled.red.bold.underline.onBlue.build()
```

**Performance Gain**: ~578% improvement for complex chained calls.

### 2. Batch Operations

**Problem**: Multiple individual style applications:
```swift
// ❌ Inefficient - multiple parsing and generation cycles
let slow = "Hello".red.bold.underline.italic
```

**Solution**: Apply multiple styles in one operation:
```swift
// ✅ Efficient - single parsing and generation cycle
let fast = "Hello".applyingAll(
    color: .named(.red), 
    styles: [.bold, .underline, .italic]
)
```

**Performance Gain**: ~264% improvement for multiple style applications.

### 3. Optimized String Generation

The internal string generator has been optimized with:
- Pre-allocated string buffers
- Reduced memory allocations
- Fast path for plain text segments
- Optimized ANSI sequence building

**Performance Gain**: ~20-30% improvement in string generation.

## Best Practices

### 1. Choose the Right API

For different scenarios, use the most appropriate API:

```swift
// Single style - use simple properties
let simple = "Error".red

// Multiple styles - use batch operations
let multiple = "Warning".applyingAll(
    color: .named(.yellow),
    backgroundColor: .named(.black),
    styles: [.bold, .underline]
)

// Complex chaining - use builder pattern
let complex = "Success".styled
    .green
    .bold
    .onBlack
    .underline
    .build()

// Performance-critical code - use direct Rainbow API
let direct = Rainbow.generateString(for: entry)
```

### 2. Avoid Repeated Parsing

```swift
// ❌ Don't repeatedly style the same string
for i in 0..<1000 {
    print("Item \(i)".red.bold)  // Parses and generates 1000 times
}

// ✅ Style once, reuse the format
let template = "Item %@".applyingAll(color: .named(.red), styles: [.bold])
for i in 0..<1000 {
    print(String(format: template, "\(i)"))  // Only formats the number
}
```

### 3. Use Appropriate Color Types

```swift
// For maximum compatibility
let compatible = "text".red

// For 256-color terminals
let enhanced = "text".bit8(196)

// For true-color terminals (use sparingly)
let truecolor = "text".bit24(255, 64, 128)
```

### 4. Batch Process Multiple Strings

```swift
// ❌ Process strings individually
let results = strings.map { $0.red.bold }

// ✅ Use builder pattern for better performance
let results = strings.map { $0.styled.red.bold.build() }

// ✅ Even better - use batch operations if styles are the same
let results = strings.map { $0.applyingAll(color: .named(.red), styles: [.bold]) }
```

## Performance Testing

Rainbow includes comprehensive performance tests. Run them to benchmark your specific use case:

```bash
# Run all performance tests
swift test --filter PerformanceTests

# Run specific performance tests
swift test --filter PerformanceTests.testBuilderPatternPerformance
swift test --filter PerformanceTests.testBatchOperationPerformance
```

## Memory Usage

### String Object Creation

Traditional chained calls create multiple intermediate string objects:

```swift
// Creates 4 string objects
"text".red.bold.underline.onBlue
//     ^1  ^2   ^3        ^4 (final)
```

Builder pattern creates only the final string:

```swift
// Creates 1 string object
"text".styled.red.bold.underline.onBlue.build()
//                                      ^1 (final)
```

### Memory Recommendations

1. **Use builder pattern** for complex styling to reduce memory pressure
2. **Avoid storing intermediate styled strings** - compute them when needed
3. **Consider caching** frequently used styled strings
4. **Profile your application** to identify styling hotspots

## Benchmarking Results

Performance improvements achieved in Rainbow v4.2.0+:

| Operation | Traditional | Optimized | Improvement |
|-----------|-------------|-----------|-------------|
| Builder Pattern (complex chaining) | 37,006 ops/sec | 250,992 ops/sec | **+578%** |
| Batch Operations (multiple styles) | 33,156 ops/sec | 120,597 ops/sec | **+264%** |
| String Generator (optimized) | ~350,000 ops/sec | ~400,000 ops/sec | **+14%** |

*Benchmarks run on Apple Silicon Mac with Swift 6.1.2*

## Migration Guide

### Updating Existing Code

Most existing code will continue to work without changes. For performance-critical sections:

1. **Identify hotspots** - use performance profiling to find styling bottlenecks
2. **Replace chained calls** with builder pattern (available in v4.2.0+):
   ```swift
   // Old
   let old = "text".red.bold.underline
   
   // New
   let new = "text".styled.red.bold.underline.build()
   ```

3. **Use batch operations** for multiple styles (available in v4.2.0+):
   ```swift
   // Old
   let old = "text".red.bold.italic
   
   // New  
   let new = "text".applyingAll(color: .named(.red), styles: [.bold, .italic])
   ```

### Backward Compatibility

All existing APIs remain fully functional. The optimizations are additive and don't break existing code.

## Advanced Optimization

### Custom String Generation

For maximum performance in specific scenarios, you can use Rainbow's internal APIs:

```swift
// Create entry directly
let entry = Rainbow.Entry(segments: [
    .init(text: "Hello", color: .named(.red), styles: [.bold])
])

// Generate string directly
let result = Rainbow.generateString(for: entry)
```

### Avoiding Parser Overhead

If you're generating strings programmatically (not parsing existing colored strings), use direct entry creation to avoid parser overhead.

## Troubleshooting Performance

1. **Run performance tests** to establish baseline metrics
2. **Profile your application** to identify styling bottlenecks  
3. **Use builder pattern** for complex styling operations
4. **Consider caching** frequently used styled strings
5. **Minimize repeated styling** of the same content

## Contributing to Performance

If you discover additional performance optimizations or have use cases not covered by current optimizations, please:

1. Create performance tests demonstrating the issue
2. Propose optimizations with benchmarks
3. Submit pull requests with performance improvements

## Further Reading

- [IMPROVEMENT_ROADMAP.md](IMPROVEMENT_ROADMAP.md) - Detailed technical analysis
- [Performance Tests](Tests/RainbowTests/PerformanceTests.swift) - Complete test suite
- [Issue Tracker](https://github.com/onevcat/Rainbow/issues) - Report performance issues