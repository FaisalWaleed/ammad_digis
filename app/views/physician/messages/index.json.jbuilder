json.array! @conversations do |conversation|

  json.identifier(conversation.identifier)
  json.date(conversation.created_at.strftime("%m/%d/%Y %I:%M %p"))
  json.message_status(conversation.message_status)
  json.message_count(conversation.messages_for_physician.length)
  json.unread_message_count(conversation.messages_for_physician.unread.length)
  json.status(conversation.status)
  json.last_message(conversation.messages.last.body)
  json.avatar(image_tag conversation.messages.first.sender.avatar.url(:thumb))
  json.url(physician_message_path(conversation, type: conversation.class.name.parameterize))
  json.asset_type('physician')  
  
  json.patient do
    json.name(conversation.patient.name)
  end
  
  json.sender do
    json.name(conversation.agency.name)
  end
end
