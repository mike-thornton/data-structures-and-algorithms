class ListNode(object):
    """docstring for ListNode"""
    def __init__(self, value):
        self.value = value
        self.next = None

class Queue(object):
    """docstring for Queue"""
    def __init__(self):
        self.front = None
        self.back = None
        self._count = 0

    @property
    def values(self): 
        node = self.front
        result = []
        while node is not None:
            result.append(node.value)
            node = node.next
        return result
    
    @property
    def isEmpty(self): return self._count == 0

    @property
    def count(self): return self._count

    def enqueue(self, value=None):
        """ Adds a new ListNode with a provided value.

        Keyword arguements
        value -- the value of ListNode to be created (defaul None)
        """
        if value is None: return
        newNode = ListNode(value)
        
        if self.front is None:
            self.front = newNode
            self.back = newNode
        else:
            lastNode = self.back
            lastNode.next = newNode
            self.back = newNode

        self._count += 1

    def dequeue(self):
        """ Returns the value of the most senior enqueued Node. """
        if self.front is None: return None
        frontNode = self.front
        self.front = frontNode.next
        self._count -= 1
        return frontNode.value

class LRUCache(object):
    """docstring for LRUCache"""
    def __init__(self, capacity):
        super(LRUCache, self).__init__()
        self.capacity = capacity
        self.cache = {}
        self.keyQueue = Queue()
        
    def get(self, key=None):
        """ Retrieve item from provided key. Return -1 if nonexistent. """
        if key is None: return -1
        return -1 if key not in self.cache else self.cache[key]

    def set(self, key=None, value=None):
        """ Set the value if the key is not present in the cache. If the cache is at capacity remove the oldest item. """
        keyQueue, cache, capacity = self.keyQueue, self.cache, self.capacity
        if key is None: return
        if keyQueue.count < capacity:
            if key in cache :
                cache[key] = value
            else:
                cache[key] = value
                keyQueue.enqueue(key)
        else:
            if key in cache:
                cache[key] = value
            else:
                # remove oldest key from queue, and re-call set()
                keyQueue.dequeue()
                self.set(key, value)

# Tests
# our_cache = LRUCache(5)

# our_cache.set(1, 1);
# our_cache.set(2, 2);
# our_cache.set(3, 3);
# our_cache.set(4, 4);


# our_cache.get(1)       # returns 1
# our_cache.get(2)       # returns 2
# our_cache.get(9)      # returns -1 because 9 is not present in the cache

# our_cache.set(5, 5) 
# our_cache.set(6, 6)

# our_cache.get(3)      # returns -1 because the cache reached it's capacity and 3 was the least recently used entry
