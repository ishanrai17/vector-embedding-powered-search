every 1.minute do
    sidekiq_job "MinuteJob"
end