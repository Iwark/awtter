role :app, %w{awtter}
role :web, %w{awtter}
role :db,  %w{awtter}

set :stage, :production
set :rails_env, :production

set :deploy_to, '/home/ec2-user/awtter'

set :default_env, {
  rbenv_root: "/home/ec2-user/rbenv",
  path: "/home/ec2-user/rbenv/shims:/home/ec2-user/rbenv/bin:$PATH",
}