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

def datetime(str):
	[date, time] = str.split(' ')
	[MM,dd,yyyy] = date.split('-')
	[hh,mm,ss] = time.split(':')
	return(dd,MM,yyyy,hh,mm,ss)

def phoneCall(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'date': datetime(data[2]),
		'duration': int(data[3]),
	}

def textMessage(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'datetime': datetime(data[2]),
	}
"""
TASK 1:
How many different telephone numbers are there in the records? 
Print a message:
"There are <count> different telephone numbers in the records."
"""
phonenumbers = {}

for callData in calls:
	call = phoneCall(callData)
	phonenumbers[call["sender"]] = 1
	phonenumbers[call["recipient"]] = 1

for data in texts:
	text = textMessage(data)
	phonenumbers[text["sender"]] = 1
	phonenumbers[text["recipient"]] = 1



print(f"There are {len(phonenumbers)} different telephone numbers in the records.")


# Runtime complexity (Big-O): O(n)
