#!/opt/local/bin/bash

    echo "Date-time: $(date)"
    echo "Running periodic update of MacPorts...\n"

    echo "Beginning 'port selfupdate'"
    /opt/local/bin/port -q selfupdate >> /Users/jmoore/scripts/updt-macports/updt_mp.log
    echo "Completed 'port selfupdate'"
    echo "----------"

    /bin/sleep 2

    echo "Beginning 'port upgrade outdated'"
    /opt/local/bin/port -q upgrade outdated >> /Users/jmoore/scripts/updt-macports/updt_mp.log
    echo "Completed 'port upgrade outdated'"
    echo "----------\n"

exit

