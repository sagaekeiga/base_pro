set :branch, 'master'

role :app, %w{anime@160.16.198.30}
role :web, %w{anime@160.16.198.30}
role :db,  %w{anime@160.16.198.30}

server '160.16.198.30', user: 'anime', roles: %w{web app db}

set :ssh_options, {
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 61203
}