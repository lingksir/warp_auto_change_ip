#bin/bash!

#This is a script for warp
#You can use it to change your IP of warp which was blocked by Netflix
#Thanks to lmc999

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
read -r -p "Is warp installed? [y/n] " input
read -r -p "Input the region you want(e.g. HK,SG):" area
while [[ "$input" == "y" ]]
do
    result=$(curl --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
    if [[ "$result" == "404" ]];then
        echo -e "Originals Only, Changing IP..."
        systemctl restart wg-quick@wgcf
        sleep 3
	
    elif  [[ "$result" == "403" ]];then
        echo -e "No, Changing IP..."
        systemctl restart wg-quick@wgcf
        sleep 3
	
    elif  [[ "$result" == "200" ]];then
		region=`tr [:lower:] [:upper:] <<< $(curl --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` ;
		if [[ ! "$region" ]];then
			region="US";
		fi
        if [[ "$region" != "$area" ]];then
            echo -e "Region: ${region} Not match, Changing IP..."
            systemctl restart wg-quick@wgcf
            sleep 3
        else
            echo -e "Region: ${region} Done, monitoring..."
            sleep 6
        fi

    elif  [[ "$result" == "000" ]];then
	    echo -e "Failed, break"
        break
    fi
done