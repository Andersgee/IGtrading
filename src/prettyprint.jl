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
        created = p["position"]["createdDate"]
        level = p["position"]["level"] #created at this level

        s = string(direction," ",instrumentName," (created: ",created,")")
        bid = p["market"]["bid"] #current
        offer = p["market"]["offer"]
        scale = p["market"]["scalingFactor"]

        if p["position"]["direction"] == "BUY"
            netpips = round((bid-level)*scale,digits=2)
            print(s, " closing at current bid yields ",netpips)
        else
            netpips = (level-offer)*scale
            print(s, " closing at current offer yields ",netpips)
        end
    end
    return nothing
end