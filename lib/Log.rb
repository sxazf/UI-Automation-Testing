class Log
  
  def initialize(logPath)
    @logPath = logPath
  end
  
  def writeLog(str)   
    File.open(@logPath,"a+") do |file| 
      puts "["+logTime+"] "+str
      file.puts("["+logTime+"] "+str)      
    end
  end
  
  def logTime
    t = Time.now
    t.strftime("%Y-%m-%d %H:%M:%S")
  end

  def timeStr
    t = Time.now
    t.strftime("%Y%m%d%H%M%S")
  end  
  
end 