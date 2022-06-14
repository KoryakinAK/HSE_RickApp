import Foundation

final class ConsoleWriter: LogWriterProtocol {
    func write(message: String) {
        print(message)
    }
}
