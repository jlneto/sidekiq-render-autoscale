require 'sidekiq/render_autoscale/render_app'
require 'sidekiq/render_autoscale/middleware'
require 'sidekiq/render_autoscale/poll_interval'
require 'sidekiq/render_autoscale/process'
require 'sidekiq/render_autoscale/queue_system'
require 'sidekiq/render_autoscale/scale_strategy'
require 'sidekiq/render_autoscale/version'

module Sidekiq
  module RenderAutoscale

    class << self
      def app
        @app
      end

      def init(options)
        options = options.transform_keys(&:to_sym)
        @app = RenderApp.new(**options)

        ::Sidekiq.logger.warn('Render platform API is not configured for Sidekiq::RenderAutoscale') unless @app.live?

        # configure sidekiq queue server
        ::Sidekiq.configure_server do |config|
          config.on(:startup) do
            dyno_name = ENV['DYNO']
            next unless dyno_name

            process = @app.process_by_name(dyno_name.split('.').first)
            next unless process

            process.ping!
          end

          config.server_middleware do |chain|
            chain.add(Middleware, @app)
          end

          # for jobs that queue other jobs...
          config.client_middleware do |chain|
            chain.add(Middleware, @app)
          end
        end

        # configure sidekiq app client
        ::Sidekiq.configure_client do |config|
          config.client_middleware do |chain|
            chain.add(Middleware, @app)
          end
        end

        # immedaitely wake all processes during client launch
        @app.ping! unless ::Sidekiq.server?

        @app
      end

      def exception_handler
        @exception_handler ||= lambda { |ex|
          p ex
          puts ex.backtrace
        }
      end

      attr_writer :exception_handler
    end

  end
end
