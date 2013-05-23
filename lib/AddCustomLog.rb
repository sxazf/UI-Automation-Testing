module AddCustomLog
  def l mes
    @info[:inti].errorCollection({:errMes=>mes , :flag=>false,:status=>"Pass"}) 
  end
end