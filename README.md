# Fuzzy Wuzzy
Super simple fuzzy search module for Roblox with prefix bonuses.

Example:
```lua
local fuzzywuzzy = require(script:WaitForChild("FuzzyWuzzy"))

local startTime = os.clock()

local matches = fuzzywuzzy:search("cat", { "catalog", "scatter", "dog", "caterpillar" }, {
	threshold = 0.2,
	prefixBonus = 0.4,
})

local endTime = os.clock()

print(matches, "in ", endTime - startTime, " seconds")
```
