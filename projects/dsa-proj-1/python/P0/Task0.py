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
TASK 0:
What is the first record of texts and what is the last record of calls?
Print messages:
"First record of texts, <incoming number> texts <answering number> at time <time>"
"Last record of calls, <incoming number> calls <answering number> at time <time>, lasting <during> seconds"
"""
def datetime(str):
	[date, time] = str.split(' ')
	[MM,dd,yyyy] = date.split('-')
	[hh,mm,ss] = time.split(':')
	return(dd,MM,yyyy,hh,mm,ss)


def phoneCall(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'datetime': datetime(data[2]),
		'duration': int(data[3]),
	}

def textMessage(data):
	return {
		'sender': data[0],
		'recipient': data[1],
		'datetime': datetime(data[2]),
	}

text = textMessage(texts[0])
(dd,MM,yyyy,hh,mm,ss) = text['datetime']
print(f"First record of texts, {text['sender']} texts {text['recipient']} at time {hh}:{mm}")

call = phoneCall(calls[-1])
(dd,MM,yyyy,hh,mm,ss) = call['datetime']
print(f"Last record of calls, {call['sender']} calls {call['recipient']} at time {hh}:{mm}, lasting {call['duration']} seconds")

# Runtime complexity (Big-O): O(1)
# 		Only accessing 2 elements regardless of input size
