# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "better_s3/version"

Gem::Specification.new do |s|
  s.name        = "better_s3"
  s.version     = BetterS3::VERSION
  s.date        = BetterS3::VERSION_DATE
  s.summary     = "Idiomatic S3"
  s.description = "Interact with S3 buckets in an idiomatic fashion."
  s.authors     = ["Courtland Caldwell"]
  s.email       = "engineering@mattermark.com"
  s.files         = `git ls-files`.split("\n") - %w[Gemfile Gemfile.lock]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage =
      "https://github.com/Referly/better_s3"
  s.add_runtime_dependency "aws-sdk", "~> 2" # Apache https://github.com/aws/aws-sdk-ruby/blob/master/LICENSE.txt
  s.add_development_dependency "rspec", "~> 3.2" # MIT https://github.com/rspec/rspec/blob/master/License.txt
  s.add_development_dependency "rb-readline", "~> 0.5", ">= 0.5.3" # BSD (content is BSD) https://github.com/ConnorAtherton/rb-readline/blob/master/LICENSE
  s.add_development_dependency "byebug", "~> 3.5" # BSD (content is BSD) https://github.com/deivid-rodriguez/byebug/blob/master/LICENSE
  s.add_development_dependency "simplecov", "~> 0.10" # MIT https://github.com/colszowka/simplecov/blob/master/MIT-LICENSE
  s.add_development_dependency "rubocop", "~> 0.31" # Create Commons Attribution-NonCommerical https://github.com/bbatsov/rubocop/blob/master/LICENSE.txt
  s.add_development_dependency "rspec_junit_formatter", "~> 0.2" # MIT https://github.com/sj26/rspec_junit_formatter/blob/master/LICENSE
end
