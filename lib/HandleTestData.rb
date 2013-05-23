require "yaml"
class HandleTestData
  
  def initialize(global_data_path,test_data_path,expected_data_path)
    @global_data_path = global_data_path
    @test_data_path = test_data_path    
    @expected_data_path = expected_data_path
  end
  
  def load_test_data
    begin
      @test_data = YAML.load(File.open(@test_data_path))  
      @test_data = Hash.new if @test_data==false      
      common_data = Hash.new
      @test_data.each{|d|     
        if d.has_key?("common")
          common_data = d["common"]         
          @test_data.delete d
          break
        end
      }    
      global_data = YAML.load(File.open(@global_data_path))
      global_data = Hash.new if global_data==false
      global_data.keys.each{|key|
        common_data[key]=global_data[key] if !common_data.has_key? key
      }
      temp_test_data = Hash.new     
      count = 1
      @test_methods = Array.new
      @test_data.each{|d|
        d.keys.each{|key|
          common_data.keys.each{|k|
            d[key][k]=common_data[k] if !d[key].has_key? k
          }        
          temp_test_data_h = d[key]
          temp_test_data_h["TestCase Order"]=key
          @test_methods<<key.to_sym
          temp_test_data[count]=temp_test_data_h
          count = count + 1
        }
      }     
      @test_data=temp_test_data
    rescue
      raise "Load test data failed!"
    end
  end  
  
  def load_expected_data
    begin
     @expected_data = YAML.load(File.open(@expected_data_path))
     @expected_data = Hash.new if @expected_data==false
     @expected_data
    rescue
      raise "Load expected data failed!"
    end
  end
  
end

