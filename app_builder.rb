class AppBuilder < Rails::AppBuilder
  def readme
    create_file "README.md", "TODO"
  end

  def test
    @generator.gem 'thin', group: [:development]
    @generator.gem 'quiet_assets', group: [:development]
    @generator.gem 'rspec-rails', group: [:test, :development]
    @generator.gem 'capybara', group: [:test, :development]
    @generator.gem 'factory_girl_rails', group: [:test, :development]
    @generator.gem 'spork', group: [:test, :development]
    @generator.gem 'guard', group: [:test, :development]
    @generator.gem 'guard-bundler', group: [:test, :development]
    @generator.gem 'guard-rspec', group: [:test, :development]
    @generator.gem 'guard-spork', group: [:test, :development]
    @generator.gem 'terminal-notifier-guard', group: [:development]
    @generator.gem 'rb-fsevent', group: [:test]

    run 'bundle install'
    generate 'rspec:install'
    run 'spork --bootstrap'
    run 'guard init spork'
    run 'guard init rspec'
  end

  def leftovers
    @generator.gem 'haml-rails'
    if yes? "Do you want to generate a root controller?"
      name = ask("What should it be called?").underscore
      generate :controller, "#{name} index"
      route "root to: '#{name}\#index'"
      remove_file "public/index.html"
    end

    git :init
    append_file ".gitignore", "config/database.yml"
    run "cp config/database.yml config/database.example.yml"
    git add: ".", commit: "-m 'initial commit'"
  end
end
