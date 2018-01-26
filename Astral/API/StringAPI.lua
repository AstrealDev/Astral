local API = {};

--// Returns a random string with a given length
function API:genRandomString(len)
	--// Create a character set which will contain the following characters:
	--// "-./qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
	local charset = {};

	--// Fill the character set table by using internal numeric values	
	for i = 45, 57 do
		table.insert(charset, string.char(i));
	end
	for i = 65, 90 do
		table.insert(charset, string.char(i));
	end
	for i = 97, 122 do
		table.insert(charset, string.char(i));
	end
	
	--// A function which returns one character of a randomized string and then repeats itself
	--// to continue returning characters until the length is met
	function rand(length)
		math.randomseed(tick());
		if length > 0 then
			return rand(length - 1) .. charset[math.random(1, #charset)];
		else
			return "";
		end
	end
	
	--// Create a table called s which stands for string
	local s = {};
	
	--// Fill it with all the returned values of the function rand
	table.insert(s, rand(len));
	
	--// Return the concatenated table as a string
	return table.concat(s);
end

--// A quick method for subbing a string
function API:Sub(str, start, final)
	return string.sub(str, start, final);
end

--// A quick method for getting string length
function API:Len(str)
	return string.len(str);
end

--// A quick method for lowering a strng
function API:Low(str)
	return string.lower(str);
end

--// A quick method for matching a string
function API:Match(str, pat)
	return string.match(str, pat);
end

return API;