while true
do
sleep 5
os_name=$(uname)
speak(){

	if [ "$1" -le 10 ]; then
        	alert="battery is at $1 percent. please connect the charger"
	elif [ "$1" -ge 100 ]; then
        	alert="battery is full. please disconnect the charger"
	fi
	if [ "$os_name" = "Darwin" ]; then
		say "$alert"
	elif [ "$os_name" = "Linux" ]; then
		espeak -v en+f2 -a 40 "$alert"
	fi

}

if [ "$os_name" = "Darwin" ]; then
	charging_status=`pmset -g batt| awk 'NR==2'| awk -F' ' '{print $4}'| awk -F ';' '{print $1}'`
	battery_percent=`pmset -g batt| awk 'NR==2'| awk -F' ' '{print $3}'| awk -F '%' '{print $1}'`
elif [ "$os_name" = "Linux" ]; then
	charging_status=`cat /sys/class/power_supply/BAT0/status | tr '[:upper:]' '[:lower:]'`
	battery_percent=`cat /sys/class/power_supply/BAT0/capacity| tr '[:upper:]' '[:lower:]'`
fi
if [ "$charging_status" != "discharging" ]; then
if [ "$battery_percent" -ge 100 ]; then
	speak $battery_percent
fi
fi

if [ "$charging_status" = "discharging" ]; then
if [ "$battery_percent" -le 10 ]; then
	 speak $battery_percent
fi
fi
done
