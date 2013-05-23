require 'win32ole'

class ExcelFile
  
  def initialize(path,sheetname)
    @path = path
    @sheetname = sheetname    
  end
  
  def ReadExcelFile
    begin
      excelHash = Hash.new        
      excel = WIN32OLE.new("excel.application")
      workbook = excel.Workbooks.Open(@path)    
      worksheet = workbook.Worksheets(@sheetname) 
      worksheet.Select
      row = worksheet.usedrange.rows.count
      column = worksheet.usedrange.columns.count
      if row>1 and column>0   
        tempHash = Hash.new
        for i in 1..column do
          tempHash[i]=worksheet.usedrange.cells(1,i).text.to_s.strip
        end      
        for i in 2..row do
          hash = Hash.new
          for j in 1..column do
            hash[tempHash[j]]=worksheet.usedrange.cells(i,j).text.to_s.strip         
          end 
          excelHash[i-1]=hash
        end
      else
        #######################
      end
      workbook.close
      excel.Quit    
      return excelHash
    rescue
      if workbook != nil
        workbook.close
      end
      if excel != nil
        excel.Quit
      end
      raise
    end
  end 
  
end
