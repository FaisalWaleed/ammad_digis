json.array! @diagnostics do |diagnostic|

  json.identifier(diagnostic.identifier)
  json.date(diagnostic.created_at.strftime("%m/%d/%Y"))
  json.message_status(diagnostic.message_status)
  json.message_count(diagnostic.messages.length)
  json.status(diagnostic.status)
  
  json.patient do
    json.name(diagnostic.patient.name)
  end
  
  json.physician do
    json.name(diagnostic.physician.name)
  end
end
