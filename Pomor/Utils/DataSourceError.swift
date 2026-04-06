import Foundation

enum DataSourceError: Error {
    case encodingFailed
    case decodingFailed
    case persistenceFailed
}
