#!/bin/bash
#title           :tunnelme.sh
#description     :This script creates a SSH tunnels
#author          :Marco Valero (marcoavalero@gmail.com)
#date            :20150411
#version         :0.1    

DEFAULT_USER="$USER"
TUNNEL_PORT1=9999
TUNNEL_PORT2=9998
TUNNEL_PORT3=9997
DESTINATION_PORT=80

usage(){
    echo ""
    echo "Usage: $0 -s1=server1 [-u1=username1] -s2=server2 [-u2=username2] [-p1=port1] [-p2=port2] [-p3=port3] [-d=destination_port]"
    echo ""
    echo "(e.g $0 -s1=192.168.1.1 -u1=ghost1 -s2=private.repo.com -u2=magic1 -d=8080)"
    echo "If usernames are not defined the current user will be used"
    echo "The default destination port is 80"
    echo ""
    echo "List of Parameters:"
    echo ""
    echo "-s1|--server1      Tunnel Source"
    echo "-s2|--server2      Tunnel Destination"
    echo "-u1|--username1    Username for Server1 (not required)"
    echo "-u2|--username2    Username for Server2 (not required)"
    echo "-p1|--port1        Tunnel port 1"
    echo "-p2|--port2        Tunnel port 2"
    echo "-p3|--port3        Tunnel port 3"
    echo "-d|--destination   Destination port"
    exit 1
}

while [[ $# > 0 ]]
do
    i="$1"
    shift
    
    if [[ $i == *=* ]]
    then
        option=$i
    else
        if [ "$i" == "-h" ] || [ "$i" == "--help" ]
        then
            option=$i
        else
            value="$1"
            shift
            option=`echo $i=$value`
        fi
    fi

    case $option in
        -s1=*|--server1=*)
        SERVER1=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -u1=*|--user1=*)
        USER1=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -s2=*|--server2=*)
        SERVER2=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -u2=*|--user2=*)
        USER2=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -p1=*|--port1=*)
        PORT1=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -p2=*|--port2=*)
        PORT2=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -p3=*|--port3=*)
        PORT3=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -d=*|--destination=*)
        PORTDEST=`echo $option | sed 's/[-a-zA-Z0-9]*=//'`
        ;;
        -h|--help)
        usage
        ;;
        --default)
        DEFAULT=YES
        ;;
        *)
                # unknown option
        ;;
    esac
done

if [ "$SERVER1" == "" ]
then
    usage
fi

if [ "$SERVER2" == "" ]
then
    usage
fi

if [ "$USER1" == "" ]
then
    USER1=$DEFAULT_USER
fi

if [ "$USER2" == "" ]
then
    USER2=$DEFAULT_USER
fi

if [ "$PORT1" == "" ]
then
    PORT1=$TUNNEL_PORT1
fi

if [ "$PORT2" == "" ]
then
    PORT2=$TUNNEL_PORT2
fi

if [ "$PORT3" == "" ]
then
    PORT3=$TUNNEL_PORT3
fi

if [ "$PORTDEST" == "" ]
then
    PORTDEST=$DESTINATION_PORT
fi

ssh -t -R $PORT1:localhost:22 $USER1@$SERVER1 ssh -t -L $PORT2:localhost:$PORT3 $DEFAULT_USER@localhost -p $PORT1 ssh -t -L $PORT3:localhost:$PORTDEST $USER2@$SERVER2


