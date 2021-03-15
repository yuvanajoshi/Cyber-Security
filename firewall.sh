function MainMenu {
  option=$(whiptail --title "IPTABLES FIREWALL RULES" --menu "Choose from options below:" 20 72 14 \
  "1)" "Display all firewall rules." \
  "2)" "Select existing firewall rules." \
  "3)" "Add firewall rules with Iptables." \
  "4)" "Delete firewall rules." \
  "5)" "Export rules to HTML page." \
  "6)" "Exit."  3>&1 1>&2 2>&3)


  exitstatus=$?

  if [[ $option == "1)" ]]; then
    choice=$(whiptail --title "IPTABLES FIREWALL RULES" --menu "Choose from options below:" 20 72 14 \
    "a)" "Input Rules" \
    "b)" "Output Rules" \
    "c)" "Forward Rules" \
    "d)" "Display All  Rules" \
    "e)" "Return to Main Menuu."  3>&1 1>&2 2>&3)

    if [[ $choice == "a)" ]]; then
      displayInputRules

    elif [[ $choice == "b)" ]]; then
      displayOutputRules

    elif [[ $choice == "c)" ]]; then
      displayForwardRules

    elif [[ $choice == "d)" ]]; then
      displayAllRules

    else
      MainMenu

    fi
     
  elif [[ $option == "2)" ]]; then
    chooseFirewallRules

  elif [[ $option == "3)" ]]; then
    addFirewallRules 

  elif [[ $option == "4)" ]]; then
    deleteFirewallRules

  elif [[ $option == "5)" ]]; then 
    htmlFile > firewall.html
    username=$(whiptail --inputbox "Enter your computer's username:" 10 75  --title "Exporting existing rules to HTML file."  3>&1 1>&2 2>&3)
    sudo su $username firefox firewall.html
    MainMenu

  elif [[ $exitstatus = 1 ]]; then
    exit 0;

  else
    exit 0

  fi
}

#Function for displaying  firewall rules.

function displayInputRules {
    cmd=$(sudo iptables -L INPUT --line-numbers -n)
    whiptail --title "INPUT Firewall Rules" --msgbox "Listed are the INPUT rules:\n $cmd" 25 79
}

function displayOutputRules {
    cmd=$(sudo iptables -L OUTPUT --line-numbers -n)
    whiptail --title "INPUT Firewall Rules" --msgbox "Listed are the INPUT rules:\n $cmd" 25 79
}

function displayForwardRules {
    cmd=$(sudo iptables -L FORWARD --line-numbers -n)
    whiptail --title "INPUT Firewall Rules" --msgbox "Listed are the INPUT rules:\n $cmd" 25 79
}

function displayAllRules {
    cmd=$(sudo iptables -L --line-numbers -n)
    whiptail --title "INPUT Firewall Rules" --msgbox "Listed are the INPUT rules:\n $cmd" 25 79
}

#Function for selecting firewall rules.


function chooseFirewallRules {
  options=$(whiptail --title "IPTABLES FIREWALL OPTIONS" --menu "Choose a firewall option:" 20 72 14 \
        "a)" "Block a website." \
        "b)" "Block ping from an ipaddress." \
        "c)" "Block a MAC address." \
        "d)" "Return to the main menu." 3>&1 1>&2 2>&3)

if [[ $options == "a)" ]]; then
        webAddress=$(whiptail --inputbox "Enter or paste the webAddress of the site:" 10 79 --title "Blocking a website." 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [[ $exitstatus = 1 ]]; then
            whiptail --title "Blocking a website." --msgbox "EMPTY! Please enter a valid address." 25 79
        else
            whiptail --title "blocking a website." --msgbox "IPADDRESS $input is blocked!! " 25 79
            cmd=$(sudo iptables -A OUTPUT -p tcp -d $input -j DROP)
        fi 
        MainMenu

elif [[ $options == "b)" ]]; then
      ip=$(whiptail --inputbox "Enter or paste the ip address for which you want to block ping." 10 79 --title "Block ping from an ipaddress." 3>&1 1>&2 2>&3)
      exitstatus=$? 
      if [[ $exitstatus = 1 ]]; then
          whiptail --title "Block ping from an ipaddress." --msgbox "EMPTY! Please enter a valid address." 20 78
      else
          whiptail --title "Block ping from an ipaddress." --msgbox "The ipaddress $ip has been blocked to ping!" 20 78
          cmd=$(sudo iptables -A INPUT -s $ip -p icmp -j DROP)
      fi
      MainMenu
    
elif [[ $options == "c)" ]]; then
      mac=$(whiptail --inputbox "Enter MAC address e.g.(00-14-22-01-23-45”)" 10 79 --title "Block a MAC address." 3>&1 1>&2 2>&3)
      exitstatus=$?
      if [[ $exitstatus = 1 ]]; then
          whiptail --title "Block a MAC address." --msgbox "EMPTY! Please enter a valid MAC address." 20 78
      else
          whiptail --title "Block a MAC address." --msgbox "the MAC address $mac is blocked!! " 20 78
          cmd=$(sudo iptables -A INPUT -m mac --mac-source $mac -j DROP)
      fi 
      MainMenu

else

  MainMenu

fi
}

#Function for adding firewall rules.

function addFirewallRules {

  cmd = $(whiptail --inputbox "Enter the command to add firewall rule." 10 79 --title " Adding Firewall Rule" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [[ $cmd == "" ]]; then
    whiptail --title "Adding Firewall Rule" --msgbox "Please enter a valid rule." 25 79

  else 
    whiptail --title "Adding Firewall Rule" --msgbox "INPUT rule has been added." 25 79
    $cmd
  fi


  MainMenu

}

#Function for deleting firewall rules.

function deleteFirewallRules {

    OPTION =$(whiptail --title "IPTABLES FIREWALL RULES" --menu "Choose from options below:" 20 72 14 \
        "a)" "Delete Input Rules." \
        "b)" "Delete Output Rules." \
        "c)" "DELETE Forward Rules." \
        "d)" "Return to the main menu." 3>&1 1>&2 2>&3)

    if [[ $OPTION == "a)" ]]; then
        displayInputRules
        cmd=$(whiptail --inputbox "Enter the rule number you want to delete." 10 79 --title "Deleting Firewall INPUT Rule" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [[ $exitstatus = 1 ]]; then
            whiptail --title "Deleting Firewall INPUT Rule" --msgbox "Please enter a rule number you wish to delete. NONE PROVIDED!" 25 79
        else
            whiptail --title "Deleting Firewall INPUT Rule" --msgbox "This INPUT RULE: $cmd has been deleted." 25 79
            sudo iptables -D INPUT $cmd
        fi 

    elif [[ $OPTION == "b)" ]]; then
        displayOutputRules
        cmd=$(whiptail --inputbox "Enter the rule number you want to delete." 10 79 --title "Deleting Firewall OUTPUT Rule" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [[ $exitstatus = 1 ]]; then
            whiptail --title "Deleting Firewall OUTPUT Rule" --msgbox "Please enter a rule number you wish to delete. NONE PROVIDED!" 25 79
        else
            whiptail --title "Deleting Firewall OUTPUT Rule" --msgbox "This OUTPUT RULE: $cmd has been deleted." 25 79
            sudo iptables -D OUTPUT $cmd
        fi
        

    elif [[ $OPTION == "c)" ]]; then
        displayForwardRules
        cmd=$(whiptail --inputbox "Enter the rule number you want to delete." 8 78 --title "Deleting Firewall FORWARD Rule" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Deleting Firewall FORWARD Rule" --msgbox "Please enter a rule number you wish to delete. NONE PROVIDED!" 25 79
        else
            whiptail --title "Deleting Firewall FORWARD Rule" --msgbox "This FORWARD RULE: $cmd has been deleted." 25 79
            sudo iptables -D FORWARD $cmd
        fi
    
    else
        MainMenu
    fi
}

#Function for creating a html file report.

function htmlFile {
    Title=$(hostname)
    a=$(sudo iptables -L INPUT)
    b=$(sudo iptables -L OUTPUT)
    c=$(sudo iptables -L FORWARD)
cat <<- _EOF_
        <html>
            <head>
                <title>Iptables Firewall Rules $Title</title>
            </head>
            <body style="background-color:black;">
                <h1 style="color:white; text-align:center;">Firewall Rules: $Title</h1>
                <br>
                <br>
                <br>
                <h2 style="color:white; text-align:center;"> INPUT RULES: </h2>
                <p style="text-align:center; font-size:28px;"> $a </p>       
                <h2 style="color:white; text-align:center;"> OUTPUT RULES: </h2>
                <p style="text-align:center; font-size:28px;"> $b </p>
                <h2 style="color:white; text-align:center;"> FORWARD RULES: </h2>     
                <p style="text-align:center; font-size:28px;"> $c </p>
            </body>
        </html>
_EOF_
}

MainMenu