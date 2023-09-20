require "sinatra"
require "sinatra/reloader"
require "http"
require "net/http"
require "json"

get("/") do
  url = "https://api.exchangerate.host/latest"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  @base_currency = response_obj["base"]
  @rates = response_obj["rates"]
  @currencies = @rates.keys
 
  erb(:pairs)
end

get("/:converting") do  
  url = "https://api.exchangerate.host/latest"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  response_obj = JSON.parse(response)

  @base_currency = response_obj["base"]
  @rates = response_obj["rates"]
  @from_currency = params[:converting]
  @currencies = @rates.keys

  erb(:converting)
end

get("/:converting/:converted") do
  @from_currency = params[:converting]
  @to_currency = params[:converted]

  url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  @conversion_data = JSON.parse(response)

  @amount = @conversion_data["query"]["amount"]
  @from_currency = @conversion_data["query"]["from"]
  @to_currency = @conversion_data["query"]["to"]
  @conversion_rate = @conversion_data["info"]["rate"]
  @result = @conversion_data["result"]

  erb(:converted)
end
