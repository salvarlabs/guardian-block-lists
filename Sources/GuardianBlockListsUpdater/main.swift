#! /usr/bin/env xcrun swift -F ../build/Debug

import Foundation
//
//print("Hello, world!")
//
//do {
//    try? updater.fetchLists()
//} catch {
//    print("Err")
//}
//print("did it work?")

//public func fetchLists() {
//    print("Fetching lists...")
////        let urlSource = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
//    let urlSource = "https://run.mocky.io/v3/e86ea78a-f137-4c42-b788-4fc143ad8979"
//    guard let url = URL(string: urlSource) else {return}
//    print("Mounted url")
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        DispatchQueue.main.async {
//            print("Coming back to main thread")
//        }
//        print("Session started")
//        if let httpResponse = response as? HTTPURLResponse {
//            print(httpResponse.statusCode)
//        }
//        if let data = data, let dataString = String(data: data, encoding: .utf8) {
//            print(dataString)
//        }
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//    task.resume()
//}
//
//fetchLists()


//var sema = DispatchSemaphore( value: 0 )
//
//class Delegate : NSObject, URLSessionDataDelegate
//{
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
//    {
//        print("got data \(String(data: data, encoding: .utf8 ) ?? "<empty>")");
//        sema.signal()
//    }
//}
//
//let config = URLSessionConfiguration.default
//let session = URLSession(configuration: config, delegate: Delegate(), delegateQueue: nil )
//
//guard let url = URL( string:"http://apple.com" ) else { fatalError("Could not create URL object") }
//
//session.dataTask( with: url ).resume()
//
//sema.wait()

public class Updater: NSObject, URLSessionDelegate {
    
    var sema = DispatchSemaphore( value: 0 )
    let exceptions = ["0.0.0.0", "example.com", "google.com"]
    public enum UpdaterError: Error {
        case sourceRootNotProvided
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        print("got data \(String(data: data, encoding: .utf8 ) ?? "<empty>")");
        sema.signal()
    }
    
    public func fetchLists() throws {
        guard let sourceRoot = ProcessInfo.processInfo.environment["SRCROOT"] else {
            throw UpdaterError.sourceRootNotProvided
        }
        print("Fetching lists...")
        let urlSource = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        guard let url = URL(string: urlSource) else {return}
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url) { data, response, netError in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let sourceRootFile = "\(sourceRoot)/Sources/GuardianBlockLists/Lists/adlist.txt"
                let lines = dataString.components(separatedBy: .newlines)
                for (index, line) in lines.enumerated() {
                    let indexCount = (Double(index) / Double(lines.count)) * 10
                    let left = 10 - indexCount
                    let dots = String(repeating: ".", count: Int(indexCount))
                    let empty = String(repeating: " ", count: Int(left))
                    print("\u{001B}[2J")
                    print("Generating list file...")
                    print("\r[\(dots)\(empty)]", terminator: "")
                    fflush(stdout)
                    if line.range(of: #"[0.]{7}"#, options: .regularExpression) != nil {
                        let domain = line.split(separator: " ")
                        guard let host = domain.last else {return}
                        if !self.exceptions.contains(String(host)) {
                            do {
                                if FileManager.default.fileExists(atPath: sourceRootFile) {
                                    let hostLine = "\n\(host)"
                                    let fileHandle = try? FileHandle(forWritingTo: URL(string: sourceRootFile)!)
                                    fileHandle?.seekToEndOfFile()
                                    fileHandle?.write(hostLine.data(using: .utf8)!)
                                    fileHandle?.closeFile()
                                } else {
                                    let hostLine = "\n\(host)"
                                    try hostLine.write(toFile: sourceRootFile, atomically: false, encoding: .utf8)
                                }
                            } catch {
                                print("Error building the list: \(error.localizedDescription)")
                                exit(EXIT_FAILURE)
                            }
                        }
                    }
                }
                print("\nDone.")
                exit(EXIT_SUCCESS)                
            }
            if let error = netError {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
        sema.wait()
    }
    
}

let updater = Updater()
do {
    try updater.fetchLists()
} catch {
    print("\(error.localizedDescription)")
}
