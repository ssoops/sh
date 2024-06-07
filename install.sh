#!/bin/bash
PS3='请选择你要部署的应用: '
actions=("部署Consul" "..." "..." "Quit")
select fav in "${actions[@]}"; do
    case $fav in
        "部署Consul")
            echo "Americans eat roughly 100 acres of $fav each day!"
            ;;
        "Pho")
            echo "$fav is a Vietnamese soup that is commonly mispronounced like go, instead of duh."
	    # optionally call a function or run some code here
            ;;
        "Tacos")
            echo "According to NationalTacoDay.com, Americans are eating 4.5 billion $fav each year."
	    # optionally call a function or run some code here
	    break
            ;;
	"Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
