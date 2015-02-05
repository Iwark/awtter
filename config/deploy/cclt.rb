role :app, %w{cclt-awtter-web}
role :web, %w{cclt-awtter-web}
role :db,  %w{cclt-awtter-web}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/awtter'

set :default_env, {
  rbenv_root: "/home/ec2-user/rbenv",
  path: "/home/ec2-user/rbenv/shims:/home/ec2-user/rbenv/bin:$PATH",
}