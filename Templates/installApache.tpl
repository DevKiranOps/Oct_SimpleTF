#!/bin/bash
set -x
source /etc/lsb-release

export  DEBIAN_FRONTEND="noninteractive" 
sudo apt-get update -y
sudo apt-get install apache2 -y 


cat << EOF > /tmp/index.html
<html>
<title> CareerIT </title>
<body> 
    <h1> Career IT </h1>
    <pre>

    </pre>

    <h2> Amazon Web Services  </h2>
    <h2> Azure  </h2>
</body>
</html>
EOF

sudo cp /tmp/index.html /var/www/html/index.html