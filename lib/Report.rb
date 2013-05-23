class Report
  def getReportHead
    return %{<head>
		<meta content=text/html; charset=GBK http-equiv=content-type>
		<title>AT Test Report</title>
		<style type=text/css>
		.title { font-family: verdana; font-size: 30px;  font-weight: bold; align: left; color: #045AFD;}
		.bold_text { font-family: verdana; font-size: 12px;  font-weight: bold;}
		.normal_text { font-family: verdana; font-size: 12px;  font-weight: normal;}
		.small_text { font-family: verdana; font-size: 10px;  font-weight: normal; text-align: center;}
		.border { border: 1px solid #045AFD;}
		.border_left {border-left: 1px solid #045AFD;border-bottom: 1px solid #045AFD;}
		.border_right { border-top: 1px solid #045AFD; border-right: 1px solid #045AFD;}
		.result_ok { font-family: verdana; font-size: 12px;  font-weight: bold; text-align: center; color: green;}
		.result_nok { font-family: verdana; font-size: 12px; font-weight: bold; text-align: center; color: red;}		
		.bborder_left { border-top: 1px solid #045AFD; border-left: 1px solid #045AFD; border-bottom: 1px solid #045AFD; 
						background-color:#045AFD;font-family: verdana; font-size: 12px;  font-weight: bold; text-align: center; color: white;}
		.bborder_right { border-right: 1px solid #045AFD; background-color:#045AFD; font-family: verdana; 
						 font-size: 12px;  font-weight: bold; text-align: center; color: white;}
		</style>
	</head>}
  end
  def getContent(tableContent,detailContent)
    return %{<body>
		<table width=100% border=0 cellpadding=2 cellspacing=2>
			<tbody>
				<tr>					
					<td align=center height=100px><a name="top"></a><p class=title>AT Test Report</p></td>
				</tr>
			</tbody>
		</table>
		<br>
		<hr width=100% class=border size=1px>
		<br>
		<br>		
		<table width=100% cellpadding=2 cellspacing=0 class="border_right">			
			<tr>
				<td class=bborder_left width=10%><p>NO.</p></td>
				<td class=bborder_left width=20%><p>File</p></td>
     <td class=bborder_left width=20%><p>TestClass</p></td>
				<td class=bborder_left width=20%><p>TestCase</p></td>
     <td class=bborder_left width=20%><p>Description</p></td>
				<td class=bborder_left width=10%><p>Status</p></td>
			</tr>}+tableContent+"\n"+
			%{<tr>
				<td class=bborder_left width=10%><p>&nbsp;</p></td>
				<td class=bborder_left width=20%><p>&nbsp;</p></td>
				<td class=bborder_left width=20%><p>&nbsp;</p></td>
				<td class=bborder_left width=20%><p>&nbsp;</p></td>
     <td class=bborder_left width=20%><p>&nbsp;</p></td>
     <td class=bborder_left width=10%><p>&nbsp;</p></td>
			</tr>
		</table>
		<br>
		<div  align=right><a href="#top">top</a></div>
		<br>
		<hr width=100% class=border size=1px>}+detailContent+"\n"+
     %{<br><br>
		<p class=small_text>&copy2012</p>
		<br>
	</body>}
  end
  
  def getTableContent(hash)
    str = ""   
    reStr = ""
    tempArray = Array.new    
    if hash.length>0
      reStr = hash.keys[0][/\D+/]
      reStr = "" if reStr==nil
      hash.keys.each do |k|
        tempArray<<k[/\d+/].to_i
      end
    end
    tempArray = tempArray.sort
    tempArray.each do|k|
      if hash[reStr+k.to_s][:status] == "Pass"
        link = %{<p class="result_ok"><a class="result_ok" href="##{reStr+k.to_s}">}+hash[reStr+k.to_s][:status]+%{</a></p>}
      else
        link = %{<p class="result_nok"><a class="result_nok" href="##{reStr+k.to_s}">}+hash[reStr+k.to_s][:status]+%{</a></p>}
      end      
      str = str + "\n" + %{<tr>
      <td class=border_left width=10% style="text-align:center"><p>}+reStr+k.to_s+%{</p></td>
      <td class=border_left width=20% style="text-align:center"><p>}+hash[reStr+k.to_s][:project]+%{.rb</p></td>
      <td class=border_left width=20% style="text-align:center"><p>}+((hash[reStr+k.to_s][:testclass]=="")?("&nbsp"):(hash[reStr+k.to_s][:testclass])).to_s+%{</p></td>
      <td class=border_left width=20% style="text-align:center"><p>}+((hash[reStr+k.to_s][:testcase]=="")?("&nbsp"):(hash[reStr+k.to_s][:testcase])).to_s+%{</p></td>
      <td class=border_left width=20% style="text-align:center"><p>}+((hash[reStr+k.to_s][:description]=="")?("&nbsp"):(hash[reStr+k.to_s][:description])).to_s+%{</p></td>  
      <td class=border_left width=10% style="text-align:center">}+link+%{</td>
      </tr>}
    end
    return str
  end
  
  def getAllTableContent()
    i = 0
    allTableContents = Array.new
    while eval("@runHash#{i.to_s} != nil")
      allTableContents<<getTableContent(eval("@runHash#{i.to_s}"))
      i = i + 1
    end
    allTableContent = allTableContents.join("\n")
  end
  
  def getAllDetailContent()
    i = 0
    allDetailContents = Array.new
    while eval("@runHash#{i.to_s} != nil")      
      allDetailContents<<getDetailContent(eval("@runHash#{i.to_s}"))
      i = i + 1
    end
    allDetailContent = allDetailContents.join("\n")
  end
  
  def getDetailContent(hash)
    str = "" 
    reStr = ""
    tempArray = Array.new    
    if hash.length>0
      reStr = hash.keys[0][/\D+/]
      reStr = "" if reStr==nil
      hash.keys.each do |k|
        tempArray<<k[/\d+/].to_i
      end
    end
    tempArray = tempArray.sort    
    tempArray.each do|k|           
      str = str + "\n" + %{<div>
			<table width=100% border=0>
				<tr>
					<td align=left>
          <a name="#{reStr+k.to_s}"></a>
          <b>NO.#{reStr+k.to_s}  File : #{hash[reStr+k.to_s][:project]}.rb | TestClass : #{hash[reStr+k.to_s][:testclass]} | TestCase : #{hash[reStr+k.to_s][:testcase]}</b>          
          }+((hash[reStr+k.to_s][:description]=="")?(""):("<br><b>Description: #{hash[reStr+k.to_s][:description]}</b>"))+%{<br>
          #{hash[reStr+k.to_s][:errMes].gsub("\n","<br>")}
      </td>
				</tr>
				<tr>
					<td align=right><a href="#top">top</a></td>
				</tr>
			</table>
		</div>
		<hr width=100% class=border size=1px>}
    end
    return str
  end  
  
  def putsReportFile(path,yamlPath,hash) 
    tempDeHash = Hash.new
    hash.each{|k,v|
      unless k.class == String
        tempDeHash[k.to_s] = v
        hash.delete(k)        
      end
    }
    hash = hash.update(tempDeHash)
    dealHash(hash)    
    Dir.mkdir(File.dirname(path)) unless FileTest::exist?(File.dirname(path))    
    i = 0      
    tempArrayKeys = hash.keys
    tempArrayKeys.each{|k|
      unless k.class == String
        tempArrayKeys[tempArrayKeys.index(k)]=k.to_s
      end
    }
    tempArrayKeys = tempArrayKeys.sort
    tempArrayKeys.each{|k|
      (i == 0)?(fileFlag = "w"):(fileFlag = "a+")
      File.open(yamlPath, fileFlag){|f| YAML.dump({k=>hash[k]}, f)}      
      i = i + 1
    }
    updateYamlFile(yamlPath)
    str = "<html>" + "\n" + getReportHead + "\n" + getContent(getAllTableContent(),getAllDetailContent()) + "\n" + "</html>"     
    File.open(path,"w") do |file|      
      file.puts(str)
    end    
  end 
  
  def updateYamlFile(path)
    File.open(path,"r") do |lines|  
      buffer = lines.read.gsub(/^(--- )(\n)/,"\n")
         File.open(path,"w"){|l|
         l.write(buffer)   
       } 
    end
  end

  def dealHash(hash)    
    hash.each{|k,v|   
      eval("@runHash#{k.to_s.scan(/re\./).length}=Hash.new unless @runHash#{k.to_s.scan(/re\./).length}.class==Hash")
      eval("@runHash#{k.to_s.scan(/re\./).length}[k]=v")      
    }    
    integrateReportHash    #display the rerun result in report
  end
  
  def integrateReportHash
    if @runHash0 != nil
      i = 1
      while eval("@runHash#{i.to_s} != nil")
        tempHash = eval("@runHash#{i.to_s}")        
        tempHash.each{|key,value|          
          @runHash0[key[/\d+/].to_s]=value
        }
        eval("@runHash#{i.to_s} = nil")
        i = i + 1
      end
    end    
  end
end