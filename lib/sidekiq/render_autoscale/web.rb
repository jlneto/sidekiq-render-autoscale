require 'sidekiq/render_autoscale/process'
require 'sidekiq/render_autoscale/web_extension'

if defined?(::Sidekiq::Web)
  ::Sidekiq::Web.register(::Sidekiq::RenderAutoscale::WebExtension)
  ::Sidekiq::Web.tabs["Dynos"] = "dynos"
end