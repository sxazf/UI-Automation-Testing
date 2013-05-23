require 'rubygems'  

version="1.8"
name="WAT"
	
SPEC=Gem::Specification.new do |s|  	
  s.name = name
  s.version = version
  s.summary = "	WAT -- UI AUTOMATION TESTING"
  s.author = "Fei Zhang"
  s.homepage="http://www.cnblogs.com/zhangfei/archive/2013/05/06/3062689.html"
  s.add_dependency('watir', '>= 3.0.0')
  s.add_dependency('watir-classic', '>= 3.0.0')  
  s.platform = Gem::Platform::RUBY
  s.executables = ['wat']
  condidates =Dir.glob("{bin,lib,docs,test}/**/*") 
  s.files=condidates.delete_if do |item|  

    item.include?("CVS")|| item.include?("rdoc")  

  end  
  
  s.require_path = "lib"
  s.bindir = "bin"
  s.email = "zhangfei19841004@163.com"

end  