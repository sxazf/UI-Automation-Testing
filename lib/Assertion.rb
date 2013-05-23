module Assertion
  def assert_string(expect , actual , msg="")
    msg = msg + ":" if msg != ""
    assert_class(expect , actual , String , msg)
    if expect == actual
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert string pass [#{expect}]" , :flag=>false,:status=>"Pass"}) 
    else      
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert string error, expect is [#{expect}], but actual is [#{actual}]" , :flag=>false})      
      raise
    end
  end
  
  def assert_array(expect , actual , msg="")
    msg = msg + ":" if msg != ""
    assert_class(expect , actual , Array, msg)
    unless expect == actual
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert array error, expect is [#{expect.join(",")}], but actual is [#{actual.join(",")}]" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert array pass [#{expect.join(",")}]" , :flag=>false,:status=>"Pass"})      
    end    
  end
  
  def assert_hash(expect , actual , msg="")
    msg = msg + ":" if msg != ""
    assert_class(expect , actual , Hash, msg)
    unless expect == actual
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert hash error, expect is [#{expect.to_a.join(",")}], but actual is [#{actual.to_a.join(",")}]" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert hash pass [#{expect.to_a.join(",")}]" , :flag=>false,:status=>"Pass"})
    end    
  end
  
  def assert_true(actual , msg="")
    msg = msg + ":" if msg != ""
    #assert_class(true , actual , TrueClass, msg)
    unless true == actual
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert true error, actual is [#{actual.to_s}]" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert true pass [#{actual.to_s}]" , :flag=>false,:status=>"Pass"})
    end  
  end
  
  def assert_false(actual , msg="")
    msg = msg + ":" if msg != ""
    #assert_class(false , actual , FalseClass, msg)
    unless false == actual
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert false error, actual is [#{actual}]" , :flag=>false})
      raise
    else
      @info[:inti].errorCollection({:errMes=>"#{msg}Assert false pass [#{actual.to_s}]" , :flag=>false,:status=>"Pass"})
    end  
  end
  
  def assert_class(expect,actual,klass, msg)
    msg = msg + ":" if msg != ""
    temp = [expect,actual]
    temp.each{|k|
      unless k.class == klass
        @info[:inti].errorCollection({:errMes=>"#{msg}#{k} class is #{k.class} , must be #{klass}" , :flag=>false})
        raise
      end
    }
  end
end