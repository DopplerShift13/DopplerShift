/// Checks to see if a string starts with http:// or https://
/proc/is_http_protocol(text)
	var/static/regex/http_regex
	if(isnull(http_regex))
		http_regex = new("^https?://")
	return findtext(text, http_regex)

/// Parses a JWT payload, returning it as a list.
/// This doesn't do signature verification or anything, I'm just using this to get the expiry time.
/proc/parse_jwt_payload(jwt) as /list
	var/list/split = splittext(jwt, ".")
	if(length(split) != 3)
		return null
	var/payload_base64 = split[2]
	// rust-g fucking segfaults if you pass base64 without padding ;)
	var/padding_needed = length(payload_base64) % 4
	if(padding_needed != 0)
		for(var/i = 1 to (4 - padding_needed))
			payload_base64 += "="
	return json_decode(rustg_decode_base64(payload_base64))
