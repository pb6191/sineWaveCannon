<?php
$json = file_get_contents('php://input');
$obj = json_decode($json, true);
$outfile = fopen('C:\Users\PC-P14s\Downloads\\'.$obj["filename"], "a");
fwrite(
    $outfile,
    sprintf($obj["filedata"])
);
fclose($outfile);
?>