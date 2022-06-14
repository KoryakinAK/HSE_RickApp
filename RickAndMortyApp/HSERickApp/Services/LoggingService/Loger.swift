import Foundation

enum Level: Int {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
}

protocol LoggerProtocol {
    func log(level: Level, messages: String)
    func pause()
    func resume()
}

final class Loger: LoggerProtocol {

    func pause() {
        guard self.isPaused == false else { return }
        self.isPaused = true
        queue.suspend()
    }

    func resume() {
        guard self.isPaused == true else { return }
        self.isPaused = false
        queue.resume()
    }

    private var isPaused = false
    private var writers: [LogWriterProtocol]
    private let minLevel: Level
    private let queue = DispatchQueue(label: "logQueue", qos: .userInteractive)

    init(writers: [LogWriterProtocol], minLevel: Level) {
        self.writers = writers
        self.minLevel = minLevel
    }

    func log(level: Level, messages: String) {
        guard level.rawValue >= self.minLevel.rawValue else { return }
        self.queue.async {
            self.writers.forEach {
                $0.write(message: messages)
            }
        }
    }
}
