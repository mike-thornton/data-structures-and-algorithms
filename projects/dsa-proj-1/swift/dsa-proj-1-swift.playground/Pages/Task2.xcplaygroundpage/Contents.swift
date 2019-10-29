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

/*
 TASK 2: Which telephone number spent the longest time on the phone
 during the period? Don't forget that time spent answering a call is
 also time spent on the phone.
 Print a message:
 "<telephone number> spent the longest time, <total time> seconds, on the phone during
 September 2016.".
 */

var currentMax = (id: "", time: -1)
var phoneTime = [String: Int]()

func recordDuration(call: PhoneCall) {
  let time = (sender: (phoneTime[call.sender] ?? 0) + call.duration,
              recipient: (phoneTime[call.recipient] ?? 0) + call.duration)
  phoneTime[call.sender] = time.sender
  phoneTime[call.recipient] = time.recipient

  if time.sender > currentMax.time && time.sender > time.recipient {
    currentMax = (id: call.sender, time: time.sender)
  } else if time.recipient > currentMax.time {
    currentMax = (id: call.recipient, time: time.recipient)
  }
}

if let callStrings = readCSV(in: "calls") {
  callStrings.forEach {
    if !$0.isEmpty {
      recordDuration(call: PhoneCall($0))
    }
  }
}

print("\(currentMax.id) spent the longest time, \(currentMax.time) seconds, on the phone during September 2016.")



//: [Next](@next)
