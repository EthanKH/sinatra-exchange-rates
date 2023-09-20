require "sinatra"
require "sinatra/reloader"
require "http"
require "net/http"
require "json"

get("/") do
  # "
  # <h1>Currency Pairs</h1>
  # "
  url = "https://api.exchangerate.host/latest"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  # Extract data from the response_obj
  @base_currency = response_obj["base"]
  @rates = response_obj["rates"]
  @usd_to_eur = @rates["EUR"]
  @usd_to_gbp = @rates["GBP"]
 
 @currencies = @rates.keys
 
  # Render the ERB template with the data
  erb(:pairs)
end

get("/:converting") do
  
end

get("/:converting/:converted") do
  erb(:converted)
end
