while read p; do ./fibmrktest.linux_64.tsk $p; if [ $? -ne 0 ]; then echo $?; echo $p; break; fi; done < <(grep -v 'excludetest' ../testsuites)
