#!/usr/bin/env python
import subprocess
import smtplib
import socket
from email.mime.text import MIMEText
import datetime
import sys

# we assume the arguments are correct
gmail_user = str(sys.argv[1])
gmail_password = str(sys.argv[2])
to = str(sys.argv[3])
body = str(sys.argv[4])

# Change to your own account information
#to = ''
#gmail_user = ''
#gmail_password = ''
smtpserver = smtplib.SMTP('smtp.gmail.com', 587)
smtpserver.ehlo()
smtpserver.starttls()
smtpserver.ehlo
smtpserver.login(gmail_user, gmail_password)
today = datetime.date.today()

# Very Linux Specific
arg='ip route list'
p=subprocess.Popen(arg,shell=True,stdout=subprocess.PIPE)
data = p.communicate()
split_data = data[0].split()
ipaddr = split_data[split_data.index('src')+1]
my_ip = 'Your ip is %s' %  ipaddr

# the message
msg = MIMEText(body)
#msg['Subject'] = 'IP For RaspberryPi on %s' % today.strftime('%b %d %Y')
msg['Subject'] = 'A compliment for you'
msg['From'] = gmail_user
msg['To'] = to
smtpserver.sendmail(gmail_user, [to], msg.as_string())
smtpserver.quit()
