"""
Read file into texts and calls.
It's ok if you don't understand how to read files
"""
import csv
with open('texts.csv', 'r') as f:
    reader = csv.reader(f)
    texts = list(reader)

with open('calls.csv', 'r') as f:
    reader = csv.reader(f)
    calls = list(reader)

"""
TASK 2: Which telephone number spent the longest time on the phone
during the period? Don't forget that time spent answering a call is
also time spent on the phone.
Print a message:
"<telephone number> spent the longest time, <total time> seconds, on the phone during 
September 2016.".
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

leader = None
leaderTime = -1

callTimes = {}

def recordDuration(call):
	sender, recipient, duration = call['sender'], call['recipient'], call['duration']
	# update the call times dict
	senderTime = duration if sender not in callTimes else duration + callTimes[sender]
	recipientTime = duration if recipient not in callTimes else duration + callTimes[recipient]
	callTimes[sender] = senderTime
	callTimes[recipient] = recipientTime
	
	# update the current leader
	global leaderTime, leader
	if senderTime >= recipientTime and senderTime > leaderTime:
		leader = sender
		leaderTime = senderTime
	elif recipientTime > leaderTime:
		leader = recipient
		leaderTime = recipientTime

for callData in calls:
	recordDuration(phoneCall(callData))

print(f"{leader} spent the longest time, {leaderTime} seconds, on the phone during September 2016.")

# Runtime complexity (Big-O): O(n)
