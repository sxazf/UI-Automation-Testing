require 'pathname'
require "UIObject.rb"
require "Log.rb"
require "HandleExcelFile.rb"
require "ErrorCollection.rb"
require "ObjectData.rb"
require "TestData.rb"
require "Assertion.rb"
require "Report.rb"
require "WebApplication.rb"
require "ScreenCapture.rb"
require "HandleTestData.rb"

class InitialClass
  
  def initialize
    @basicInfo = getNeedKey("basicinfo")
    getFilePath
    @log = Log.new(@logFile)    
    @error = ErrorCollection.new(@log,@reportFilePath,@reportHtmlFilePath)
    @error.instance_variable_set(:@report_path,@reportPath)
  end  
  
  def getLogObject
    @log
  end
  
  def getError
    @error
  end
  
  def getDirPath(folderName)
    root = Pathname.new(File.join(Dir.pwd,"/../../")).realpath    
    case folderName          
    when "lib"
      File.join(root , "/lib/")      
    when "log"
      File.join(root , "/log/")      
    when "report"
      File.join(root , "/report/")      
    when "testcase"
      File.join(root , "/testcase/")  
    when "config"
      File.join(root , "/config/")      
    else
      root
    end           
  end
    
  def getFilePath    
    @logFile = File.join(getDirPath("log"),"result.Log")
    @objectFile = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.yaml")
    @dataPath = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","TestData.yaml")
    @globaldataPath = File.join(getDirPath("testcase"),"GlobalData.yaml")
    @expecteddataPath = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","ExpectedData.yaml")
    @transferdataPath = File.join(getDirPath("config"),"transfer.yaml")
    @configdataPath = File.join(getDirPath("config"),"conf.yaml")
    @loadConfigDataPath = File.join(getDirPath("testcase"),"#{@basicInfo[:project]}/","conf.yaml")
    @reportFilePath = File.join(getDirPath("report"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.yaml")
    @reportHtmlFilePath = File.join(getDirPath("report"),"#{@basicInfo[:project]}/","#{@basicInfo[:project]}.html")
    @reportPath = File.join(getDirPath("report"),"#{@basicInfo[:project]}/")
  end 
  
  def getNeedKey(key)
    case key
    when "data"
      return ["private","smoking","description"]
    when "config"
      return {"Driver"=>["","ie","firefox","chrome"],"RunTimeModule"=>["private","smoking"],"TimeOutSetting"=>Fixnum,"ReRun"=>String,"ReRunTimes"=>Fixnum,"ScreenCapture"=>String}    
    when "basicinfo"
      project_name = File.basename($0)
      return {:file=>$0,:project=>project_name[/.*(?=\.rb)/],:testclass=>"",:testcase=>""}       
    when "status"
      return ["Pass","N/A","Fail"]
    end       
  end
  
  def getBasicInfo
    @basicInfo    
  end  
  
  def setBasicInfo(h)
    h.each{|k,v|
      @basicInfo[k] = v
    }        
  end
  
  def getErrorInfo
    (@description==nil)?(description_value = ""):(description_value = @description)
    @errorValue = {:project=>@basicInfo[:project],
                   :testclass=>@basicInfo[:testclass],
                   :testcase=>@basicInfo[:testcase],
                   :description=>@description,
                   :status=>getNeedKey("status")[2],
                   :errMes=>"",
                   :info=>"",
                   :flag=>true
                  }    
  end
  
  def setErrorInfo(h)
    h.each{|k,v|
      @errorValue[k] = v
    } 
  end
  
  def errorCollection(h)
    getErrorInfo
    setErrorInfo(h)    
    @error.errorCollection(@errorValue)    
  end
  
  def comments(mess)
    errorCollection({:errMes=>mess , :flag=>false,:status=>"Pass"}) 
  end
      
  def getConfigData
    begin
      cData = YAML.load(File.open(@configdataPath))      
      cData = Hash.new  if cData.class != Hash 
      lCData = loadConfigData
      (lCData==nil)?():(lCData.each{|k,v| cData[k]=v})      
      arr = getNeedKey("config")       
      arr.keys.each{|k|
        if cData.key?(k)    
          case arr[k].class.to_s
          when Array.to_s      
            unless arr[k].include?(cData[k])
              errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})              
            end
          when Class.to_s      
            unless arr[k] == cData[k].class            
              errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})
            else              
              if arr[k]==Fixnum and cData[k] < 0
                errorCollection({:errMes=>"Config data #{k}=>#{cData[k]} error from #{@configdataPath}"})
              end
            end
          end           
        else
          errorCollection({:errMes=>"Missed Config data key #{k} from #{@configdataPath}"})
        end        
      }      
      @log.writeLog("Get all config data from #{@configdataPath}")  
      return cData
    rescue
      errorCollection({:errMes=>"Get config data Failed from #{@configdataPath}" , :info=>$@})
    end
  end  
  
  def loadConfigData
    begin
      if File::exists?(@loadConfigDataPath)
        lConfigData = YAML.load(File.open(@loadConfigDataPath))
        lConfigData = Hash.new  if lConfigData.class != Hash
        @log.writeLog("Get load config data from #{@loadConfigDataPath}")
        return lConfigData
      else
        @log.writeLog("No load config file")
      end
    rescue
      errorCollection({:errMes=>"Get load config data Failed from #{@loadConfigDataPath}" , :info=>$@})
    end
  end 
    
  def getCommObject                       
    getObject(@objectFile)    
  end
  
  def getTransferData
    begin
      tData = YAML.load(File.open(@transferdataPath))    
      if tData.class != Hash     
        tData = Hash.new      
      end  
      @log.writeLog("Get all transfer data from #{@transferdataPath}")
      return tData
    rescue
      errorCollection({:errMes=>"Get transfer data Failed from #{@transferdataPath}" , :info=>$@})
    end
  end 
      
  def getObject(path)
    begin       
      ui = UIObject.new(path)
      object = ui.combinElement(ui.integrateElement(ui.getYamlHash))
      @log.writeLog("Get the element object from #{path}")
      return object
    rescue      
      errorCollection({:errMes=>"Get Object failed from #{path}" , :info=>$@})
    end
  end
  
  def getAllData()
    begin             
      all_test_data = HandleTestData.new(@globaldataPath,@dataPath,@expecteddataPath)      
      @test_data =  all_test_data.load_test_data      
      @test_methods = all_test_data.instance_variable_get(:@test_methods)
      dataKey = getNeedKey("data")
      @test_data.each{|k,v|      
        dataKey.each{|ke|
          errorCollection({:errMes=>"Get test data Failed from #{@dataPath}, #{ke} is not exist"}) unless v.key?(ke)
        }        
      }      
      @log.writeLog("Get all test data from #{@dataPath}")
      @expected_data = all_test_data.load_expected_data      
      @log.writeLog("Get all expected data from #{@expecteddataPath}")
    rescue=>e
      errorCollection({:errMes=>e.to_s , :info=>$@})
    end
  end
  
  def TransferYamlFile(hash)
    begin
      File.open(@transferdataPath, "w"){|f| YAML.dump(hash, f)}      
    rescue
      errorCollection({:errMes=>"Generate Transfer Yaml File #{@transferdataPath} failed" ,:flag=>false})
      raise
    end
  end   
  
  def reHash(hash)
    tempHash = Hash.new
    hash.each{|k,v|
      tempHash[tempHash.length+1] = v
    }
    return tempHash
  end
  
end  
