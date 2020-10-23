namespace :db do
  desc "Run RAILS_ENV=#{Rails.env} ridgepole, annotate"
  task :ridgepole do
    schema_file = 'db/Schemafile'
    if Rails.env.development?
      lines = []
      Dir.glob(Rails.root.join('db', '*.schema')) do |file|
        basename = File.basename(file)
        lines << "require '#{basename}'"
      end
      lines.sort!
      File.open(Rails.root.join(schema_file), 'w') do |f|
        f.puts(lines.join("\n"))
      end
    end
    sh "bundle exec ridgepole -c config/database.yml -E #{Rails.env} --apply -f #{schema_file}"
    sh 'bundle exec annotate' if Rails.env.development?
  end

  task :create_heroku do
    # heroku 対応(create時に無理矢理設定ファイルを作成する)
    create_db_file = File.exist?(Rails.root.join('config/database.heroku.yml')) && !File.exist?(Rails.root.join('config/database.yml'))
    sh 'cp config/database.heroku.yml config/database.yml' if create_db_file
    sh "bundle exec rails db:create RAILS_ENV=#{Rails.env}"
    sh 'rm config/database.yml' if create_db_file
  end

  task :heroku_ridgepole do
    schema_file = 'db/Schemafile'
    sh "bundle exec ridgepole -c config/database.heroku.yml -E #{Rails.env} -f #{schema_file} --apply;"
  end
end
