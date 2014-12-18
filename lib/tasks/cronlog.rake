namespace :cronlog do
  # descの記述は必須
  desc "Log Sync"

  # :environment は モデルにアクセスするのに必須
  task sync: :environment do
    begin 
      exec "rsync -av ~/awtter/shared/log/history.log awtter2:~/awtter/shared/log/history.log"
    rescue => e
      puts "rsync error: #{e}"
    ensure
    end
    puts "----"
    begin 
      exec "rsync -av ~/awtter/shared/log/error.log awtter2:~/awtter/shared/log/error.log"
    rescue => e
      puts "rsync error: #{e}"
    ensure
    end
  end

end