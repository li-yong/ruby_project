#--------------------------   run ssh command
require "net/ssh"
require 'net/scp'

host="ssh.netfirms.com"
user="myvpsoft"
password="fav8ht39"

 
 lfile="c:/tmp/update.sql_osc20090708.tgz"
 rmtfile="/mnt/b02b1940/www/splitsql/update.sql_osc20090708.tgz"

def sshcmd(host,user,password,cmd)
 Net::SSH.start(host, user, :password => password) do |ssh|
    result = ssh.exec!("ls -l")
    puts result
  end
  
end #def sshcmd(host,user,password,cmd)



def scpcmd(host,user,password,lfile,rfile)
 
    Net::SSH.start(host,user, :password => password) do |ssh|
    ssh.scp.upload! localfile, rmtfile
  end

end #def scpcmd(host,user,pasword,lfile,rfile)

#-----------Main Start 
cmd="rm -f "+rmtfile
sshcmd(host,user,password,cmd)
scpcmd(host,user,password,lfile,rfile)

cmd="cd splitsql; gunzip update.sql_osc20090708.tgz; "
cmd=cmd+" tar -xvf update.sql_osc20090708.tar;  "
cmd=cmd+" mysql  -uu70415274 -p@Ap3#ple d60378146 < update.sql_osc20090708"                              
    

sshcmd(host,user,password,cmd)



