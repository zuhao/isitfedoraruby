every 1.day, at: '3am' do
  rake 'fedorarpms:import_names'
  rake 'rubygems:import_names'
end

every 3.hours do
  rake 'fedorarpms:update_rpms'
  rake 'rubygems:update_gems'
end

every :sunday, at: '4am' do
  rake 'fedorarpms:import_rpms'
  rake 'rubygems:import_gems'
end
