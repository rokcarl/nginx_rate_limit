local responses = 0
local responses_200 = 0
local responses_429 = 0
local responses_other = 0

request = function()
    local path = "/?key=a"
    return wrk.format("GET", path)
end

response = function(status, headers, body)
    responses = responses + 1
    if (status == 200) then
        responses_200 = responses_200 + 1
    elseif (status == 429) then
        responses_429 = responses_429 + 1
    else
        responses_other = responses_other + 1
    end
end

function done(summary, latency, requests)
    print("Responses: " .. responses)
    print("Responses 429: " .. responses_429)
    print("Responses other: " .. responses_other)
end
