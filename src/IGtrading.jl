module IGtrading

using HTTP
using JSON

struct Account
    username::String
    password::String
end

mutable struct Session
    baseurl::String
    apikey::String
    xst::String
    cst::String
end

struct Instrument
    symbol::String
    epic::String
    currencycode::String
end

export Account,
Session,
Instrument

include("request.jl")
export login!,
dl_bidoffer,
dl_orders,
dl_positions,
place_order,
delete_order,
close_position

include("utils.jl")
export print_orders_and_positions,
autoplace_order,
dl_rate

end
