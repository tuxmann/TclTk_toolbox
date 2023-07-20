#--------------------------------------------------------------------------------------------------------
#     Revision   Date (MM/DD/YYYY)    Developer	        Revision History
#     --------  -----------------   -----------------   --------------------
#       01      04/07/2020            Randy N            Initial Build
#
#	   PROJECT: TITAN PIDU  
#	   TITLE:   Vitis Test Script
#
#--------------------------------------------------------------------------------------------------------

#---------------------------------------
# Function to Read Address Data in the
# XSCT Console window
#---------------------------------------
proc Read { addr} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mrd -force $addr] end-8 end]"
    # Send data to XSCT console window
    puts "Data Read at ADDRESS:  $addr\n                DATA:  $curval\Time: $currenttime\n"
    # Send data to logfile
    puts $chan "Data Read at ADDRESS:  $addr\n                DATA:  $curval\Time: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Write Address Data in the
# XSCT Console window
#---------------------------------------
proc Write { addr data} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mwr -force $addr $data] end-8 end]"
    # Send data to XSCT console window
    puts "Data Write at ADDRESS: $addr\n                 DATA: $data\nTime: $currenttime\n"
    # Send data to logfile
    puts $chan "Data Write at ADDRESS: $addr\n                 DATA: $data\nTime: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Write Multiple Address 
# Data in the XSCT Console window
#---------------------------------------
proc BlockWrite { addr data size} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mwr -force $addr $data $size] end-8 end]"
    # Send data to XSCT console window
    puts "Block Data Written at ADDRESS: $addr\n                       Length: $size\n                         Data: $data\nTime: $currenttime\n"
    # Send data to logfile
    puts $chan "Block Data Written at ADDRESS: $addr\n                       Length: $size\n                         Data: $data\nTime: $currenttime\n "
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Read a block of Address  
# Data in the XSCT Console window
#---------------------------------------
proc BlockRead { addr size} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "[mrd -force $addr $size]"
    # Send data to XSCT console window
    puts "Data Read at ADDRESS:\n$curval\Time: $currenttime\n"
    # Send data to logfile
    puts $chan "Data Read at ADDRESS:\n$curval\Time: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Write Splash Screen file
#  in the XSCT Console window
#---------------------------------------
proc SplashLoad { filename addr datasize  } {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mwr -force -bin -file $filename $addr $datasize] end-8 end]"
    # Send data to XSCT console window
    puts "SplashScreen Written at ADDRESS:       $addr"
    puts "SplashScreen Length:                   $datasize\nTime: $currenttime\n"
    puts ""
    # Send data to logfile
    puts $chan "SplashScreen Written at ADDRESS:       $addr"
    puts $chan "SplashScreen Length:                   $datasize\nTime: $currenttime\n"
    puts $chan ""
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Create a Delay in the
# XSCT Console window
#---------------------------------------
proc Delay { N} {
        after [expr {int($N)}]
}

#---------------------------------------
# Function to Verify Data in the
# XSCT Console window with a Mask
#---------------------------------------
proc DataVerify { addr mask data} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mrd -force $addr] end-8 end]"
    set maskedval [expr {$curval & $mask}]
    set count 1
    if {$maskedval == $data} {
    # Send data to XSCT console window
    puts "Data Verify PASSED At Address: $addr\n                Expected Data: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        # Send data to logfile
    puts $chan "Data Verify PASSED At Address: $addr\n                Expected Data: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
    # Close logfile
    close $chan
    }
    while { $maskedval != $data } {
        set curval "0x[string range [mrd -force $addr] end-8 end]"
        set maskedval [expr {$curval & $mask}]
        # Set a timeout value for data to be correct
        set count [ expr { $count + 1 } ]
        if { $count == 100 } {
        # Send data to XSCT console window
        puts "Data Verify FAILED at ADDRESS: $addr\n                    Data MASK: $mask \n                Expected DATA: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        # Send data to logfile
        puts $chan "Data Verify FAILED at ADDRESS: $addr\n                    Data MASK: $mask \n                Expected DATA: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        break
        # Close logfile
        close $chan
        }
    }
}

#---------------------------------------
# Function to Write Data in the
# XSCT Console window with a Mask
#---------------------------------------
proc MaskWrite { addr mask value } {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    set curval "0x[string range [mrd -force $addr] end-8 end]"
    set curval [expr {$curval & ~($mask)}]
    set maskedval [expr {$value & $mask}]
    set maskedval [expr {$curval | $maskedval}]
    # Write data to the unit
    set curval "0x[string range [mwr -force $addr $maskedval] end-8 end]"
    # Send data to XSCT console window
    puts "Masked Write at ADDRESS: $addr\n              Data MASK: $mask\n           Data Written: $value\nTime: $currenttime\n"
    # Send data to logfile
    puts $chan "Masked Write at ADDRESS: $addr\n              Data MASK: $mask\n           Data Written: $value\nTime: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Read A2D in the
# XSCT Console window
#---------------------------------------
proc ReadA2D {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set brtcurvalue "0x[string range [mrd -force 0x80140030] end-8 end]"
    set brtpot "0x[string range [mrd -force 0x80140034] end-8 end]"
    set brdtemp "0x[string range [mrd -force 0x80140038] end-8 end]"
    set leddvr1 "0x[string range [mrd -force 0x8014003C] end-8 end]"
    set leddvr2 "0x[string range [mrd -force 0x80140040] end-8 end]"
    set bkllum "0x[string range [mrd -force 0x80140044] end-8 end]"
    set bkltemp "0x[string range [mrd -force 0x80140048] end-8 end]"
    set bls1 "0x[string range [mrd -force 0x8014004C] end-8 end]"
    set bls2 "0x[string range [mrd -force 0x80140050] end-8 end]"
    set inputvlt "0x[string range [mrd -force 0x80140054] end-8 end]"
    set 12v6 "0x[string range [mrd -force 0x80140058] end-8 end]"
    set 5v0 "0x[string range [mrd -force 0x8014005C] end-8 end]"
    set 3v3 "0x[string range [mrd -force 0x80140060] end-8 end]"
    set 2v5 "0x[string range [mrd -force 0x80140064] end-8 end]"
    set 1v8 "0x[string range [mrd -force 0x80140068] end-8 end]"
    set 1v2 "0x[string range [mrd -force 0x8014006C] end-8 end]"
    # Send data to XSCT console window
    puts "Brightness Pot Current:        $brtcurvalue\Brightness Pot Wiper Voltage:  $brtpot\Baseboard Temperature:         $brdtemp\Backlight LED1 Driver Voltage: $leddvr1\Backlight LED2 Driver Voltage: $leddvr2\Backlight Luminance:           $bkllum\Backlight Temperature:         $bkltemp\Bezel Light Sensor 1:          $bls1\Bezel Light Sensor 2:          $bls2\Primary input Voltage:         $inputvlt\(12v6) Voltage:                $12v6\(5v0) Voltage:                 $5v0\(3v3) Voltage:                 $3v3\(2v5) Voltage:                 $2v5\(1v8) Voltage:                 $1v8\(1v2) Voltage:                 $1v2\Time: $currenttime\n"
    # Send data to logfile
    puts $chan "Brightness Pot Current:        $brtcurvalue\Brightness Pot Wiper Voltage:  $brtpot\Baseboard Temperature:         $brdtemp\Backlight LED1 Driver Voltage: $leddvr1\Backlight LED2 Driver Voltage: $leddvr2\Backlight Luminance:           $bkllum\Backlight Temperature:         $bkltemp\Bezel Light Sensor 1:          $bls1\Bezel Light Sensor 2:          $bls2\Primary input Voltage:         $inputvlt\(12v6) Voltage:                $12v6\(5v0) Voltage:                 $5v0\(3v3) Voltage:                 $3v3\(2v5) Voltage:                 $2v5\(1v8) Voltage:                 $1v8\(1v2) Voltage:                 $1v2\Time: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Read FPGA Version in the
# XSCT Console window
#---------------------------------------
proc Version {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mrd -force 0x80020100] end-8 end]"
    # Send data to XSCT console window
    puts "FPGA Version: $curval\Time: $currenttime\n"
    # Send data to logfile
    puts $chan "FPGA Version: $curval\Time: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Read Fan Speed Data in the
# XSCT Console window
#---------------------------------------
proc FanSpeed {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "0x[string range [mrd -force 0x80000010] end-8 end]"
    # Send data to XSCT console window
    puts "Fan RPM Register Value:  $curval\nTime: $currenttime\n"
    # Send data to logfile
    puts $chan "Fan RPM Register Value:  $curval\nTime: $currenttime\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to Read Current time in the
# XSCT Console window
#---------------------------------------
proc Time {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set curval "[clock format [clock seconds] -format "%D %T %p"]"
    # Send data to XSCT console window
    puts "Time:  $curval"
    # Send data to logfile
    puts $chan "Time:  $curval"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to put a header in the 
# LogFile Created
#---------------------------------------
proc StartLogFile {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR TRUNC}]
    # Set Clock format
    set curval "[clock format [clock seconds] -format "%D %T %p"]"
    # Send data to logfile
    puts $chan "*************************************************************\n*\n*    PIDU Vitis Test Log\n*    Time Started: $curval\n*\n*************************************************************\n"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to put a header in the 
# LogFile Created
#---------------------------------------
proc EndLogFile {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set curval "[clock format [clock seconds] -format "%D %T %p"]"
    # Send data to logfile
    puts $chan "*************************************************************\n*\n*    Test Script Completed\n*    Time Completed: $curval\n*\n*************************************************************\n"
    # Close logfile
    close $chan
}
