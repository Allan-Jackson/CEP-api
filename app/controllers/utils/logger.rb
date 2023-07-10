module MyLogger
    def log_debug(log_string) 
        Rails.application.config.logger.debug(log_string)
    end
    def log_info(log_string) 
        Rails.application.config.logger.info(log_string)
    end
    def log_warn(log_string) 
        Rails.application.config.logger.warn(log_string)
    end
    def log_error(log_string) 
        Rails.application.config.logger.error(log_string)
    end
    def log_fatal(log_string) 
        Rails.application.config.logger.fatal(log_string)
    end
end