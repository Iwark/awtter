namespace :cronlog do
  # descの記述は必須
  desc "Log Sync"

  # :environment は モデルにアクセスするのに必須
  task sync: :environment do
    begin 
      exec "rsync -av ~/awtter/shared/log/ awtter2:~/awtter/shared/log"
    rescue => e
      puts "rsync error: #{e}"
    ensure
    end
  end

end