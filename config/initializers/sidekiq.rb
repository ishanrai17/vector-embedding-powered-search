Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379/0' }

    config.on(:startup) do
      schedule = YAML.load_file(Rails.root.join('config', 'sidekiq.yml'))
      Sidekiq.schedule = schedule[:scheduler][:schedule]
      Sidekiq::Scheduler.enabled = true
      Sidekiq::Scheduler.dynamic = true

      print("Reloading Sidekiq schedule\n")
      puts(Sidekiq.schedule)

      Sidekiq::Scheduler.reload_schedule!
    end
end

Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379/0' }
end