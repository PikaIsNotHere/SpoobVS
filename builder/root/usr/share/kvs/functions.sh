#!/bin/bash

style_text() {
  printf "\033[31m\033[1m\033[5m$1\033[0m\n"
}

panic(){
  case "$1" in
    "invalid-Spoobver")
      style_text "SPOOBVS PANIC"
      printf "\033[31mERR\033[0m"
      printf ": Invalid Spoob Version. Please make a GitHub issue at \033[3;34m$GITHUB_URL\033[0m with a picture of this information.\n"
      echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      echo "tpm_Spoobver: $(crossystem tpm_Spoobver)"
      echo "fwid: $(dmidecode -s bios-version) (compiled: $(dmidecode -s bios-release-date))"
      echo "date: $(date +"%m-%d-%Y %I:%M:%S %p")"
      echo "model: $(cat /sys/class/dmi/id/product_name) $(cat /sys/class/dmi/id/product_version)"
      echo "Please shutdown your device now using REFRESH+PWR"
      sleep infinity
      ;;
    "mount-error")
      style_text "KVS PANIC"
      printf "\033[31mERR\033[0m"
      printf ": Unable to mount stateful. Please make a GitHub issue at \033[3;34m$GITHUB_URL\033[0m with a picture of this information.\n"
      echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      echo "tpm_Spoobver: $(crossystem tpm_Spoobver)"
      echo "fwid: $(dmidecode -s bios-version) (compiled: $(dmidecode -s bios-release-date))"
      echo "state mounted: $([ -d /mnt/state/ ] && grep -qs '/mnt/state ' /proc/mounts && echo true || echo false)"
      echo "date: $(date +"%m-%d-%Y %I:%M:%S %p")"
      echo "model: $(cat /sys/class/dmi/id/product_name) $(cat /sys/class/dmi/id/product_version)"
      echo "Please shutdown your device now using REFRESH+PWR"
      sleep infinity
      ;;
    "non-reco")
      style_text "KVS PANIC"
      printf "\033[31mERR\033[0m"
      printf ": Wrong Boot Method. To fix: boot the shim using the recovery method. (ESC+REFRESH+PWR) and \033[31mNOT\033[0m USB Boot.\n"
      echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      echo "tpm_Spoobver: $(crossystem tpm_Spoobver)"
      echo "fwid: $(dmidecode -s bios-version) (compiled: $(dmidecode -s bios-release-date))"
      echo "fw mode: $(crossystem mainfw_type)"
      echo "date: $(date +"%m-%d-%Y %I:%M:%S %p")"
      echo "model: $(cat /sys/class/dmi/id/product_name) $(cat /sys/class/dmi/id/product_version)"
      echo "Please shutdown your device now using REFRESH+PWR"
      sleep infinity
      ;;
    "tpmd-not-killed")
      style_text "KVS PANIC"
      printf "\033[31mERR\033[0m"
      printf ": $tpmdaemon unable to be killed. Please make a GitHub issue at \033[3;34m$GITHUB_URL\033[0m with a picture of this information.\n"
      echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      echo "tpm_Spoobver: $(crossystem tpm_Spoobver)"
      echo "fwid: $(dmidecode -s bios-version) (compiled: $(dmidecode -s bios-release-date))"
      echo "tpmd ($tpmdaemon) running: $(status $tpmdaemon | grep stopped && echo true || echo false)"
      echo "date: $(date +"%m-%d-%Y %I:%M:%S %p")"
      echo "model: $(cat /sys/class/dmi/id/product_name) $(cat /sys/class/dmi/id/product_version)"
      echo "Please shutdown your device now using REFRESH+PWR"
      sleep infinity
      ;;
    "*")
      echo "Panic ID unable to be found: $1"
      echo "Exiting script to prevent crash, please make an issue at \033[3;34m$GITHUB_URL\033[0m."
  esac
}

stopwatch() {
    display_timer() {
        printf "[%02d:%02d:%02d]\n" $hh $mm $ss
    }
    hh=0 #hours
    mm=0 #minutes
    ss=0 #seconds
    
    while true; do
        clear
        echo "Initiated reboot, if this doesn't reboot please manually reboot with REFRESH+PWR"
        echo "Time since reboot initiated:"
        display_timer
        ss=$((ss + 1))
        # if seconds reach 60, increment the minutes
        if [ $ss -eq 60 ]; then
            ss=0
            mm=$((mm + 1))
        fi
        # if minutes reach 60, increment the hours
        if [ $mm -eq 60 ]; then
            mm=0
            hh=$((hh + 1))
        fi
        sleep 1
    done
}

selection(){
  case $1 in
    "1")
      echo "Please Enter Target Spoobver (0-3)"
      read -rep "> " Spoobver
      case $Spoobver in
        "0")
          echo "Setting Spoobver 0"
          write_Spoobver $(cat /mnt/state/kvs/Spoobver0)
          sleep 2
          echo "Finished writing Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "1")
          echo "Setting Spoobver 1"
          write_Spoobver $(cat /mnt/state/kvs/Spoobver1)
          echo "Finished writing Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "2")
          echo "Setting Spoobver 2"
          write_Spoobver $(cat /mnt/state/kvs/Spoobver2)
          echo "Finished writing Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "3")
          echo "Setting Spoobver 3"
          write_Spoobver $(cat /mnt/state/kvs/Spoobver3)
          echo "Finished writing Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        *)
          echo "Invalid Spoobver. Please check your input."
          main
          ;;
      esac ;;
    "2")
      case $Spoobver in
        "0")
          echo "Current Spoobver: 0"
          echo "Outputting to stateful/Spoobver-out"
          cp /mnt/state/kvs/raw/Spoobver0.raw /mnt/state/Spoobver-out
          echo "Finished saving Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "1")
          echo "Current Spoobver: 1"
          echo "Outputting to stateful/Spoobver-out"
          cp /mnt/state/kvs/raw/Spoobver1.raw /mnt/state/Spoobver-out
          echo "Finished saving Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "2")
          echo "Current Spoobver: 2"
          echo "Outputting to stateful/Spoobver-out"
          cp /mnt/state/kvs/raw/Spoobver2.raw /mnt/state/Spoobver-out
          echo "Finished saving Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        "3")
          echo "Current Spoobver: 3"
          echo "Outputting to stateful/Spoobver-out"
          cp /mnt/state/kvs/raw/Spoobver3.raw /mnt/state/Spoobver-out
          echo "Finished saving Spoobver $Spoobver!"
          echo "Press ENTER to return to main menu.."
          read -r
          ;;
        *)
          panic "invalid-Spoobver"
          ;;
      esac ;;
    "3")
      bash
      ;;
    "4")
      credits
      ;;
    "5")
      endkvs
      ;;
    "spoob")
      echo -e "\e[93m                                                                                                 
                                                                                                         
                                          +==++++++******##*=+#%%%                                       
                                   *-:--:::---:::::::::::::---===-::#@                                   
                                @=-==---:::.....................:----:::*@                               
                            %*--+===:::::...........................:-=+*=:+#                            
                         +++++===-==-.........:......::..................:--:::-                         
                      **@@@@%%#+-:::.............::::::::.....................::::-                      
                    *=+*%@@@@@@+............::::..::::::::-+**==-................:::-                    
                  %----+@@@%@@@-...:......................*@@@@@+:.:...............::-%                  
                 =-*=--*@@@@@@@:.........................-@@@#@@*...................:::+#                
               =-=+*+=-=*@@@@@*:.........................=@@@*@@*.  ..................:::=               
              -:===-:..:-----:...........................-%@@@@@:...:..................:::=              
             :.=-:::......................................:-==+-::.......................:::@            
           =:=:-:..........................................................................:.:           
          +:--::............................................................................:::          
          --=:...:::::.......................................................................::=         
        %::=-:..............................................:................................:::*        
        :-=-:..................................................................................::        
      -:---:.......::::........................................................................:.@       
     +.:::::::....:::::........................................................................::.*      
     =.:::..::....::::..........................................................................::-      
     *.:::..:-=:..::...:===-....................................................................:::%     
      -:::..:-:.......-+**=.............................---.......................................:=     
     @-:-=:......:::.-+##+...............=-.............=*##-....................................::=     
     @=:-::.....:::::+##*-..............:++=.............=##*:...................................-=+     
     #=--.:.....:::::*#*+:..............-**+.............:*##+.................................:-==*     
     +:::.:.....:::::*##+...............+##*:.............+#**................................:::=+#     
     #-.::::....:::::+##*:.............=####*:...........-*#*+...............................::--++%     
     #-:--::.::-:::::-*##+............=*#%###*-.........-*##*+..............................::---+*%     
     @+==:::.:::::::::=##%#*=.......=*##*=-+#%##+=--::+#%%%%*-..............................:--++*+#     
     %=+==-::..::::::::-*#%%%##########*=:.:=*#**#######%%%#=:......................:...::::-=+*##+*     
     @+==::...::::::::..:=*#%%######*+=:......-=*##%%%%%%#+=-:...........::::::::::::..:----=***%#+#     
      =::.....::::::::..:::-=====+=--::.......::-===+======---::::::--------=------------=+++**#%*=      
       -::::..::::::::::--===+++++==---::---::--=====+=======--==--==++=+++++=++*+==+=-=++++***#%**      
        +:::::::::::-====++++++**++++++====--=++****+++++++++++++++***********++*************##%**%      
         *+-::.:::---=+++++*******+********++*+**********************#*******************#***#%#*%       
          %++-:-=====+++++**+******#***********#******************###*##********************#%#+@        
           =+#******+=+++++****##***#####*****+++****************##***#####****************#%#*%         
           @**####***++++*********#######*********************##****###**********###*****#%#*+#          
            @+*####******************************************###********##**************##%**@           
             @=###%#***************##**********************###*********#*+**###*******####+-+            
              +-*%+=+***######*########**********************************###**********###*+              
              @:.:+*##*################****#**************###***********************###*+%               
                %++#%#############*#####**####**###********###*************##*******#*=*@                
                  #++#@%#########***##******###%###############**********###++*##%%%+#%                  
                    %==*###**#################*+*****###**##**###*******##########**@                    
                      @%-+###*#######*****#####******#############****##%##%%%##*#                       
                        #*++#####**#########################**##**######%%%%##+#                         
                            @#*++#**###%%%####################**######%%##**@                            
                                *+=+##%%#*############*****#####%%@%#**#%@                               
                                   #*#%#*#*#%%#######%%%%%%@%####%#%%%                                   
                                         %=*********++**+=*%%##%                                         
 \e[0m"                                          
;;
    "6")
      clear
      style_text "silly debug menu!!"
      echo "panic menu"
      echo "1) invalid-Spoobver"
      echo "2) mount-error"
      echo "3) non-reco"
      echo "4) tpmd-not-killed"
      echo "5) return to menu"
      read -rep "> " panicsel
      
      case $panicsel in
        "1")
          panic "invalid-Spoobver"
          ;;
        "2")
          panic "mount-error"
          ;;
        "3")
          panic "non-reco"
          ;;
        "4")
          panic "tpmc-not-killed"
          ;;
        "5")
          echo ""
          ;;
        "*")
          echo "invalid option, wat the flip!!!"
          ;;
      esac ;;
  esac
}
