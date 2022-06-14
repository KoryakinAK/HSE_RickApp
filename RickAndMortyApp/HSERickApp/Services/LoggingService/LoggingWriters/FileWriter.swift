import Foundation

final class FileWriter: LogWriterProtocol {
    private lazy var filename = getDocumentsDirectory().appendingPathComponent("output.txt")

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func write(message: String) {
        let messageWithNewLine = message + "\n"
        if let fileUpdater = try? FileHandle(forUpdating: filename) {
            fileUpdater.seekToEndOfFile()
            fileUpdater.write(messageWithNewLine.data(using: .utf8)!)
            fileUpdater.closeFile()
        } else {
            do {
                try messageWithNewLine.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("File write error")
            }
        }
    }
}
