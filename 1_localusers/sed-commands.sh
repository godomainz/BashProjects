#!/bin/bash
sed 's/my wife/sed/' love.txt
sed 's/my wife/sed/2' love.txt
sed 's/MY WIFE/sed/i' love.txt
sed 's/my wife/sed/g' love.txt
sed -i.bak 's/my wife/sed/g' love.txt
sed -i 's/my wife/sed/g' love.txt
sed -i.bak 's/my wife/sed/g' love.txt
sed 's/love/like/gw like.txt' love.txt

echo '/home/jason' | sed 's/\/home/jason/\/export\/users\/jasonc:'
echo '/home/jason' | sed 's:/home/jason:/export/users/jasonc:'

sed '/^#/d' love.txt
sed '/^$/d' love.txt
sed '/^#/d ; /^$/d ; s/apache/httpd/' love.txt
sed -e '/^#/d' -e '/^$/d' -e 's/apache/httpd/' love.txt

sed '2 s/apache/httpd/' love.txt
sed '2s/apache/httpd/' love.txt
sed '/Group/ s/apache/httpd/' love.txt

sed '1,3 /love/like/' love.txt
sed '/#User/,/^$/ /apache/httpd/' love.txt





