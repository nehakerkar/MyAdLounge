json.array!(@adgroups) do |adgroup|
  json.extract! adgroup, :id, :campaign_id, :aname, :maxcpc, :headline, :description1, :description2, :displayurl, :finalurl, :status
  json.url adgroup_url(adgroup, format: :json)
end
