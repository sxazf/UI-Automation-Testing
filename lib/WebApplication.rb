class WebApplication
  def get_ie(flag)
    browser = nil
    (require "watir";browser=Watir::IE.new) if flag == ""
    (require "watir-webdriver";browser=Watir::Browser.new flag.to_sym) if flag != ""
    browser
  end  
end

module WebApplicationModule
  def getWebApplication
    @b = WebApplication.new.get_ie ConfigData("Driver")
  end
end
