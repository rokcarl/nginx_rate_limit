-- wrk2 -c10 -t10 -d 60s --timeout 10s -s rok_linkedin_individual_job.lua --rate 1 https://www.linkedin.com
local counter = 1
local threads = {}
local delay_millis = 10
local api_keys = {"nokey", "a", "b"}

function setup(thread)
    print("setup for thread " .. counter)
    thread:set("id", counter)
    table.insert(threads, thread)
    counter = counter + 1
end

function init(args)
    print("init")
    requests  = 0
    responses = 0
    responses_200 = 0
    responses_429 = 0
    responses_unknown = 0
    api_key = api_keys[0]
end

request = function()
    print(counter)
    requests = requests + 1
    --local path = "/?key=" .. api_keys[thread:get("id")]
    local path = "/?key=a"
    --print(path)
    return wrk.format("GET", path)
end

response = function(status, headers, body)
    responses = responses + 1
    if (status == 200) then
        responses_200 = responses_200 + 1
    elseif (status == 429) then
        responses_429 = responses_429 + 1
    else
        responses_unknown = responses_unknown + 1
    end
end

delay = function()
    return delay_millis
end

function done(summary, latency, requests)
    local total_200 = 0
    local total_unknown = 0
    local total_429 = 0
    for index, thread in ipairs(threads) do
        local id        = thread:get("id")
        local requests  = thread:get("requests")
        local responses = thread:get("responses")
        local responses_200 = thread:get("responses_200")
        local responses_unknown = thread:get("responses_unknown")
        local responses_429 = thread:get("responses_429")
        total_200 = total_200 + responses_200
        total_unknown = total_unknown + responses_unknown
        total_429 = total_429 + responses_429
        local msg = "thread %d made %d requests and got %d responses (%d 200, %d 429, %d unknown)"
        print(msg:format(id, requests, responses, responses_200, responses_429, responses_unknown))
    end
    print("------------")
    local total_msg = "Total: %d 200, %d 429, %d unknown"
    print(total_msg:format(total_200, total_429, total_unknown))
end
