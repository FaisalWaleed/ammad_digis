json.array! @dispense_orders do |order|

  json.identifier(order.prescription.identifier)
  json.date(order.created_at.strftime("%m/%d/%Y"))
  json.message_status(order.message_status)
  json.message_count(order.messages.length)
  json.status(order.status)
  
  json.patient do
    json.name(order.patient.name)
  end
  
  json.physician do
    json.name(order.physician.name)
  end
end
