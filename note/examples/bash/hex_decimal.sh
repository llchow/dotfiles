#!/bin/bash
if [ -z $1 ]; then
    echo "Specify a number"
    exit 1;
fi

echo "Hex --> Decimal"
echo -e "Hex value:\t$1"
echo -e "Dec value:\t$((16#$1))"

# Check if the input could be interpreted as a decimal
if ! [[ $1 =~ [A-Fa-f] ]]; then
    echo ""
    echo "Decimal --> Hex"
    printf 'Hex value:\t%x\n' $1
    echo -e "Dec value:\t$1"
fi


cron.sh
#!/bin/bash
if [ "$#" -eq 0 ]; then
    echo "Need a command"
    exit 1
fi

sleep_duration=5
if [ "$#" -eq 2 ]; then
    sleep_duration=$2
fi

shopt -s expand_aliases

echo -e '\nRunning command "'$1'" every "'$2'" seconds\n'
while [ 1 ]; do
    eval "$1"
    sleep $sleep_duration
done

get_public_ip.sh
#!/bin/bash
curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'


