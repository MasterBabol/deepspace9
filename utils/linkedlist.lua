--[[
    Author: LouiseBC
    Source From: https://gist.github.com/LouiseBC/692bfd907d9e0527b471947d540dee6c
--]]

-- Circular, doubly linked list --
----------------------------------

local linkedList = {}

-- Creates a list from table or variable n. of values --
function linkedList.construct(...)
	local args = {...}
	local tail = linkedList.newNode(args[1])
	for i = 2, #args do
		linkedList.insert(tail, args[i])
		tail = tail.next
	end
	return tail.next
end

-- Creates a new instance of node --
function linkedList.newNode(val)
	local node = {}
	node.value = val
	node.next = node
	node.prev = node
	return node
end

-- Inserts a node after the given node && returns a reference --
function linkedList.insert(node, val)
	local newnode = linkedList.newNode(val)
	newnode.next = node.next
	newnode.prev = node
    node.next.prev = newnode -- MODIFICATION
	node.next = newnode
	return newnode
end

-- Remove an element of the list, return reference to next element --
function linkedList.erase(node)
	local index = node.next
    if index == node then
        return nil
    end
	node.prev.next = node.next
    node.next.prev = node.prev -- MODIFICATION
	-- node = nil -- MODIFICATION: futile statement
	return index
end

-- Print the whole list, avoiding circularity --
function linkedList.print(node)
	local it = node
	repeat
		print(it.value)
		it = it.next
	until it == node
end

return linkedList