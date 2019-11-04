```julia
julia> using IGtrading
julia> acc = Account("user", "password");
julia> apikey = "alphanumerickey123"; #log in to account on website to find this key
julia> sess = Session("https://demo-api.ig.com/gateway/deal", apikey, "xst", "cst"); #remove demo for live account

julia> instruments = [Instrument("EURUSD","CS.D.EURUSD.MINI.IP", "USD"),
Instrument("GBPJPY","CS.D.GBPJPY.MINI.IP", "JPY")];

julia> login!(sess, acc);
julia> print_orders_and_positions(sess) #nothing

julia> autoplace_order(sess, instruments[1], "BUY"); #places order at current price

julia> print_orders_and_positions(sess)
positions[1]: BUY EUR/USD Mini (created: 2019/11/04 22:17) closing at current bid yields -0.6 pips

positions = dl_positions(sess);
close_position(sess, positions[1]);
print_orders_and_positions(sess); #nothing
'''
