## Current Implementation below only works for strings.


fn hash(key: String, size: Int = 100) -> Int:
    """
    Very basic hash function that takes a string, converts each character to
    its ascii value, multiplies it by its index in the string, and sums them
    all together. Then it mods the sum by the size of the hash table to get
    the index of the bucket to place the key in.
    """
    var hash_value: Int = 0
    for idx in range(len(key)):
        hash_value += ord(key[idx]) * (idx + 1)
    return hash_value % size


@value
struct HashNode(CollectionElement, Stringable):
    var key: String
    var value: String

    fn __str__(self) -> String:
        return self.key + " -> " + str(self.value)


@value
struct HashBucket(CollectionElement, Stringable):
    var nodes: DynamicVector[HashNode]

    fn __init__(inout self):
        self.nodes = DynamicVector[HashNode]()

    fn __str__(self) -> String:
        var result: String = "Bucket Size: " + str(len(self.nodes)) + "\n"
        for idx in range(len(self.nodes)):
            result += str(self.nodes[idx]) + "\n"
        return result

    fn __getitem__(self, key: String) raises -> String:
        for idx in range(len(self.nodes)):
            if self.nodes[idx].key == key:
                return self.nodes[idx].value
        raise Error("Key not found")

    fn __setitem__(inout self, key: String, value: String):
        for idx in range(len(self.nodes)):
            # If the key already exists, update the value
            if self.nodes[idx].key == key:
                self.nodes[idx].value = value
                return
        self.nodes.push_back(HashNode(key, value))


@value
struct HashTable(Stringable):
    var buckets: DynamicVector[HashBucket]
    var size: Int
    var capacity: Int

    fn __init__(inout self, capacity: Int = 100):
        self.size = 0
        self.capacity = capacity
        self.buckets = DynamicVector[HashBucket]()
        for idx in range(self.capacity):
            self.buckets.push_back(HashBucket())

    fn __getitem__(self, key: String) raises -> String:
        let index = hash(key, self.capacity)
        let bucket = self.buckets[index]
        return bucket[key]

    fn __setitem__(inout self, key: String, value: String):
        let index = hash(key)
        self.buckets[index][key] = value
        self.size += 1

    fn __str__(self) -> String:
        var result: String = "Table Size: " + str(len(self.buckets)) + "\n"
        for idx in range(len(self.buckets)):
            result += str(self.buckets[idx]) + "\n"
        return result
