DB_BOOL_TRUE = defined?(ActiveRecord::ConnectionAdapters::SQLite3Adapter) && ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::SQLite3Adapter) ? "\'t\'" : "TRUE" 

DB_BOOL_FALSE = defined?(ActiveRecord::ConnectionAdapters::SQLite3Adapter) && ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::SQLite3Adapter) ? "\'f\'" : "FALSE" 


SUBSCRIPTION_TIME_UNITS = ['days', 'weeks', 'months', 'years']

PARISHES = [
  'Hanover',
  'St. Elizabeth',
  'St. James',
  'Trelawny',
  'Westmoreland',
  'Clarendon',
  'Manchester',
  'St. Ann',
  'St. Catherine',
  'St. Mary',
  'Kingston & St. Andrew',
  'Portland',
  'St. Thomas'
  ].sort
