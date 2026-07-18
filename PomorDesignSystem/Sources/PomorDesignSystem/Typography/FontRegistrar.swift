import CoreText
import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum FontRegistrar {
    private static let fileNames = [
        "Nunito-Regular",
        "Nunito-Medium",
        "Nunito-SemiBold",
        "Nunito-Bold",
        "Nunito-ExtraBold",
        "Nunito-Black",
        "NunitoSans-Regular",
        "NunitoSans-Medium",
        "NunitoSans-SemiBold",
        "NunitoSans-Bold",
    ]

    private static let lock = NSLock()
    nonisolated(unsafe) private static var didRegister = false

    /// Registra as fontes do package (`Bundle.module`).
    /// Chamar uma vez no launch do app.
    public static func register() {
        lock.lock()
        defer { lock.unlock() }
        guard !didRegister else { return }
        didRegister = true

        for name in fileNames {
            guard let url = Bundle.module.url(forResource: name, withExtension: "ttf", subdirectory: "Fonts")
                    ?? Bundle.module.url(forResource: name, withExtension: "ttf") else {
                #if DEBUG
                print("⚠️ Font file missing from PomorDesignSystem: \(name).ttf")
                #endif
                continue
            }

            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        }

        #if DEBUG
        verify()
        #endif
    }

    #if DEBUG
    private static func verify() {
        #if canImport(UIKit)
        print("🔤 PomorDesignSystem fonts:")
        for name in fileNames {
            let found = UIFont(name: name, size: 12) != nil
            print(found ? "  ✅ \(name)" : "  ❌ \(name) NOT FOUND")
        }
        #endif
    }
    #endif
}
