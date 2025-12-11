# CI/CD Improvement Action Plan - Rainbow Project

## Quick Reference: What Needs to Change

### Files to Modify
1. `.github/workflows/ci.yaml` - GitHub Actions workflow
2. `Package.swift` - Swift tools version
3. `Gemfile` - CocoaPods version specification
4. (Optional) `fastlane/Fastfile` - If keeping fastlane

---

## Implementation Guide

### PHASE 1: Critical Updates (1-2 hours)

#### Step 1.1: Update Swift Tools Version

**File**: `Package.swift`

**Current**:
```swift
// swift-tools-version:4.0
```

**Change to**:
```swift
// swift-tools-version:5.9
```

**Why**: Swift 4.0 (Sept 2017) is obsolete. 5.9 is the latest stable version with full modern language features.

**Test After**: Run `swift build -v` and `swift test -v` to ensure no API breakage.

---

#### Step 1.2: Update GitHub Actions Workflow

**File**: `.github/workflows/ci.yaml`

**Current Workflow**:
```yaml
name: ci

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  linux:
    runs-on: ubuntu-latest
    container: swift:latest
    steps:
    - uses: actions/checkout@v2
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v --enable-test-discovery
  macos:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v
```

**Replace with**:
```yaml
name: ci

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  linux:
    runs-on: ubuntu-latest
    container: swift:5.9-jammy
    steps:
    - uses: actions/checkout@v4
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v --enable-test-discovery
  macos:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v4
    - name: Build
      run: swift build -v
    - name: Run tests
      run: swift test -v
```

**Changes**:
- Line 12: `swift:latest` → `swift:5.9-jammy` (pin version to Ubuntu Jammy LTS)
- Line 14: `actions/checkout@v2` → `actions/checkout@v4`
- Line 22: `actions/checkout@v2` → `actions/checkout@v4`

**Why**: 
- Pinning prevents surprise breakage when Swift releases new versions
- v4 has critical security patches and performance improvements
- Jammy is LTS-supported Ubuntu version

**Test After**: Push to a branch and verify CI passes on both Linux and macOS.

---

#### Step 1.3: Fix Cocoapods Version in Gemfile

**File**: `Gemfile`

**Current**:
```ruby
source "https://rubygems.org"

gem "fastlane"
gem "cocoapods", '~>1.2'
```

**Change to**:
```ruby
source "https://rubygems.org"

gem "fastlane"
gem "cocoapods", '~>1.15'
```

**Why**: Specification shows `~>1.2` (old) but Gemfile.lock actually uses `1.16.2`. Lock the specification to what's actually needed.

**Test After**: Run `bundle update --dry-run` to verify no conflicts.

---

### PHASE 2: Performance & Quality (2-3 hours)

#### Step 2.1: Add Dependency Caching

**File**: `.github/workflows/ci.yaml`

**Update the workflow** to add caching before build steps:

```yaml
name: ci

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  linux:
    runs-on: ubuntu-latest
    container: swift:5.9-jammy
    steps:
    - uses: actions/checkout@v4
    
    - name: Cache Swift build dependencies
      uses: actions/cache@v3
      with:
        path: .build
        key: ${{ runner.os }}-swift-5.9-${{ hashFiles('**/Package.resolved') }}
        restore-keys: |
          ${{ runner.os }}-swift-5.9-
    
    - name: Build
      run: swift build -v
    
    - name: Run tests
      run: swift test -v --enable-test-discovery
  
  macos:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Swift
      uses: swift-actions/setup-swift@v1
      with:
        swift-version: "5.9"
    
    - name: Cache Swift build dependencies
      uses: actions/cache@v3
      with:
        path: .build
        key: ${{ runner.os }}-swift-5.9-${{ hashFiles('**/Package.resolved') }}
        restore-keys: |
          ${{ runner.os }}-swift-5.9-
    
    - name: Build
      run: swift build -v
    
    - name: Run tests
      run: swift test -v
```

**Why**: 
- First build: ~3-5 minutes
- Cached build: ~1-2 minutes
- Saves 50% of CI time on subsequent runs
- Reduces server load

**Impact**: Faster feedback on PRs, better developer experience.

---

#### Step 2.2: Add Code Coverage (Optional but Recommended)

**File**: `.github/workflows/ci.yaml`

**Add to Linux job** (after test step):
```yaml
    - name: Run tests with coverage
      run: swift test -v --enable-code-coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage.xml
        flags: unittests
        name: codecov-umbrella
```

**Why**: README references codecov badge but it's not implemented. This enables coverage tracking.

---

### PHASE 3: Documentation & Maintenance (1 hour)

#### Step 3.1: Create Contributing Guide

**File**: `CONTRIBUTING.md` (new)

```markdown
# Contributing to Rainbow

## Development Setup

### Requirements
- Swift 5.9 or later
- macOS 12.0+ or Ubuntu (Docker support)
- Ruby 3.3.6+ (for release automation)

### Local Testing

```bash
# Build
swift build -v

# Run tests
swift test -v

# Or use fastlane locally
fastlane test
```

## CI/CD Pipeline

The project uses GitHub Actions for CI/CD:

- **Linux**: Runs on Ubuntu with Swift 5.9-jammy container
- **macOS**: Runs on latest macOS with Swift 5.9

Both platforms run the full build and test suite.

### Running Release

```bash
# Set up gems first
bundle install

# Run release (requires clean git state)
fastlane release version:X.Y.Z
```

## Code Style

- Follow Swift conventions
- Run `swift build -v` before committing
- All tests must pass
```

---

#### Step 3.2: Update README CI Badge (Optional)

**File**: `README.md`

The current badge reference should already work:
```markdown
[![CI](https://github.com/onevcat/Rainbow/actions/workflows/ci.yaml/badge.svg)](https://github.com/onevcat/Rainbow/actions/workflows/ci.yaml)
```

This will automatically update once CI changes are pushed.

---

## Testing Checklist

### Before Pushing Changes

- [ ] Updated `Package.swift` swift-tools-version
- [ ] Updated `.github/workflows/ci.yaml` with new versions
- [ ] Updated `Gemfile` cocoapods version
- [ ] `swift build -v` runs without errors
- [ ] `swift test -v` passes all tests
- [ ] No TypeErrors or warnings

### After Pushing to Master

- [ ] GitHub Actions CI runs successfully
- [ ] Both Linux and macOS jobs pass
- [ ] Build time is acceptable (should be cached after first run)
- [ ] All tests pass on both platforms

---

## Detailed Changes by File

### .github/workflows/ci.yaml
```diff
- container: swift:latest
+ container: swift:5.9-jammy
- uses: actions/checkout@v2
+ uses: actions/checkout@v4
```

### Package.swift
```diff
- // swift-tools-version:4.0
+ // swift-tools-version:5.9
```

### Gemfile
```diff
- gem "cocoapods", '~>1.2'
+ gem "cocoapods", '~>1.15'
```

---

## Estimated Time Breakdown

| Task | Time |
|------|------|
| Update Package.swift | 10 min |
| Update .github/workflows/ci.yaml | 20 min |
| Update Gemfile | 5 min |
| Add caching to CI | 15 min |
| Test locally | 15 min |
| Test CI pipeline | 10 min |
| Create documentation | 20 min |
| **Total** | **95 min (~1.5 hours)** |

---

## Rollback Plan

If changes cause issues, revert with:

```bash
git revert <commit-hash>
# or
git reset --hard HEAD~1
```

The changes are non-breaking configuration updates, so rollback is low-risk.

---

## Future Improvements (Not in This Phase)

1. **Matrix Testing**: Test against multiple Swift versions (5.7, 5.8, 5.9)
2. **Artifact Generation**: Generate and upload release artifacts
3. **Fastlane Integration**: Use fastlane in CI pipeline instead of just locally
4. **Windows Support**: Add Windows runner if needed
5. **Performance Benchmarks**: Track build performance over time
6. **Dependency Updates**: Automatic dependency updates with Dependabot

---

## Success Criteria

✅ All critical updates applied
✅ CI passes on both platforms
✅ Build time reduced by ~50% with caching
✅ Documentation created
✅ No breaking changes to project

---

## Questions or Issues?

If you encounter issues during implementation:

1. Check the error messages in GitHub Actions logs
2. Run `swift build -v` locally to reproduce issues
3. Verify Swift version: `swift --version`
4. Check Ruby version: `ruby --version`

All changes are low-risk configuration updates with immediate rollback capability.
