#encoding:gbk
require 'net/smtp'
require 'rubygems'
require 'MailFactory'
require 'yaml'
require 'Report.rb'

class MailUtil
    def initialize()
        @mailInfo=getMailInfo    #在newMailUtil的时候将从配置文件中读取的信息传入@mailInfo
	    @mail=MailFactory.new    #构造maiFactory的实例
    end

  def mail_Send(str)
   @mail.to=@mailInfo.fetch('to_address')#
   to=Array.new
   @mail.to.at(0).split(",").each do |k|
     to<<k.to_s
   end
     mailtime = Time.now.strftime("%Y%m%d%H%M%S")
	 @mail.from=@mailInfo.fetch('from_address')
	 @mail.subject="WAT_Report_#{mailtime}"
	 @mail.html=str
	 smtp_server=@mailInfo.fetch('server')
	 smtp_port=@mailInfo.fetch('port')
	 smtp_main=@mailInfo.fetch('main')
	 smtp_account=@mailInfo.fetch('account')
	 smtp_pwd=@mailInfo.fetch('pwd')
	 Net::SMTP.start(smtp_server,smtp_port,smtp_main,smtp_account,smtp_pwd,:login)do|smtp|
		 smtp.send_message(@mail.to_s(),@mail.from.at(0),to)
		 end
  end
  
  
  def getMailInfo
    begin
    root = Pathname.new(File.join(File.dirname(__FILE__),"/../config")).realpath
    mailInfoPath=File.join(root,"mail_config.yaml")
	  mData=YAML.load(File.open(mailInfoPath))
	  mData=Hash.new if mData.class !=Hash
	  return mData
       rescue
        errorCollection({:errMes=>"Get mailInfo data Failed from #{mailInfoPath}",:info=>$@})
	  end
  end
    
end
