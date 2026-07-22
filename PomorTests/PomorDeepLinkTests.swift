import Foundation
import PomorCore
import Testing

struct PomorDeepLinkTests {

    @Test func homeURL_roundTrips() {
        let link = PomorDeepLink.home

        #expect(link.url.scheme == "pomor")
        #expect(link.url.host == "app")
        #expect(link.url.path == "/home")
        #expect(PomorDeepLink.parse(link.url) == .home)
    }

    @Test func timerURL_roundTrips() {
        let taskId = UUID()
        let link = PomorDeepLink.timer(taskId: taskId)

        #expect(link.url.scheme == "pomor")
        #expect(link.url.host == "app")
        #expect(link.url.path == "/timer/\(taskId.uuidString)")
        #expect(PomorDeepLink.parse(link.url) == .timer(taskId: taskId))
    }

    @Test func parse_rejectsUnknownScheme() {
        let url = URL(string: "https://example.com/app/timer/\(UUID().uuidString)")!

        #expect(PomorDeepLink.parse(url) == nil)
    }

    @Test func parse_rejectsUnknownHost() {
        let url = URL(string: "pomor://other/timer/\(UUID().uuidString)")!

        #expect(PomorDeepLink.parse(url) == nil)
    }

    @Test func parse_rejectsUnknownDestination() {
        let url = URL(string: "pomor://app/settings")!

        #expect(PomorDeepLink.parse(url) == nil)
    }

    @Test func parse_rejectsInvalidTaskId() {
        let url = URL(string: "pomor://app/timer/not-a-uuid")!

        #expect(PomorDeepLink.parse(url) == nil)
    }

    @Test func destinations_areStableRawValues() {
        #expect(PomorDeepLink.Destination.home.rawValue == "home")
        #expect(PomorDeepLink.Destination.timer.rawValue == "timer")
    }
}
