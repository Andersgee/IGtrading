function checkstatus(r)
	if r.status != 200
		error("request did not return status code 200")
	end
	return nothing
end

function login!(sess, acc)
    url = string(sess.baseurl,"/session")
    head = Dict("Content-Type"=>"application/json; charset=UTF-8", "Accept"=>"application/json; charset=UTF-8", "VERSION"=>"2", "X-IG-API-KEY"=>sess.apikey)
    body=Dict("identifier"=>acc.username, "password"=>acc.password)
    
    r = HTTP.request("POST", url, head, json(body))
    checkstatus(r)
    sess.xst = r["X-SECURITY-TOKEN"]
    sess.cst = r["CST"]
    accountinfo=JSON.parse(String(r.body))
    return accountinfo
end

function dl_bidoffer(sess, instrument)
    url = string(sess.baseurl,"/markets/",instrument.epic)
    head = Dict("Content-Type"=>"application/json; charset=UTF-8","Accept"=>"application/json; charset=UTF-8","X-IG-API-KEY"=>sess.apikey,"VERSION"=>"3","X-SECURITY-TOKEN"=>sess.xst,"CST"=>sess.cst)
    
    r = HTTP.request("GET", url, head)
    checkstatus(r)
    instrumentinfo=JSON.parse(String(r.body))
    bid = instrumentinfo["snapshot"]["bid"]
    offer = instrumentinfo["snapshot"]["offer"]
    return bid, offer
end

function dl_orders(sess)
    url = string(sess.baseurl,"/workingorders")
    head = Dict("Content-Type"=>"application/json; charset=UTF-8", "Accept"=>"application/json; charset=UTF-8", "X-IG-API-KEY"=>sess.apikey, "VERSION"=>"2", "X-SECURITY-TOKEN"=>sess.xst, "CST"=>sess.cst)
    
    r = HTTP.request("GET", url, head)
    checkstatus(r)
    workingordersinfo=JSON.parse(String(r.body))
    return workingordersinfo["workingOrders"]
end

function dl_positions(sess)
    url = string(sess.baseurl,"/positions")
    head = Dict("Content-Type"=>"application/json; charset=UTF-8", "Accept"=>"application/json; charset=UTF-8", "X-IG-API-KEY"=>sess.apikey, "VERSION"=>"2", "X-SECURITY-TOKEN"=>sess.xst, "CST"=>sess.cst)
    
    r = HTTP.request("GET", url, head)
    checkstatus(r)
    positionsinfo=JSON.parse(String(r.body))
    return positionsinfo["positions"]
end

function place_order(sess, instrument, direction, level)
    #direction = "BUY" or "SELL"
    url = string(sess.baseurl,"/workingorders/otc")
    head=Dict("Content-Type"=>"application/json; charset=UTF-8","Accept"=>"application/json; charset=UTF-8","X-IG-API-KEY"=>sess.apikey,"VERSION"=>"2","X-SECURITY-TOKEN"=>sess.xst,"CST"=>sess.cst)
    body =Dict("epic"=>instrument.epic,"expiry"=>"-","direction"=>direction,"size"=>"1","level"=>level,"forceOpen"=>"false","type"=>"LIMIT","currencyCode"=>instrument.currencycode,"timeInForce"=>"GOOD_TILL_CANCELLED","guaranteedStop"=>"false")

    r = HTTP.request("POST", url, head, json(body));
    checkstatus(r)
end

function delete_order(sess, order)
    url = string(sess.baseurl,"/workingorders/otc/",order["workingOrderData"]["dealId"])
    head = Dict("Content-Type"=>"application/json; charset=UTF-8","Accept"=>"application/json; charset=UTF-8","X-IG-API-KEY"=>sess.apikey,"VERSION"=>"2","X-SECURITY-TOKEN"=>sess.xst,"CST"=>sess.cst,"_method"=>"DELETE")

    r = HTTP.request("POST", url, head);
    checkstatus(r)
end

function close_position(sess, position)
    closedirection = "BUY"
    if position["position"]["direction"] == "BUY"
        closedirection = "SELL"
    end
    epic = position["market"]["epic"]

    url = string(sess.baseurl,"/positions/otc")
    head = Dict("Content-Type"=>"application/json; charset=UTF-8","Accept"=>"application/json; charset=UTF-8","X-IG-API-KEY"=>sess.apikey,"Version"=>"1","X-SECURITY-TOKEN"=>sess.xst,"CST"=>sess.cst,"_method"=>"DELETE")
    body = Dict("epic"=>epic,"expiry"=>"-","direction"=>closedirection,"size"=>"1","orderType"=>"MARKET")

    r = HTTP.request("POST", url, head, json(body));
    checkstatus(r)
end