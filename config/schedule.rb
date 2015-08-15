set :environment, 'development'

every 1.day do
  rake "records:import"
end
