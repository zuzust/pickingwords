# More info at https://github.com/guard/guard#readme
# See https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers


guard 'bundler', :cli => "--without production" do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end


group :frontend do

  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
  end

  guard 'coffeescript', :input => 'app/assets/javascripts', :noop => true

end


group :backend do

  guard 'spork', :wait => 45, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('spec/spec_helper.rb') { :rspec }
    watch(%r{spec/support/})     { :rspec }
    watch(%r{features/support/}) { :cucumber }
  end

  guard 'rspec', :version => 2, :cli => "--color --format progress --drb", :all_on_start => false, :all_after_pass => false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

    # Rails example
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }

    watch(%r{^spec/fabricators/(.+)_fabricator\.rb$})   { |m| ["spec/models/#{m[1]}_spec.rb", "spec/controllers/#{m[1]}s_controller_spec.rb"] }
  end

  guard 'cucumber', :cli => "--no-profile --color --format progress --strict --drb", :all_on_start => false, :all_after_pass => false do
    watch(%r{^features/.+\.feature$})
    watch(%r{^features/support/.+$})                      { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
    
    watch(%r{^spec/fabricators/(.+)\.rb$})                { 'features' }
  end

end
