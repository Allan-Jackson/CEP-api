# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
    
    if config.logger.nil?
        config.logger = ActiveSupport::Logger.new("log/#{Rails.env}_env.log")
    end

    case Rails.env 
    when 'development'
        config.logger.level = Logger::DEBUG
    when 'test'
        config.logger.level = Logger::DEBUG
    when 'production'
        config.logger.level = Logger::INFO
    end

    config.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    config.logger.formatter = proc do | severity, time, progname, msg | 
        "#{time} - #{severity}: #{msg}\n"
    end
end