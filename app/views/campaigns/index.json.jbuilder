json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :user_id, :cname, :campaigndailybudget, :status
  json.url campaign_url(campaign, format: :json)
end
