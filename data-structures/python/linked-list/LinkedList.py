#!/usr/bin/env python3

class SinglyLinkedNode:
    def __init__(self, value):
        self.value = value
        self.next = None

    def __str__(self):
        return f'Node({self.value})'

# sNode = SinglyLinkedNode(1)
# print(sNode)

class DoublyLinkedNode(SinglyLinkedNode):
    """docstring for DoublyLinkedNode"""
    def __init__(self, value):
        super(DoublyLinkedNode, self).__init__(value)
        self.previous = None

# dNode = DoublyLinkedNode(1)
# print(dNode)

class SinglyLinkedList:
    """docstring for LinkedList"""
    def __init__(self):
        self.head = None
        self.tail = None

    def __str__(self):
        return ' --> '.join(str(n) for n in self.to_node_array())

    def append(self, v):
        node = SinglyLinkedNode(v)
        if self.head is None:
            self.head = node
        else:
            self.tail.next = node
        self.tail = node

    def to_node_array(self):
        values = []
        node = self.head
        while node is not None:
            values.append(node)
            node = node.next
        return values

    def to_list(self):
        return list(map(lambda n: n.value, self.to_node_array()))

# sList = SinglyLinkedList()
# [sList.append(v) for v in list(range(10))]
# print(sList)
# print(sList.to_list())

class DoublyLinkedList(SinglyLinkedList):
    """docstring for DoublyLinkedList"""
    def __init__(self):
        super(DoublyLinkedList, self).__init__()

    def __str__(self):
        return ' <--> '.join(str(n) for n in self.to_node_array())

    def append(self, v):
        node = DoublyLinkedNode(v)
        if self.head is None:
            self.head = node
        else:
            node.previous = self.tail
            self.tail.next = node
        self.tail = node

# dList = DoublyLinkedList()
# [dList.append(v) for v in list(range(10))]
# print(dList)
# print(dList.to_list())

