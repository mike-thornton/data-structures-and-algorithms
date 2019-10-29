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
TASK 4:
The telephone company want to identify numbers that might be doing
telephone marketing. Create a set of possible telemarketers:
these are numbers that make outgoing calls but never send texts,
receive texts or receive incoming calls.

Print a message:
"These numbers could be telemarketers: "
<list of numbers>
The list of numbers should be print out one per line in lexicographic order with no duplicates.
"""
def phoneCall(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'date': data[2],
		'duration': int(data[3]),
	}

def textMessage(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'date': data[2]
	}

ignoreThese = []
possibleTelemarketers = []

for textData in texts:
	text = textMessage(textData)
	ignoreThese.append(text["sender"])
	ignoreThese.append(text["recipient"])

for callData in calls:
	recipient = phoneCall(callData)['recipient']
	ignoreThese.append(recipient)

for callData in calls:
	sender = phoneCall(callData)['sender']
	if sender not in ignoreThese: 
		possibleTelemarketers.append(sender)
		ignoreThese.append(sender) # ensure number is only added once

possibleTelemarketers.sort()

print("These numbers could be telemarketers:")
print(*possibleTelemarketers, sep='\n')

# Runtime complexity (Big-O): O(n log n)
