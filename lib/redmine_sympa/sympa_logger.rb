module RedmineSympa
  module SympaLogger
  
    def self.path
      sympa_log = Setting.plugin_redmine_sympa['redmine_sympa_log']
    end
    
    def self.file
      if(@file==nil) then
        @file = File.open(self.path, 'a')
        @file.sync = true
      end
      return @file
    end
    
    def self.getLogger
      if @logger == nil
        @logger = Logger.new(self.file)
      end
      return @logger
    end
    
    def self.clear()
      if(@logger!=nil)
        @logger.close()
        @logger = nil
      end
      if(@file!=nil)
        @file.close()
      end
      File.delete(self.path)
    end

    def self.debug(msg)
      getLogger.debug(msg)
    end

    def self.info(msg)
      getLogger.info(msg)
    end

    def self.warn(msg)
      getLogger.warn(msg)
    end
    
    def self.error(msg)
      getLogger.error(msg)
    end
    
    def self.fatal(msg)
      getLogger.fatal(msg)
    end

  end
end


