local FuzzyWuzzy = {}
FuzzyWuzzy.__index = FuzzyWuzzy

function FuzzyWuzzy.levenshteinDistance(str1: string, str2: string)
	local len1, len2 = #str1, #str2
	local matrix = {}

	for i = 0, len1 do
		matrix[i] = {[0] = i}
	end
	for j = 0, len2 do
		matrix[0][j] = j
	end

	-- Fill matrix~
	for i = 1, len1 do
		for j = 1, len2 do
			local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
			matrix[i][j] = math.min(
				matrix[i-1][j] + 1,      -- deletion
				matrix[i][j-1] + 1,      -- insertion (ahh~!)
				matrix[i-1][j-1] + cost  -- substitution (cuck)
			)
		end
	end

	return matrix[len1][len2]
end

local function calculateSimilarity(str1, str2)
	if #str1 == 0 and #str2 == 0 then return 1 end

	local distance = FuzzyWuzzy.levenshteinDistance(str1, str2)
	local maxLen = math.max(#str1, #str2)

	return 1 - (distance / maxLen)
end

function FuzzyWuzzy:search(needle: string, haystack: { string }, options)
	options = options or {}
	local threshold = options.threshold or 0.5
	local caseSensitive = options.caseSensitive or false
	local limit = options.limit
	local prefixBonus = options.prefixBonus or 0.1 --// Optional bonus value

	local results = {}
	local processedNeedle = caseSensitive and needle or string.lower(needle)

	for i, item in ipairs(haystack) do
		local processedItem = caseSensitive and item or string.lower(item)
		local score = calculateSimilarity(processedNeedle, processedItem)

		--// apply prefix bonus
		if processedItem:sub(1, #processedNeedle) == processedNeedle then
			score = score + prefixBonus * (1 - score)
		end

		if score >= threshold then
			table.insert(results, {
				item = item,
				index = i,
				score = score
			})
		end

		print(item, "score:", score, "prefix match:", processedItem:sub(1, #processedNeedle) == processedNeedle)
	end

	table.sort(results, function(a, b)
		return a.score > b.score
	end)

	if limit and limit > 0 and limit < #results then
		local limitedResults = {}
		for i = 1, limit do
			limitedResults[i] = results[i]
		end
		results = limitedResults
	end

	return results
end

return FuzzyWuzzy
