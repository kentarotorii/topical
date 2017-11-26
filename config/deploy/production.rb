server '52.68.3.241', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/kentaro/.ssh/id_rsa'
