require "InitialClass.rb"

class Run  
  
  def testClassObject
    a = Array.new
    ObjectSpace.each_object(Class) do |klass|   
      if klass.superclass == TestKlass     
        a<<klass			
      end
    end 
    return a
  end   
  
  def initialize   
    @project = $*[0] if ($*[0]=~/all/i)!=nil
    @testcasename,@number= $*[0], $*[1] if $*.size>0    
  end
  
  def run
    isRun = 0
    inti = InitialClass.new    
    basicInfo = inti.getBasicInfo    
    inti.getErrorInfo
    cData = inti.getConfigData
    inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture,cData["ScreenCapture"])
    object = inti.getCommObject
    inti.getAllData
    allTestData = inti.instance_variable_get(:@test_data)
    if $*.size==0
      allTestData.each{|k,v|      
        if v[cData["RunTimeModule"]].upcase != "Y"
          allTestData.delete(k)
        end    
      }
    else
      if @project == nil      
        if @number != nil
          allTestData.each{|key,value|
            allTestData.delete(key) if key!=@number.to_i
          }
        else
          allTestData.each{|key,value|
            allTestData.delete(key) if value["TestCase Order"]!=@testcasename
          }
        end
      end
    end    
    allTestClass = testClassObject   
    allTestClassObject = Array.new    
    allTestClass.each{|klass|        
      all_test_methods = klass.new.methods.grep(/^test/)
      test_methods = inti.instance_variable_get(:@test_methods)       
      allTestClassObject<<klass.new if (test_methods & all_test_methods).size>0
    }    
    inti.errorCollection({:errMes=>"No case need to run",:status=>inti.getNeedKey("status")[1]}) if allTestData.length == 0 or allTestClassObject.length==0     
    allTestData = inti.reHash(allTestData)
    allTestData = allTestData.sort
    expectData = inti.instance_variable_get(:@expected_data)   
    tData = inti.getTransferData       
    TestKlass.class_eval("include GetObject \n include GetTestData \n include Assertion \n include WebApplicationModule \n")
    TestKlass.class_eval("def system_testcase_information(hash) \n @info = hash \n end") 
    TestKlass.class_eval("def setUp\n end")   
    TestKlass.class_eval("def tearDown\n end")
    log = inti.getLogObject 
    all_methods_run_count = 1
    allTestData.each{|allData|  
      ke_ = allData[0]
      value = allData[1] 
      allTestClassObject=[eval("#{@rerunclass}.new")] if (ke_ =~ /^(re)/) != nil  
      allTestClassObject.each{|k|        
        ke = ke_
        ke = all_methods_run_count  if (ke_ =~ /^(re)/) == nil       
        k.methods.grep(/^test/) do |method| 
          methodName = method.to_s
          if value["TestCase Order"] == methodName            
            inti.setBasicInfo({:testclass=>k.class.to_s,:testcase=>methodName})            
            basicInfo = inti.getBasicInfo
            isRun = isRun + 1
            begin  
              s = inti.instance_variable_get(:@error).getErrorCollection.length
              testData = value.clone 
              inti.instance_variable_set :@description,testData["description"]  
              log.writeLog("Begining to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")              
              k.system_testcase_information({:object=>object.clone,:log=>log.clone,:basicInfo=>basicInfo.clone,:inti=>inti.clone,:testData=>testData.clone,:expectData=>expectData.clone,:tData=>tData.clone,:cData=>cData.clone})
              inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,true)
              all_methods_run_count = all_methods_run_count + 1 if (ke_ =~ /^(re)/) == nil
              begin
                k.setUp
              rescue
                inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,false)
                inti.errorCollection({:errMes=>"#{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} failed in setUp",:info=>$@,:flag=>false})
                k.tearDown
                raise "test case run error!" 
              end
              begin
                rValue = k.__send__(method) 
                if rValue != nil                
                  tData[methodName] = rValue
                  inti.TransferYamlFile(tData)
                end    
              rescue
                inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,false)
                inti.errorCollection({:errMes=>"#{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} failed in #{method.to_s}",:info=>$@,:flag=>false})
                k.tearDown
                raise "test case run error!" 
              end
              begin
                k.tearDown
              rescue
                inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,false)
                inti.errorCollection({:errMes=>"#{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} failed in tearDown",:info=>$@,:flag=>false})                
                raise "test case run error!" 
              end  
              inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,false)
              log.writeLog("Ending to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")              
              inti.errorCollection({:errMes=>"Run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} pass" , :flag=>false , :status=>inti.getNeedKey("status")[0]}) 
              e = inti.instance_variable_get(:@error).getErrorCollection.length              
              inti.instance_variable_get(:@error).processHash(inti.instance_variable_get(:@error).getTestCaseHash(s,e),ke) unless s==e
            rescue=>e         
              inti.instance_variable_get(:@error).instance_variable_set(:@screen_capture_flag,false)
              log.writeLog("Ending to run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]}")
              inti.errorCollection({:errMes=>"Run : #{basicInfo[:file]} => #{basicInfo[:testclass]} => #{basicInfo[:testcase]} fail",:info=>$@,:flag=>false})  if e.to_s!="test case run error!"
              e = inti.instance_variable_get(:@error).getErrorCollection.length
              inti.instance_variable_get(:@error).processHash(inti.instance_variable_get(:@error).getTestCaseHash(s,e),ke) unless s==e
              if cData["ReRun"].upcase == "Y" and ke.to_s.scan(/re\./).length < cData["ReRunTimes"]
                allTestData<<["re\.#{ke.to_s}",value]      
                @rerunclass = k.class.to_s
              end
            end
          end
        end
        if isRun== 0      
          inti.errorCollection({:errMes=>"TestCase : #{value["TestCase Order"]} is not exist in #{basicInfo[:file]}" ,:testclass=>"",:testcase=>value["TestCase Order"], :flag=>false , :status=>inti.getNeedKey("status")[1]})
        else
          isRun = 0
        end
      }
    }    
    finalHash = inti.instance_variable_get(:@error).getErrorCollection 
    Report.new.putsReportFile(inti.instance_variable_get(:@reportHtmlFilePath),inti.instance_variable_get(:@reportFilePath),finalHash)
  end
end

at_exit do     
  Run.new.run
end

