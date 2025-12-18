# AriseMobileSdk v2

Swift Package Manager distribution of AriseMobileSdk iOS SDK (Version 2).

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Using Swift Package Manager

#### From Git Repository (Recommended)

**For Public Repository:**
1. In Xcode: **File** → **Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/your-org/arise-merchant-app.git
   ```
3. Select version **2.0.0** or later from the version/tag list

**For Private Repository:**
1. Set up SSH access (recommended):
   - Ensure your SSH key is added to GitHub: `ssh-keygen -t ed25519` then add `~/.ssh/id_ed25519.pub` to GitHub
   - Use SSH URL: `git@github.com:your-org/arise-merchant-app.git`

2. Or use Personal Access Token:
   - Create token in GitHub: Settings → Developer settings → Personal access tokens
   - Use HTTPS URL: `https://github.com/your-org/arise-merchant-app.git`
   - Xcode will prompt for credentials (username: your GitHub username, password: your token)

3. Select version **2.0.0** or later from the version/tag list

#### Using Package.swift

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/your-org/arise-merchant-app.git",
        from: "2.0.0"
    )
]
```

#### Specific Version

```swift
dependencies: [
    .package(
        url: "https://github.com/your-org/arise-merchant-app.git",
        exact: "2.0.0"
    )
]
```

#### Version Range

```swift
dependencies: [
    .package(
        url: "https://github.com/your-org/arise-merchant-app.git",
        "2.0.0"..<"3.0.0"
    )
]
```

### Local Installation

For local development:

1. In Xcode: **File** → **Add Package Dependencies...**
2. Click **Add Local...**
3. Navigate to this directory and select it

## Usage

```swift
import AriseMobileSdk

// Initialize the SDK
let sdk = try AriseMobileSdk(environment: .uat)

// Authenticate
let authResult = try await sdk.authenticate(
    clientId: "your-client-id",
    clientSecret: "your-client-secret"
)

// Use the SDK...
```

## Versioning

This package uses [Semantic Versioning](https://semver.org/):
- **Major version** (2.x.x): Breaking changes
- **Minor version** (x.1.x): New features, backward compatible
- **Patch version** (x.x.1): Bug fixes, backward compatible

Versions are tagged in Git as `v2.0.0`, `v2.1.0`, etc.

## Package Structure

This is a binary-only package containing:
- `AriseMobileSdk.xcframework` - The main SDK framework (includes embedded CloudCommerce framework)

## Notes

- CloudCommerce framework is already embedded in AriseMobileSdk.xcframework
- This package contains only binary frameworks (XCFramework), not source code
- The package requires iOS 15.0 or later

## Git Tags

To create a new version, use the provided script:

```bash
cd Distribution/AriseMobileSdk-v2
./create_version.sh 2.0.1
```

The script will:
1. Update version in Info.plist
2. Build XCFramework (if build script exists)
3. Copy binaries to package
4. Create Git tag
5. Push tag to remote (optional)

Or manually:

```bash
git tag v2.0.0
git push origin v2.0.0
```

Swift Package Manager will automatically detect and offer this version when adding the package.










