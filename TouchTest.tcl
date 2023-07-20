#--------------------------------------------------------------------------------------------------------
#     Revision   Date (MM/DD/YYYY)    Developer	        Revision History
#     --------  -----------------   -----------------   --------------------
#       01      12/17/2020            Randy N            Initial Build
#
#	   PROJECT: TITAN PIDU  
#	   TITLE:   Vitis Test Script
#
#--------------------------------------------------------------------------------------------------------

# source C:/TITAN/PIDU/Xilinx_Vitis_2/Scripts/TouchTest.tcl

#---------------------------------------
# Function to Read Address Data in the
# XSCT Console window
#---------------------------------------
proc Read { addr} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]
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
    set curval "[mrd $addr $size]"
    # Send data to XSCT console window
    puts "Data Read at ADDRESS:\n$curval\Time: $currenttime\n"
    # Send data to logfile
    puts $chan "Data Read at ADDRESS:\n$curval\Time: $currenttime\n"
    # Close logfile
    close $chan
}


#---------------------------------------
# Function to Read a block of Address quietly
# Data in the XSCT Console window
#---------------------------------------
proc BlockReadq { addr size} {
    # Open Logfile
    # set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    # Write data to the unit
    set curval "[mrd -force $addr $size]"
    # Send data to XSCT console window
    puts "Time: $currenttime"
    puts "Data Read at ADDRESS:\n$curval"
    # Send data to logfile
    #puts $chan "Data Read at ADDRESS:\n$curval\Time: $currenttime\n"
    # Close logfile
    # close $chan
}


#---------------------------------------
# Function to Create a Delay in the
# XSCT Console window
#---------------------------------------
proc Delay { N} {
        after [expr {int($N)}]
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

#---------------------------------------
# Function to init Touch Controller
# LogFile Created
#---------------------------------------
proc InitTouchCtrl {} {
    set tchenable "[mrd -force 0x80150000 0x1]"
    
    if {[string match "80150000:   00000000\n" $tchenable]} {
        puts "We're initializing the Touch"
        ### Enable Touch Controller Registers ###
        # Enable Touch Controller
        Write 0x80150000 0x1
        # Add a delay in mS
        Delay 5
        # Reset the Controller
        Write 0x80150004 0x1
        # Release Reset 
        Write 0x80150004 0x0
        
        ### Load Touch Panel Controller Setup Registers ###
        # T100 TCHAUX
        Write 0x80150200 0x09AB
        Write 0x80150208 0x02
        Write 0x80150204 0x01
        # Add a delay in mS
        Delay 100
        
        # T100 XRANGE
        Write 0x80150200 0x09B5
        Write 0x80150208 0x0FFF
        Write 0x80150204 0x02
        # Add a delay in mS
        Delay 100
        
        # T100 YRANGE
        Write 0x80150200 0x09C0
        Write 0x80150208 0x0FFF
        Write 0x80150204 0x02
        # Add a delay in mS
        Delay 20
        
        # T100 AMPLHST
        Write 0x80150200 0x09DB
        Write 0x80150208 0x04
        Write 0x80150204 0x01
        # Add a delay in mS
        Delay 20
        
        # T7 IDLEACQINT & ACTVAQINT
        Write 0x80150200 0x0646
        Write 0x80150208 0xFFFF
        Write 0x80150204 0x02
        # Add a delay in mS
        Delay 20
        
        # T8 CHRGTIME
        Write 0x80150200 0x064B
        Write 0x80150208 0x30
        Write 0x80150204 0x01
        # Add a delay in mS
        Delay 20
    } else {
        puts "Touch is initialized."
    }
}

#---------------------------------------
# Function to decode DWORD #1
# LogFile Created
#---------------------------------------
proc decodeDWORD1 {hexValue} {
    # Convert the hexadecimal value to an integer
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    
    set intValue [scan $hexValue "%x"]

    # Define the bit masks for each field
    set msCounterMask 0xFFFF0000
    set touchNumMask  0x0000FF00
    set tchStatusMask 0x000000FF

    # Extract the fields using bitwise operations
    set msCounter [expr {($intValue & $msCounterMask) >> 16}]
    set touchNum [expr {($intValue & $touchNumMask) >> 8}]
    set tchStatus [expr {($intValue & $tchStatusMask)}]

    # Interpret the tchStatus field
    set detect [expr {($tchStatus & 0x80) >> 7}]
    set touchType [expr {($tchStatus & 0x70) >> 4}]
    set touchEvent [expr {($tchStatus & 0x0F)}]

    # Define the touch types and touch events
    array set touchTypes {
        0 "RESERVED"
        1 "FINGER"
        2 "PASSIVE STYLUS"
        5 "GLOVE"
        6 "LARGE TOUCH"
    }
    array set touchEvents {
        0 "NO EVENT"
        1 "MOVE"
        2 "UNSUP"
        3 "SUP"
        4 "DOWN"
        5 "UP"
        6 "UNSUPSUP"
        7 "UNSUPUP"
        8 "DOWNSUP"
        9 "DOWNUP"
    }
    set touchVar touchTypes($touchType)

    # Print the decoded information
    puts "Millisecond Counter Snapshot: $msCounter"
    puts "Touch Number: $touchNum"
    puts "Touch Status: Detect: $detect"
    puts "                Type: $touchTypes($touchType)"
    puts "               Event: $touchEvents($touchEvent)"
    
    close $chan
}

#---------------------------------------
# Function to decode DWORD #2 for X,Y coord
# LogFile Created
#---------------------------------------
proc decodeDWORD2 {hexValue} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]

    # Convert the hexadecimal value to an integer
    set intValue [scan $hexValue "%x"]

    # Define the bit masks for each field
    set xPosMSByteMask 0xFF000000
    set xPosLSByteMask 0x00FF0000
    set yPosMSByteMask 0x0000FF00
    set yPosLSByteMask 0x000000FF

    # Extract the X and Y positions using bitwise operations
    set xPosMSByte [expr {($intValue & $xPosMSByteMask) >> 24}]
    set xPosLSByte [expr {($intValue & $xPosLSByteMask) >> 16}]
    set yPosMSByte [expr {($intValue & $yPosMSByteMask) >> 8}]
    set yPosLSByte [expr {($intValue & $yPosLSByteMask)}]

    # Combine the X and Y position bytes to get the final X and Y positions
    set xPosition [expr {($xPosMSByte << 8) | $xPosLSByte}]
    set yPosition [expr {($yPosMSByte << 8) | $yPosLSByte}]

    # Print the decoded information
    puts "X Position: $xPosition"
    puts "Y Position: $yPosition"
    
    close $chan
}
#----------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------
#
#   Start Sending Commands to the Unit
#
#-----------------------------------------------------------


# Create logfile header 
StartLogFile

# Read FPGA Version ID Register
Version

# Initialize Touch Controller
InitTouchCtrl

# Output FIFO data
for { set i 0}  {$i < 1000} {incr i} {
    # BlockReadq 0x81500000 0x3
    set tchdata "[mrd -force 0x81500000 0x3]"
    set lines [split $tchdata "\n"]
    set line1 [string trim [lindex [split [string trim [lindex $lines 0]] ":"] 1]]
    set line2 [string trim [lindex [split [string trim [lindex $lines 1]] ":"] 1]]
    # puts "$line1"
    # puts "$line2"
    decodeDWORD1 $line1
    decodeDWORD2 $line2
    
    Delay 10
}


# Create logfile Footer 
EndLogFile














# ##############
# ##############
# # LOGPILE ####
# ############## 
# ##############



##---------------------------------------
## Function to Write Splash Screen file
##  in the XSCT Console window
##---------------------------------------
#proc SplashLoad { filename addr datasize  } {
    ## Open Logfile
    #set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    ## Set Clock format
    #set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    ## Write data to the unit
    #set curval "0x[string range [mwr -force -bin -file $filename $addr $datasize] end-8 end]"
    ## Send data to XSCT console window
    #puts "SplashScreen Written at ADDRESS:       $addr"
    #puts "SplashScreen Length:                   $datasize\nTime: $currenttime\n"
    #puts ""
    ## Send data to logfile
    #puts $chan "SplashScreen Written at ADDRESS:       $addr"
    #puts $chan "SplashScreen Length:                   $datasize\nTime: $currenttime\n"
    #puts $chan ""
    ## Close logfile
    #close $chan
#}

##---------------------------------------
## Function to Create a Delay in the
## XSCT Console window
##---------------------------------------
#proc Delay { N} {
        #after [expr {int($N)}]
#}

##---------------------------------------
## Function to Verify Data in the
## XSCT Console window with a Mask
##---------------------------------------
#proc DataVerify { addr mask data} {
    ## Open Logfile
    #set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    ## Set Clock format
    #set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    ## Write data to the unit
    #set curval "0x[string range [mrd -force $addr] end-8 end]"
    #set maskedval [expr {$curval & $mask}]
    #set count 1
    #if {$maskedval == $data} {
    ## Send data to XSCT console window
    #puts "Data Verify PASSED At Address: $addr\n                Expected Data: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        ## Send data to logfile
    #puts $chan "Data Verify PASSED At Address: $addr\n                Expected Data: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
    ## Close logfile
    #close $chan
    #}
    #while { $maskedval != $data } {
        #set curval "0x[string range [mrd -force $addr] end-8 end]"
        #set maskedval [expr {$curval & $mask}]
        ## Set a timeout value for data to be correct
        #set count [ expr { $count + 1 } ]
        #if { $count == 100 } {
        ## Send data to XSCT console window
        #puts "Data Verify FAILED at ADDRESS: $addr\n                    Data MASK: $mask \n                Expected DATA: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        ## Send data to logfile
        #puts $chan "Data Verify FAILED at ADDRESS: $addr\n                    Data MASK: $mask \n                Expected DATA: $data\n                  Actual DATA: $curval\Time: $currenttime\n"
        #break
        ## Close logfile
        #close $chan
        #}
    #}
#}

##---------------------------------------
## Function to Write Data in the
## XSCT Console window with a Mask
##---------------------------------------
#proc MaskWrite { addr mask value } {
    ## Open Logfile
    #set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    ## Set Clock format
    #set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    #set curval "0x[string range [mrd -force $addr] end-8 end]"
    #set curval [expr {$curval & ~($mask)}]
    #set maskedval [expr {$value & $mask}]
    #set maskedval [expr {$curval | $maskedval}]
    ## Write data to the unit
    #set curval "0x[string range [mwr -force $addr $maskedval] end-8 end]"
    ## Send data to XSCT console window
    #puts "Masked Write at ADDRESS: $addr\n              Data MASK: $mask\n           Data Written: $value\nTime: $currenttime\n"
    ## Send data to logfile
    #puts $chan "Masked Write at ADDRESS: $addr\n              Data MASK: $mask\n           Data Written: $value\nTime: $currenttime\n"
    ## Close logfile
    #close $chan
#}

##---------------------------------------
## Function to Read A2D in the
## XSCT Console window
##---------------------------------------
#proc ReadA2D {} {
    ## Open Logfile
    #set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    ## Set Clock format
    #set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    ## Write data to the unit
    #set brtcurvalue "0x[string range [mrd -force 0x80140030] end-8 end]"
    #set brtpot "0x[string range [mrd -force 0x80140034] end-8 end]"
    #set brdtemp "0x[string range [mrd -force 0x80140038] end-8 end]"
    #set leddvr1 "0x[string range [mrd -force 0x8014003C] end-8 end]"
    #set leddvr2 "0x[string range [mrd -force 0x80140040] end-8 end]"
    #set bkllum "0x[string range [mrd -force 0x80140044] end-8 end]"
    #set bkltemp "0x[string range [mrd -force 0x80140048] end-8 end]"
    #set bls1 "0x[string range [mrd -force 0x8014004C] end-8 end]"
    #set bls2 "0x[string range [mrd -force 0x80140050] end-8 end]"
    #set inputvlt "0x[string range [mrd -force 0x80140054] end-8 end]"
    #set 12v6 "0x[string range [mrd -force 0x80140058] end-8 end]"
    #set 5v0 "0x[string range [mrd -force 0x8014005C] end-8 end]"
    #set 3v3 "0x[string range [mrd -force 0x80140060] end-8 end]"
    #set 2v5 "0x[string range [mrd -force 0x80140064] end-8 end]"
    #set 1v8 "0x[string range [mrd -force 0x80140068] end-8 end]"
    #set 1v2 "0x[string range [mrd -force 0x8014006C] end-8 end]"
    ## Send data to XSCT console window
    #puts "Brightness Pot Current:        $brtcurvalue\Brightness Pot Wiper Voltage:  $brtpot\Baseboard Temperature:         $brdtemp\Backlight LED1 Driver Voltage: $leddvr1\Backlight LED2 Driver Voltage: $leddvr2\Backlight Luminance:           $bkllum\Backlight Temperature:         $bkltemp\Bezel Light Sensor 1:          $bls1\Bezel Light Sensor 2:          $bls2\Primary input Voltage:         $inputvlt\(12v6) Voltage:                $12v6\(5v0) Voltage:                 $5v0\(3v3) Voltage:                 $3v3\(2v5) Voltage:                 $2v5\(1v8) Voltage:                 $1v8\(1v2) Voltage:                 $1v2\Time: $currenttime\n"
    ## Send data to logfile
    #puts $chan "Brightness Pot Current:        $brtcurvalue\Brightness Pot Wiper Voltage:  $brtpot\Baseboard Temperature:         $brdtemp\Backlight LED1 Driver Voltage: $leddvr1\Backlight LED2 Driver Voltage: $leddvr2\Backlight Luminance:           $bkllum\Backlight Temperature:         $bkltemp\Bezel Light Sensor 1:          $bls1\Bezel Light Sensor 2:          $bls2\Primary input Voltage:         $inputvlt\(12v6) Voltage:                $12v6\(5v0) Voltage:                 $5v0\(3v3) Voltage:                 $3v3\(2v5) Voltage:                 $2v5\(1v8) Voltage:                 $1v8\(1v2) Voltage:                 $1v2\Time: $currenttime\n"
    ## Close logfile
    #close $chan
#}

##---------------------------------------
## Function to Read Fan Speed Data in the
## XSCT Console window
##---------------------------------------
#proc FanSpeed {} {
    ## Open Logfile
    #set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/log.txt {CREAT RDWR APPEND}]
    ## Set Clock format
    #set currenttime "[clock format [clock seconds] -format "%D %T %p"]"
    ## Write data to the unit
    #set curval "0x[string range [mrd -force 0x80000010] end-8 end]"
    ## Send data to XSCT console window
    #puts "Fan RPM Register Value:  $curval\nTime: $currenttime\n"
    ## Send data to logfile
    #puts $chan "Fan RPM Register Value:  $curval\nTime: $currenttime\n"
    ## Close logfile
    #close $chan
#}

