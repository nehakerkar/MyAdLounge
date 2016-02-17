json.array!(@ads) do |ad|
  json.extract! ad, :id, :adgroup_id, :keyword, :criteriontype, :firstpagebid, :topofpagebid, :status
  json.url ad_url(ad, format: :json)
end
