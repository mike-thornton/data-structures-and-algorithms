//: [Previous](@previous)
import Foundation

func readCSV(in filename: String) -> [String]? {
  guard let textsURL = Bundle.main.url(forResource: filename, withExtension: "csv") else {
    return nil
  }
  do {
    let fileContent = try String(contentsOf: textsURL, encoding: String.Encoding.utf8)
    return fileContent.components(separatedBy: NSCharacterSet.newlines)
  } catch {
    print("Error parsing csv file named: \(filename)")
  }
  return nil

}

protocol CommunicationRecord {
  var sender: String { get set }
  var recipient: String { get set }
  var date: Date { get set }
}

extension CommunicationRecord {

  static var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "MM-dd-yyyy hh:mm:ss"
    return df
  }

  static func parse(csvRow text: String) -> (String, String, Date, Int?) {
    let data = text.split(separator: ",")
    let sender = String(data[0])
    let recipient = String(data[1])
    let date = Self.dateFormatter.date(from: String(data[2])) ?? Date()
    var duration: Int? = nil

    if let last = data.last, let num = Int(String(last)) {
      let num = NSNumber(value: num)
      duration = num.intValue
    }
    return(sender, recipient, date, duration)
  }

}

struct PhoneCall: CommunicationRecord {
  var sender: String
  var recipient: String
  var date: Date

  var duration: Int

  init(_ csvString: String) {
    let (sender, recipient, date, duration) = Self.parse(csvRow: csvString)
    self.sender = sender
    self.recipient = recipient
    self.date = date
    self.duration = duration ?? 0
  }

}

"""
TASK 1:
How many different telephone numbers are there in the records?
Print a message:
"There are <count> different telephone numbers in the records."
"""

var ids = Set<String>()

if let callStrings = readCSV(in: "calls") {
  callStrings.forEach {
    if !$0.isEmpty {
      let call = PhoneCall($0)
      if !ids.contains(call.sender) { ids.insert(call.sender) }
      if !ids.contains(call.recipient) { ids.insert(call.recipient) }
    }
  }
}
print("There are \(ids.count) different telephone numbers in the records.")
//: [Next](@next)
