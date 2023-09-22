require "sinatra"
require "sinatra/reloader"
require "http"
require "net/http"
require "json"

def api_lookup
  url = "https://api.exchangerate.host/symbols"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  symbols_hash = response_obj.fetch("symbols")
  list_currency = symbols_hash.keys

  return list_currency
end

get("/") do

  @list_currency = api_lookup
  erb(:pairs)
end

get("/:converting") do  

  @list_currency = api_lookup
  @from_currency = params[:converting]

  erb(:converting)
end

get("/:converting/:converted") do
  @from_currency = params[:converting]
  @to_currency = params[:converted]

  url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  conversion_data = JSON.parse(response)

  @rate = conversion_data.fetch("info").fetch("rate")

  erb(:converted)
end
