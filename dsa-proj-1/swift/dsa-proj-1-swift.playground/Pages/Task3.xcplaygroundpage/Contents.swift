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
 TASK 3:
 (080) is the area code for fixed line telephones in Bangalore.
 Fixed line numbers include parentheses, so Bangalore numbers
 have the form (080)xxxxxxx.)

 Part A: Find all of the area codes and mobile prefixes called by people
 in Bangalore.
  - Fixed lines start with an area code enclosed in brackets. The area
    codes vary in length but always begin with 0.
  - Mobile numbers have no parentheses, but have a space in the middle
    of the number to help readability. The prefix of a mobile number
    is its first four digits, and they always start with 7, 8 or 9.
  - Telemarketers' numbers have no parentheses or space, but they start
    with the area code 140.

 Print the answer as part of a message:
 "The numbers called by people in Bangalore have codes:"
  <list of codes>
 The list of codes should be print out one per line in lexicographic order with no duplicates.

 */

struct PhoneNumber {
  let text: String

  var firstChar: String { String(text[..<text.index(text.startIndex, offsetBy: 1)]) }

  var isFixedLine: Bool { self.firstChar == "(" }

  var isMobileNumber: Bool { Set<String>(["7","8","9"]).contains(firstChar) }

  var isTelemarketer: Bool {
    let areaDigits = text[..<text.index(text.startIndex, offsetBy: 3)]
    return String(areaDigits) == "140"
  }

  var areaCode: String {
    if isTelemarketer { return "140" }
    if isMobileNumber { return String(text[..<text.index(text.startIndex, offsetBy: 4)]) }
    let (start, end) = (text.index(after: text.startIndex), text.firstIndex(of: ")") ?? text.endIndex)
    return String(text[start..<end])
  }
}

extension PhoneCall {
  var senderPhoneNumber: PhoneNumber { PhoneNumber(text: self.sender) }
  var recipientPhoneNumber: PhoneNumber { PhoneNumber(text: self.recipient) }
}

var alreadyRecorded: Set<String> = []
var areaCodes = [String]()


// Part B
var count = 0.0
var total = 0.0


if let callStrings = readCSV(in: "calls") {
  for s in callStrings {
    if s.isEmpty { continue }
    let call = PhoneCall(s)
    guard call.senderPhoneNumber.areaCode == "080" else { continue }
    total += 1 // Part B
    if call.recipientPhoneNumber.areaCode == "080" {
      count += 1
    } // end Part B
    if alreadyRecorded.contains(call.recipientPhoneNumber.areaCode) { continue }
    areaCodes.append(call.recipientPhoneNumber.areaCode)
    alreadyRecorded.insert(call.recipientPhoneNumber.areaCode)

  }
}

print("The numbers called by people in Bangalore have codes:\n\(areaCodes.joined(separator: "\n"))")

/*
 """

 Part B: What percentage of calls from fixed lines in Bangalore are made
 to fixed lines also in Bangalore? In other words, of all the calls made
 from a number starting with "(080)", what percentage of these calls
 were made to a number also starting with "(080)"?

 Print the answer as a part of a message::
 "<percentage> percent of calls from fixed lines in Bangalore are calls
 to other fixed lines in Bangalore."
 The percentage should have 2 decimal digits
 """
 */

let message = String(format: "%.2f percent of calls from fixed lines in Bangalore are calls to other fixed lines in Bangalore.", (count/total)*100)
print(message)


//: [Next](@next)
