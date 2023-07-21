#--------------------------------------------------------------------------------------------------------
#     Revision   Date (MM/DD/YYYY)    Developer	        Revision History
#     --------  -----------------   -----------------   --------------------
#       01      7/21/2023            Jason Mann           Initial Build
#
#	   PROJECT: TITAN PIDU  
#	   TITLE:   Vitis Test Script
#
# DONE: Inits the touchscreen. Reads the FIFO. Decodes DWORD1 and DWORD2. 
#       Log X,Y coords as screen size 720x1280. Send data to log file.
#			
# TODO: Create two scripts, a -raw sends all to console, a -sum that puts up less
#		Summary script shows touch down, up and move events if > 5-10 touch xy
#       Add msCounter back into the log!
#       Create log as CSV file that shows each line as an a touch event
#       msCounter, touchNum, detect, touchType, , touchEvent, XRaw, YRaw, XScreen, YScreen
#   
#--------------------------------------------------------------------------------------------------------

# source C:/TITAN/PIDU/Xilinx_Vitis_2/Scripts/TouchTest.tcl
#

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
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]
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
proc Time {startValue} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]
    # Set Clock format
    set curval "[expr {[clock milliseconds] - $startValue}]"
    # Send data to XSCT console window
    puts "\nTime:  $curval"
    # Send data to logfile
    puts $chan "\nTime:  $curval"
    # Close logfile
    close $chan
}

#---------------------------------------
# Function to put a header in the 
# LogFile Created
#---------------------------------------
proc StartLogFile {} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR TRUNC}]
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
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]
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
        puts "We're initializing the Touch... Please wait 5 sec."
        ### Enable Touch Controller Registers ###
        # Enable Touch Controller
        mwr -force 0x80150000 0x1
        # Add a delay in mS
        Delay 5
        # Reset the Controller
        mwr -force 0x80150004 0x1
        # Release Reset 
        mwr -force 0x80150004 0x0
        
        ### Load Touch Panel Controller Setup Registers ###
        # T100 TCHAUX
        mwr -force 0x80150200 0x09AB
        mwr -force 0x80150208 0x02
        mwr -force 0x80150204 0x01
        # Add a delay in mS
        Delay 100
        
        # T100 XRANGE
        mwr -force 0x80150200 0x09B5
        mwr -force 0x80150208 0x0FFF
        mwr -force 0x80150204 0x02
        # Add a delay in mS
        Delay 100
        
        # T100 YRANGE
        mwr -force 0x80150200 0x09C0
        mwr -force 0x80150208 0x0FFF
        mwr -force 0x80150204 0x02
        # Add a delay in mS
        Delay 20
        
        # T100 AMPLHST
        mwr -force 0x80150200 0x09DB
        mwr -force 0x80150208 0x04
        mwr -force 0x80150204 0x01
        # Add a delay in mS
        Delay 20
        
        # T7 IDLEACQINT & ACTVAQINT
        mwr -force 0x80150200 0x0646
        mwr -force 0x80150208 0xFFFF
        mwr -force 0x80150204 0x02
        # Add a delay in mS
        Delay 20
        
        # T8 CHRGTIME
        mwr -force 0x80150200 0x064B
        mwr -force 0x80150208 0x30
        mwr -force 0x80150204 0x01
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
proc DecodeDWORD1 {hexValue} {
    # Convert the hexadecimal value to an integer
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]
    
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
    # set touchVar touchTypes($touchType)
    
    puts "TDetect: $detect, TType: $touchTypes($touchType), TEvent: $touchEvents($touchEvent), TNum: $touchNum"
    puts $chan "TDetect: $detect, TType: $touchTypes($touchType), TEvent: $touchEvents($touchEvent), TNum: $touchNum"
    close $chan
}

#---------------------------------------
# Function to decode DWORD #2 for X,Y coord
# LogFile Created
#---------------------------------------
proc DecodeDWORD2 {hexValue} {
    # Open Logfile
    set chan [open c:/titan/pidu/xilinx_vitis_2/scripts/logfiles/TouchTest.txt {CREAT RDWR APPEND}]

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
    set xPosition [expr {$xPosition * 1280/4095}]
    set yPosition [expr {($yPosMSByte << 8) | $yPosLSByte}]
    set yPosition [expr {$yPosition * 720/4095}]

    # Print the decoded information
    #puts "X Position: $xPosition"
    #puts "Y Position: $yPosition"
    puts "X Position: $xPosition, Y Position: $yPosition"
    puts $chan "X Position: $xPosition, Y Position: $yPosition"
    close $chan
}
#----------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------
#
#   Start Sending Commands to the Unit
#
#-----------------------------------------------------------

# Get the starting time in mS
set startTime [clock milliseconds]

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
    
    if {[string match "00000000" $line1]} {
        puts "NO TOUCH DETECTED"
    } else {
        Time $startTime
        DecodeDWORD1 $line1
        DecodeDWORD2 $line2
        # puts ""
    }
    Delay 10
}


# Create logfile Footer 
EndLogFile



### DATA OUT ###
################

#Time: 07/20/2023 11:35:03 AM
#Data Read at ADDRESS:
#81500000:   89000000
#81500004:   2AD50191
#81500008:   079205AD

#TDetect: 0, TType: RESERVED, TEvent: NO EVENT, TNum: 0
#X Position: 0, Y Position: 0
