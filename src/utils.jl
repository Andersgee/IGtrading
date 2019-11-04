function autoplace_order(sess, instrument, direction)
	#direction = "BUY" or "SELL"
	bid, offer = dl_bidoffer(sess, instrument)
	level = copy(bid)
    if direction == "BUY"
    	level = copy(offer)
    end
    url = string(sess.baseurl,"/workingorders/otc")
    head=Dict("Content-Type"=>"application/json; charset=UTF-8","Accept"=>"application/json; charset=UTF-8","X-IG-API-KEY"=>sess.apikey,"VERSION"=>"2","X-SECURITY-TOKEN"=>sess.xst,"CST"=>sess.cst)
    body =Dict("epic"=>instrument.epic,"expiry"=>"-","direction"=>direction,"size"=>"1","level"=>level,"forceOpen"=>"false","type"=>"LIMIT","currencyCode"=>instrument.currencycode,"timeInForce"=>"GOOD_TILL_CANCELLED","guaranteedStop"=>"false")

    r = HTTP.request("POST", url, head, json(body))
    return nothing
end

function dl_rate(sess, instrument)
    bid, offer = dl_bidoffer(sess, instrument)
    return (bid+offer)/2
end

function print_orders_and_positions(sess)
    printorders(sess)
    printpositions(sess)
end

function printorders(sess)
    orders=dl_orders(sess)
    for i=1:length(orders)
        o=orders[i]
        print("\norders[",i,"]: ")
        pipdistance=round((o["workingOrderData"]["orderLevel"]-o["marketData"]["offer"])*o["marketData"]["scalingFactor"], digits=2)
        
        nameatlevel=string(o["marketData"]["instrumentName"], " at ",o["workingOrderData"]["orderLevel"])
        if o["workingOrderData"]["direction"] == "BUY"
            print("BUY ", nameatlevel, " (current offer at ",o["marketData"]["offer"]," is ",pipdistance," pips away)")
        else
            print("SELL ", nameatlevel, " (current bid at ",o["marketData"]["bid"]," is ",pipdistance," pips away)")
        end
    end
    return nothing
end

function printpositions(sess)
    positions=dl_positions(sess)
    for i=1:length(positions)
        p=positions[i]
        print("\npositions[",i,"]: ")
        
        direction = p["position"]["direction"]
        instrumentName = p["market"]["instrumentName"]
        created = p["position"]["createdDate"][1:end-7] #remove milliseconds and seconds
        level = p["position"]["level"] #created at this level

        s = string(direction," ",instrumentName," (created: ",created,")")
        bid = p["market"]["bid"] #current
        offer = p["market"]["offer"]
        scale = p["market"]["scalingFactor"]

        if p["position"]["direction"] == "BUY"
            netpips = round((bid-level)*scale,digits=2)
            print(s, " closing at current bid yields ",netpips, " pips")
        else
            netpips = (level-offer)*scale
            print(s, " closing at current offer yields ",netpips, " pips")
        end
    end
    return nothing
end