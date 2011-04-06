Fabricator(:client, :class_name => FiveMobilePush::Client) do
  api_token       'token'
  application_uid 'nulayer'
end
