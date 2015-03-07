DB=testevaldb
USR=testeval
PSW=testeval

while true; do

    SLEEP=$(python -c "import random; print int(random.uniform(0, 5))")
    echo $(date): Sleeping for $SLEEP >> /home/cchudzian/projects/evaluator/submissions.log
    sleep $SLEEP

    SUBMNO=$(python -c "import random; print int(random.uniform(1, 5+1))")
    echo $(date): Submitting $SUBMNO >> /home/cchudzian/projects/evaluator/submissions.log
    mysql -D $DB -u $USR -p$PSW < subm${SUBMNO}.sql

    if [ "True" == $(python -c "import random; print random.random() <.01") ]; then
        echo $(date): Submitting sleeper >> /home/cchudzian/projects/evaluator/submissions.log
        mysql -D $DB -u $USR -p$PSW < subm6.sql
    fi


    if [ "True" == $(python -c "import random; print random.random() <.001") ]; then
        echo $(date): Killing evaluator >> /home/cchudzian/projects/evaluator/submissions.log
        kill -int $(cut -d '@' -f 1 /home/cchudzian/projects/evaluator/.evaluator-lock)
    fi

done 

