// AriseMobileSdk
// This wrapper ensures dependencies are linked with the binary frameworks
// The binary frameworks (AriseMobileSdkBinary and CloudCommerce) are linked through dependencies

import Foundation

// Import binary frameworks (module names come from XCFramework, not target names)
// AriseMobileSdkBinary target provides "AriseMobileSdk" module
// CloudCommerce target provides "CloudCommerce" module
@_exported import AriseMobileSdk
@_exported import CloudCommerce

// Re-export dependencies that are required by the binary frameworks
@_exported import OpenAPIRuntime
@_exported import OpenAPIURLSession
@_exported import CryptoSwift
@_exported import SwiftASN1
@_exported import X509
