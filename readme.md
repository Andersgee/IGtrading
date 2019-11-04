```julia
using IGtrading
acc = Account("user", "password")
apikey = "alphanumerickey123" #log in to account on website to find this key
sess = Session("https://demo-api.ig.com/gateway/deal", apikey, "xst", "cst") #remove demo for live

instruments = [
Instrument("EURUSD","CS.D.EURUSD.MINI.IP", "USD"),
Instrument("GBPJPY","CS.D.GBPJPY.MINI.IP", "JPY")
]

login!(sess, acc)
print_orders_and_positions(sess)

autoplace_order(sess, instruments[1], "BUY")

positions = dl_positions(sess)
print_orders_and_positions(sess)

close_position(sess, positions[1])
print_orders_and_positions(sess)
'''