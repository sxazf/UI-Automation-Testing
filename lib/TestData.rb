module GetTestData
  
  def TestData(key)    
    if @info[:testData].key?(key)      
      @info[:log].writeLog("Get test data[#{key}:#{@info[:testData].fetch(key).to_s}]")
      return @info[:testData].fetch(key)
    else
      @info[:inti].errorCollection({:errMes=>"TestData: #{key} is not exist" , :flag=>false})      
    end
  end
  
  def ExpectData(key)                  
    if @info[:expectData].key?(key)
      @info[:log].writeLog("Get expect data[#{key}:#{@info[:expectData].fetch(key).to_s}]")
      return @info[:expectData].fetch(key)
    else
      @info[:inti].errorCollection({:errMes=>"TestData: #{key} is not exist" , :flag=>false})
    end
  end
  
  def LoadTestData(path)
    begin
      root = Pathname.new(@info[:inti].getDirPath("root")).realpath
      abPath = File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path)
      exn = File.extname(abPath)  
      if exn==".yaml" or exn==".yml"
        lh = YAML.load(File.open(abPath))
        if lh.class == Hash
          lh.each{|k,v|
            @info[:testData][k]=v
          }  
        end
        @info[:log].writeLog("Load TestData from#{abPath}")
      else
        @info[:inti].errorCollection({:errMes=>"Load TestData #{abPath} failed , the file format error" , :flag=>false})
        raise "extname test data mark"
      end   
    rescue=>e
      if e.to_s!="extname test data mark"
        @info[:inti].errorCollection({:errMes=>"Load TestData #{abPath} failed" , :flag=>false})       
      end
      raise
    end
  end
  
  def LoadExpectData(path)
    begin
      root = Pathname.new(@info[:inti].getDirPath("root")).realpath
      abPath = File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path)
      exn = File.extname(abPath) 
      if exn==".yaml" or exn==".yml"
        lh = YAML.load(File.open(abPath))
        if lh.class == Hash
          lh.each{|k,v|
            @info[:expectData][k]=v
          }    
        end    
        @info[:log].writeLog("Load Expected Data from#{abPath}")
      else
        @info[:inti].errorCollection({:errMes=>"Load ExpectData #{abPath} failed , the file format error" , :flag=>false} )
        raise "extname expect data mark"
      end   
    rescue=>e
      if e.to_s!="extname expect data mark"
        @info[:inti].errorCollection({:errMes=>"Load ExpectData #{abPath} failed" , :flag=>false })       
      end
      raise
    end
  end
  
  def TransferData(key)
    if @info[:tData].key?(key)
      @info[:log].writeLog("Get transfer data[#{key}:#{@info[:tData].fetch(key).to_s}]")
      return @info[:tData].fetch(key)
    else
      @info[:inti].errorCollection({:errMes=>"Transfer data: #{key} is not exist" , :flag=>false})
    end
  end
  
  def ConfigData(key)
    if @info[:cData].key?(key)
      @info[:log].writeLog("Get config data[#{key}:#{@info[:cData].fetch(key).to_s}]")
      return @info[:cData].fetch(key)
    else
      @info[:inti].errorCollection({:errMes=>"Config data: #{key} is not exist" , :flag=>false})
    end
  end
  
end