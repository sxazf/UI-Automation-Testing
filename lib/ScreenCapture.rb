require 'Win32API'

class ScreenCapture

  # this method saves the current window or whole screen as either a bitmap or a jpeg
  # It uses paint to save the file, so will barf if a duplicate filename is selected, or  the path doesnt exist etc
  #    * filename        - string  -  the name of the file to save. If its not fully qualified the current directory is used
  #    * active_window   - boolean - if true, the whole screen is captured, if false,  just the active window is captured
  #    * save_as_bmp     - boolean - if true saves the file as a bitmap, saves it as a jpeg otherwise
  def screen_capture(filename , active_window_only=false, save_as_bmp=false)
    
    keybd_event = Win32API.new("user32", "keybd_event", ['I','I','L','L'], 'V')
    vkKeyScan = Win32API.new("user32", "VkKeyScan", ['I'], 'I')
    winExec = Win32API.new("kernel32", "WinExec", ['P','L'], 'L')
    openClipboard = Win32API.new('user32', 'OpenClipboard', ['L'], 'I')
    setClipboardData = Win32API.new('user32', 'SetClipboardData', ['I', 'I'], 'I')
    closeClipboard = Win32API.new('user32', 'CloseClipboard', [], 'I')
    globalAlloc = Win32API.new('kernel32', 'GlobalAlloc', ['I', 'I'], 'I')
    globalLock = Win32API.new('kernel32', 'GlobalLock', ['I'], 'I')
    globalUnlock = Win32API.new('kernel32', 'GlobalUnlock', ['I'], 'I')
    memcpy = Win32API.new('msvcrt', 'memcpy', ['I', 'P', 'I'], 'I')
    
    filename = filename.gsub("/","\\")
    File.delete filename+".png" if File.exist?(filename+".png")
    
    if active_window_only ==false
        keybd_event.Call(0x2C,0,0,0)   # Print Screen
    else
        keybd_event.Call(0x2C,1,0,0)   # Alt+Print Screen
    end 

    winExec.Call('mspaint.exe', 5)
    sleep(1)
   
    # Ctrl + V  : Paste
    keybd_event.Call(0x11, 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("V".getbyte(0)), 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("V".getbyte(0)), 1, 0X2, 0)
    keybd_event.Call(0x11, 1, 0x2, 0)


    # Alt F + A : Save As
    keybd_event.Call(0x12, 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("F".getbyte(0)), 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("F".getbyte(0)), 1, 0X2, 0)
    keybd_event.Call(0x12, 1, 0X2, 0)
    keybd_event.Call(vkKeyScan.Call("A".getbyte(0)), 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("A".getbyte(0)), 1, 0X2, 0)
    sleep(1)

    # copy filename to clipboard
    hmem = globalAlloc.Call(0x0002, filename.length+1)
    mem = globalLock.Call(hmem)
    memcpy.Call(mem, filename, filename.length+1)
    globalUnlock.Call(hmem)
    openClipboard.Call(0)
    setClipboardData.Call(1, hmem) 
    closeClipboard.Call 
    sleep(1)
    
    # Ctrl + V  : Paste
    keybd_event.Call(0x11, 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("V".getbyte(0)), 1, 0, 0)
    keybd_event.Call(vkKeyScan.Call("V".getbyte(0)), 1, 0x2, 0)
    keybd_event.Call(0x11, 1, 0x2, 0)

    if save_as_bmp == false
      # goto the combo box
      keybd_event.Call(0x09, 1, 0, 0)
      keybd_event.Call(0x09, 1, 0x2, 0)
      sleep(0.5)

      # select the first entry with J
      keybd_event.Call(vkKeyScan.Call("P".getbyte(0)), 1, 0, 0)
      keybd_event.Call(vkKeyScan.Call("P".getbyte(0)), 1, 0x2, 0)
      sleep(0.5)
    end  

    # Enter key
    keybd_event.Call(0x0D, 1, 0, 0)
    keybd_event.Call(0x0D, 1, 0x2, 0)
    sleep(1)
   
    # Alt + F4 : Exit
    keybd_event.Call(0x12, 1, 0, 0)
    keybd_event.Call(0x73, 1, 0, 0)
    keybd_event.Call(0x73, 1, 0X2, 0)
    keybd_event.Call(0x12, 1, 0X2, 0)
    sleep(1) 

  end
end
#ScreenCapture.new.screen_capture("1234")