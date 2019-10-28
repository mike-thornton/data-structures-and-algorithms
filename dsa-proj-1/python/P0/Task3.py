"""
Read file into texts and calls.
It's ok if you don't understand how to read files.
"""
import csv

with open('texts.csv', 'r') as f:
    reader = csv.reader(f)
    texts = list(reader)

with open('calls.csv', 'r') as f:
    reader = csv.reader(f)
    calls = list(reader)

"""
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

Part B: What percentage of calls from fixed lines in Bangalore are made
to fixed lines also in Bangalore? In other words, of all the calls made
from a number starting with "(080)", what percentage of these calls
were made to a number also starting with "(080)"?

Print the answer as a part of a message::
"<percentage> percent of calls from fixed lines in Bangalore are calls
to other fixed lines in Bangalore."
The percentage should have 2 decimal digits
"""
def phoneCall(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'date': data[2],
		'duration': int(data[3]),
	}

def isFixedLine(phonenumber): return phonenumber[:1] == "("
# print(f"isFixedLine(\'(\'): should return True --> {isFixedLine('(')}")
# print(f"isFixedLine(\'080\'): should return False --> {isFixedLine('080')}")

def isMobileNumber(phonenumber): return phonenumber[:1] in ['7','8','9']
# print(f"isMobileNumber(\'800\'): should return True --> {isMobileNumber('800')}")
# print(f"isMobileNumber(\'5\'): should return False --> {isMobileNumber('(0')}")

def isTelemarketer(phonenumber): return phonenumber[:3] == '140'
# print(f"isTelemarketer(\'140\'): should return True --> {isTelemarketer('140')}")
# print(f"isTelemarketer(\'141\'): should return False --> {isTelemarketer('141')}")

def areaCodeFor(phonenumber):
	if isTelemarketer(phonenumber): return '140'
	elif isMobileNumber(phonenumber): return phonenumber[:4]
	return phonenumber[1:phonenumber.index(')')]
# print(f"areaCodeFor(\'1405555555\'): should return 140 --> {areaCodeFor('1405555555')}")
# print(f"areaCodeFor(\'89784 44433\'): should return 8978 --> {areaCodeFor('89784 44433')}")
# print(f"areaCodeFor(\'(080)44444433\'): should return 080 --> {areaCodeFor('(080)44444433')}")


areaCodes = []

count = 0.0
total = 0.0

for callData in calls:
	call = phoneCall(callData)
	sender, recipient = areaCodeFor(call['sender']), areaCodeFor(call['recipient'])
	if sender == "080":
		total += 1
		if recipient == "080": 
			count += 1
		if recipient not in areaCodes:
			areaCodes.append(recipient)

print("The numbers called by people in Bangalore have codes:")
print(*areaCodes, sep='\n')

print(f'{((count/total)*100):.2f} percent of calls from fixed lines in Bangalore are calls to other fixed lines in Bangalore.')

# Runtime complexity (Big-O): O(n)
# 		Linear relationship to input volume.
# 		While we are evaluating each input element multiple times, 
# 		the computation complexity remains linear.