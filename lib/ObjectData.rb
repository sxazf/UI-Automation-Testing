module GetObject
  def AutoTest(key)
    if @info[:object].key?(key)
      begin
        Watir::Wait.until(@info[:cData]["TimeOutSetting"].to_i){eval("@b\."+@info[:object][key]["element"]+"\.exist\?")}
        @info[:log].writeLog("Get object[#{key}:#{@info[:object].fetch(key).fetch("element")}]")
        return eval("@b."+@info[:object][key]["element"])
      rescue
        @info[:inti].errorCollection({:errMes=>"Time out after #{@info[:cData]["TimeOutSetting"].to_i}s when get object: #{key}=>#{@info[:object][key]["element"]}" , :flag=>false})
        raise
      end
    else
      @info[:inti].errorCollection({:errMes=>"Object: #{key} is not exist" , :flag=>false}) 
      raise
    end
  end
  
   def LoadObject(path)
    begin
      root = Pathname.new(@info[:inti].getDirPath("root")).realpath
      ui = UIObject.new(File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path))
      lo = ui.combinElement(ui.integrateElement(ui.getYamlHash))
      lo.each{|k,v|
        @info[:object][k]=v
      }  
    rescue      
      @info[:inti].errorCollection({:errMes=>"Load Object #{File.join(root,"testcase/#{@info[:basicInfo][:project]}/",path)} failed" , :flag=>false})
      raise
    end
  end
end