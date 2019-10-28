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

/*
 TASK 4:
 The telephone company want to identify numbers that might be doing
 telephone marketing. Create a set of possible telemarketers:
 these are numbers that make outgoing calls but never send texts,
 receive texts or receive incoming calls.

 Print a message:
 "These numbers could be telemarketers: "
 <list of numbers>
 The list of numbers should be print out one per line in lexicographic order with no duplicates.
 */
//: [Next](@next)


var ignoreThese: Set<String> = []
var possibleTelemarketers = [String]()


// for text in text
//    cache sender phone # in ignoreThese
//    cache receiver phone # in ignoreThese
let texts = readCSV(in: "texts")
if let textData = readCSV(in: "texts") {
  for textString in textData {
    if textString.isEmpty { continue }
    let text = TextMessage(textString)
    ignoreThese.insert(text.sender)
    ignoreThese.insert(text.recipient)
  }
}


if let callData = readCSV(in: "calls") {
  // For call in
  for callString in callData {
    if callString.isEmpty { continue }
    let call = PhoneCall(callString)

    // cache receiver phone # in ignoreThese
    ignoreThese.insert(call.recipient)
  }

  // for call in calls
  for callString in callData {
    if callString.isEmpty { continue }
    let call = PhoneCall(callString)

    // skip if sender phone # in ignoreThese
    if ignoreThese.contains(call.sender) { continue }

    // append sender phone # to possibleTelemarketers
    possibleTelemarketers.append(call.sender)

    // ensure number is only added once
    ignoreThese.insert(call.sender)
  }

}

print("These numbers could be telemarketers:\n\(possibleTelemarketers.joined(separator: "\n"))")



