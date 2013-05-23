class GenerateReport
  
  def generateYamlFile(hash , path)    
    File.open(path, 'w'){|f| YAML.dump(hash, f)}    
  end
  
  def generateReportYamlFile(hash , path)    
    Dir.mkdir(File.dirname(path)) unless FileTest::exist?(File.dirname(path))    
    generateYamlFile(hash,path)    
  end
  
end