# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'sidekiq/render_autoscale/version'

Gem::Specification.new do |s|
  s.name        = 'sidekiq-render-autoscale'.freeze
  s.version     = Sidekiq::RenderAutoscale::VERSION

  s.required_ruby_version = '> 2.5'
  s.require_paths         = ['lib']
  s.files                 = Dir['README.md', 'lib/**/*']

  s.authors     = ['Greg MacWilliam', 'Justin Love']
  s.summary     = 'Start, stop, and scale Sidekiq dynos on Render based on workload'
  s.description = s.summary
  s.homepage    = 'https://github.com/jlneto/sidekiq-render-autoscale'
  s.licenses    = ['MIT']

  s.add_dependency 'sidekiq', '>= 5.0'
  s.add_dependency 'render_api'
end
