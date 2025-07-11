# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rainbow is a Swift library that adds text color, background color and style for console and command line output. It is designed for cross-platform software logging in terminals, working on Apple platforms, Linux, and Windows.

## Build and Test Commands

```bash
# Build the project
swift build -v

# Run all tests
swift test -v

# Run tests with test discovery (Linux)
swift test -v --enable-test-discovery

# Run a specific test
swift test --filter TestClassName.testMethodName

# Build in release mode
swift build -c release

# Generate Xcode project (if needed)
swift package generate-xcodeproj
```

## Architecture Overview

### Core Components

1. **Rainbow.swift** - Central configuration and control
   - Contains `OutputTarget` enum (console, unknown) that determines whether to apply colors
   - Manages global settings like `enabled` flag and environment variable handling (`NO_COLOR`, `FORCE_COLOR`)
   - Provides core string generation logic via `generateString(for:)` method

2. **String+Rainbow.swift** - Main user-facing API
   - All color/style properties are lazy computed properties that create new strings
   - Chain calls (e.g., `"text".red.bold`) create multiple string copies - performance consideration
   - Contains `applyingCodes` method that handles the actual ANSI escape sequence application

3. **Parser System**
   - `ConsoleEntryParser` - Parses existing colored strings into segments
   - `ModesExtractor` - Extracts ANSI codes from strings (safe with natural iteration termination)
   - Used for the `raw` property that strips existing colors

4. **Color System**
   - `ColorType` enum: supports named colors (.red), 8-bit colors, and 24-bit RGB colors
   - `BackgroundColorType` enum: parallel structure for background colors
   - `ColorApproximation` - Converts hex colors to nearest 8-bit or 24-bit color

### Key Design Patterns

1. **Lazy Evaluation Problem**: Each property access in chains creates a new string. Consider implementing a builder pattern for better performance.

2. **ANSI Escape Sequences**: All colors/styles work by wrapping text in ANSI codes:
   - Format: `\u{001B}[<codes>m<text>\u{001B}[0m`
   - Multiple codes separated by semicolons

3. **Environment Detection**: 
   - Automatically disables colors when output is redirected to file
   - Respects `NO_COLOR` and `FORCE_COLOR` environment variables
   - Uses `isatty()` to detect TTY output

## Important Considerations

1. **Performance**: String extensions create new strings on each call. For performance-critical code, use `Rainbow.generateString()` directly with pre-built entries.

2. **Thread Safety**: No explicit thread safety mechanisms. String operations are generally safe but global settings (Rainbow.enabled, Rainbow.outputTarget) may need synchronization in concurrent contexts.

3. **Platform Differences**: 
   - Windows support exists but may need additional terminal detection
   - Some styles may not work on all terminals

4. **Code Duplication**: The `hex` method implementation is duplicated for foreground and background colors in String+Rainbow.swift.

## Testing Approach

Tests are organized by functionality:
- `RainbowTests.swift` - Core functionality and mode extraction
- `ConsoleStringTests.swift` - String extension API tests  
- `ColorTests.swift` - Color conversion tests
- `ColorApproximatedTests.swift` - Hex color approximation tests
- `ConsoleTextParserTests.swift` - Parser tests

Note: Missing tests for `strikethrough` style and Windows-specific behavior.

## Common Development Tasks

When adding new colors or styles:
1. Add to appropriate enum (Color, BackgroundColor, or Style)
2. Update ANSI code mappings
3. Add string extension property
4. Add tests for the new feature
5. Update README with examples

When fixing parser issues:
1. Check `ModesExtractor.swift` for the core parsing logic
2. Be aware of the infinite loop risk in `parseText` method
3. Test with malformed ANSI sequences