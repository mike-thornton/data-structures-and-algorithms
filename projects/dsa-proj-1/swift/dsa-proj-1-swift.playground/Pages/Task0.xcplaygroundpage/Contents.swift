import Foundation


/**
 * Read file into texts and calls.
 * It's ok if you don't understand how to read files.
 */
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

protocol CommunicationRecord: CustomStringConvertible {
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

extension PhoneCall: CustomStringConvertible {
  var description: String {
    return "\(sender) calls \(recipient) at time \(PhoneCall.dateFormatter.string(from: date)), lasting \(duration) seconds"
  }
}

struct TextMessage: CommunicationRecord {
  var sender: String
  var recipient: String
  var date: Date

  init(_ csvString: String) {
    let (sender, recipient, date, _) = Self.parse(csvRow: csvString)
    self.sender = sender
    self.recipient = recipient
    self.date = date
  }

}

extension TextMessage: CustomStringConvertible {
  var description: String {
    return "\(sender) texts \(recipient) at time \(PhoneCall.dateFormatter.string(from: date))"
  }
}


/*
 * TASK 0:
 * What is the first record of texts and what is the last record of calls?
 * Print messages:
 * "First record of texts, <incoming number> texts <answering number> at time <time>"
 * "Last record of calls, <incoming number> calls <answering number> at time <time>, lasting <during> seconds"
 */

let calls = readCSV(in: "calls")
if let calls = calls, let callData = calls.last {
  let call = PhoneCall(callData)
  print("Last record of calls, \(call)")
}

let texts = readCSV(in: "texts")
if let texts = texts, let textData = texts.first {
  let text = TextMessage(textData)
  print("First record of texts, \(text)")
}

//: [Next](@next)
