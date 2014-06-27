# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: "bundle exec rspec", spec_paths: %w[specifications] do
  watch(%r{^specifications/.+_spec\.rb$})
  watch(%r{^library/(.+)\.rb$})     { |m| "specifications/#{m[1]}_spec.rb" }
  watch('specifications/spec_helper.rb')  { "specifications" }
end

