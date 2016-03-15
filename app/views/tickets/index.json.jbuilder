json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :subject, :user_id, :device_id, :text, :open
  json.url ticket_url(ticket, format: :json)
end
