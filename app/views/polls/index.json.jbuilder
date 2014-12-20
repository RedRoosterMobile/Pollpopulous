json.array!(@polls) do |poll|
  json.extract! poll, :id, :title, :url
  json.url poll_url(poll, format: :json)
end
