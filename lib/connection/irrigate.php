<?php

session_start();

// If the user is not logged in redirect to the login page...
if (!isset($_SESSION['loggedin'])) {
	header('Location: https://www.plantzilla.org');
	exit;
}

   //include "dblayerdownlink.php";
   //$link = mysqli_connect("127.0.0.1", "root", "3t6kKUPLu", "downlinks");
   //$request = mysqli_query($link, "select * From downlinks");
   //$how_many = (int) $rowcount;
   $app = "";
   $dev = "";
   
   //-------------------------------------------payload
   
   // post in case of new state is 0 
   
   $text = 0;

   $server = '127.0.0.1';
   $username = 'root';
   $password = '3t6kKUPLu';
   $database = 'users';
   
   try {
     $con = new PDO("mysql:host=$server;dbname=$database;", $username, $password);
   } catch (PDOException $e) {
     die('Connection Failed: ' . $e->getMessage());
   }


  $message = '';
  /*
  if (!empty($_POST['application']) && !empty($_POST['device']) && !empty($_POST['apikey'])) {
    $sql = "INSERT INTO ttn (server,application,device,apikey,username) VALUES (:server, :application, :device,:apikey,:username)";
    $stmt = $con->prepare($sql);
    $stmt->bindParam(':server', $_POST['server']);
    $stmt->bindParam(':application', $_POST['application']);
    $stmt->bindParam(':device', $_POST['device']);
    $stmt->bindParam(':apikey', $_POST['apikey']);
    $stmt->bindParam(':username', $_SESSION['name']);

    if ($stmt->execute()) {
      $message = 'Successfully added data to Account';
      
    } else {
      $message = 'Sorry there must have been an issue :(';
    }
  }  
*/

#importante...
$server=$_POST['server'];
$application=$_POST['application'];
$device=$_POST['device'];
$apikey=$_POST['apikey'];


if (isset($_POST['server'])) {
   $text = $_POST['value'];
   
   #$co=base64_encode($text);
   $post='{
      "downlinks": [{
        "frm_payload": "'.$text.'",
        "f_port": 1
      }]
    }';
  
  $url='https://'.$server.'.cloud.thethings.network/api/v3/as/applications/'.$application.'/devices/'.$device.'/down/push';
  
  $header='
    "content-type: application/json",
    "User-Agent: h1/3",
    "Authorization: Bearer '.$apikey.'
  ';
  
  //var_dump($post);
 // var_dump($url);
  //var_dump($header);
  
  $curl = curl_init();
   
  curl_setopt_array($curl, array(
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => '',
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS =>$post,
    CURLOPT_HTTPHEADER => array(
      'content-type: application/json',
      'User-Agent: h1/3',
      'Authorization: Bearer '.$apikey
    ),
  ));
  
  $response = curl_exec($curl);
  //print_r(curl_getinfo($curl));
  //print_r(curl_error($curl));
  curl_close($curl);
  //echo $response;

     }


   //var_dump($post);
   //-----------------------------------------------
   // We need to use sessions, so you should always start sessions using the below code.

// If the user is not logged in redirect to the login page...
if (!isset($_SESSION['loggedin'])) {
	header('Location: https://www.plantzilla.org');
	exit;
}
   
   ?>
<html lang="en">

<head>
    <link rel="shortcut icon" href="/var/www/html/favicon.ico" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" integrity="sha256-Uv9BNBucvCPipKQ2NS9wYpJmi8DTOEfTA/nH2aoJALw=" crossorigin="anonymous"></script>
    <link rel='stylesheet' href='https://fonts.googleapis.com/css2?family=Fira+Sans&amp;display=swap'>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
    <script type="text/javascript" charset="utf-8">
        $(function() {});
    </script>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title> PZ - Downlink Manager </title>
    <style>
        /* Chrome, Safari, Edge, Opera */
        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        * {
            font-size: 16px;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        
        input:-webkit-autofill {
            background-color: transparent !important;
            -webkit-box-shadow: 0 0 0 100px #a1d696 inset;
        }
        /* Firefox */
        input[type="text"],
        textarea {
            background-color: #192027;
            color: #909090;
            border: 0;
            outline: none;
            width: 16vw;
            max-width: 900px;
            font-size: 1em;
            transition: padding 0.3s 0.2s ease;
            text-align: left;
            border-bottom: 1px solid gray;
        }

        input[type="text"]:hover {
            border-bottom: 1px solid lightgray;
        }

        .button {
            background-color: #192027;
            /* Gray */
            border: none;
            color: rgba(119, 221, 119, 1);
            padding: 6px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 1.1em;
        }

        .button:hover {
            color: #1E5128;
            /* border-bottom: 1px solid rgba(149, 76, 233, 0.5); */
            border-bottom: 1px solid #1E5128;
        }

        body {
            font-family: "Fira Sans", sans-serif;
            font-size: 1.5rem;
            background-color: #192027;
            color: #656565;
            padding: 15px;
            white-space: nowrap;
            width: 0 auto;
            margin: 0;
            padding: 0;
            border: 0;
            font-size: 100%;
            vertical-align: baseline;
            line-height: 1;
        }

        .hide-scroll {
            overflow: hidden;
        }

        .viewport {
            overflow: auto;
            /* Make sure the inner div is not larger than the container
          /* so that we have room to scroll.
          */
            height: 101%;
            max-height: 100%;
            width: 108%;
            /* Pick an arbitrary margin/padding that should be bigger
          /* than the max scrollbar width across the devices that 
          /* you are supporting.
          /* padding = -margin
          */
            margin-right: -100px;
            padding-right: 100px;
        }

        .topnav {
            overflow: hidden;
            background-color: #4E9F3D;
            position: fixed;
            width: 100%;
            margin-top: 0%;
        }

        .logo {
            float: center;
            overflow: hidden;
            text-decoration: none;
            font-size: 17px;
            font-family: "Fira Sans", sans-serif;
            height: 80px;
            width: 80px;
            z-index: 10;
            position: absolute;
            margin-left: 50%;
            margin-top: -1.2%;
        }

        .topnav a {
            float: left;
            color: #f2f2f2;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-size: 17px;
            font-family: "Fira Sans", sans-serif;

        }

        .topnav a:hover {
            background-color: #D8E9A8;
            color: black;
        }

        .topnav a.active {
            background-color: #D8E9A8;
            color: black;
        }

        .topnav a.login {
            background-color: #1E5128;
            color: white;
            float: right;
        }

        .topnav a.logout {
            background-color: #1E5128;
            color: white;
            float: right;
        }

        .topnav a.user {
            background-color: #D8E9A8;
            color: black;
            float: right;

        }

        .flex-container {
            flex-wrap: nowrap;
            text-align: center;
            margin-top: -2%;
            display: flex;
        }

        .flex-container .box {
            margin-top: -1%;
            width: 35%;
            margin: 10px;
            line-height: 65px;
            font-size: 20px;
            font-family: "Fira Sans", sans-serif;
            overflow: hidden;
        }

        .flex-container .box1 {
            
            width: 100%;
            margin: 10px;
            padding-left: 5%;
            padding-right: 10%;
            margin-left: 0px;
            line-height: 40px;
            font-size: 1.1rem;
            text-align: center;
            font-family: "Fira Sans", sans-serif;
            overflow: hidden;
        }

        body {
            font-family: "Fira Sans", sans-serif;
            font-size: 1.2rem;
            background-color: #192027;
            color: #656565;
        }
    </style>
</head>
<div class="topnav">
<a href="https://www.plantzilla.org">Home</a>
         <a href="https://www.plantzilla.org/graph.php">Uplinks</a>
         <a href="https://www.plantzilla.org/downlink.php" class="active" >Downlinks</a>
         <a href="https://www.plantzilla.org/datetable.php" >Data Tables</a>
		     <a href="https://www.plantzilla.org/logout.php" class="logout"><i class="fas fa-sign-out-alt"> </i>Logout</a>
         <a href="https://www.plantzilla.org/tools.php" style="float:right;"><i class="fas fa-tools" > </i>Tools</a>
         <a href="https://www.plantzilla.org/profile.php" style="float:right;"><i class="fas fa-user-circle"  > </i>Profile</a>
        <!-- <img class="logo" src="https://www.plantzilla.org/images/Logo.png"> -->
</div>

<body>
    <div class="hide-scroll">
        <div class="viewport">

            <?php if(!empty($message)): ?>
            <p style="text-align: center; font-size:1.2rem;"> <?= $message?></p>
            <?php endif; ?>


            <iframe name="dummyframe" id="dummyframe" style="display: none;"></iframe>
            <div class="flex-container">




                <div class="box1">

                    <form method="post" action="/downlink.php" target="dummyframe" style="text-align: center;"><br>




                        <h1 style=" font-size: 55px; color:#4E9F3D; font-family: 'Fira Sans', sans-serif;  margin-top: 10%;">Custom Payload Forwarding</h1>
                        <h2 style=" font-size: 15px; color:#4E9F3D; font-family: 'Fira Sans', sans-serif; text-align:center; ">
                            https://<a style="color:darkgreen;">*server*</a>.cloud.thethings.network/api/v3/as/applications/<a style="color:darkgreen;">*ApplicationID*</a>/devices/<a style="color:darkgreen;">*DeviceID*</a>/down/push</h2><br>
                        <h2 style=" font-size: 15px; color:#4E9F3D; font-family: 'Fira Sans', sans-serif; text-align:center;">
                            The request is going to be sent to this specific application and end-device, it also requires an Api Key for authentication.</h2><br>


                        <input required="required" value="" id="server" name="server" type="text" placeholder="Server (nam1)" style="width:200px; text-align:center;"><br><br>
                        <input required="required" value="" id="application" name="application" type="text" style="width:40%;  text-align:center;" placeholder="Application-ID"><br><br>
                        <input required="required" value="" name="device" id="device" type="text" style="width:40%; text-align:center;" placeholder="End-device-ID"><br><br>
                        <input required="required" value="" name="apikey" id="apikey" type="text" style="width:100%; text-align:center; font-size: 0.8em;" placeholder="Api-Key (NNSX.ABCD1231245...)"><br><br><br>
                        <br>
                        <label>Final Payload (Base64) &nbsp;&nbsp;&nbsp;&nbsp;➟ &nbsp;&nbsp;</label>
                        <input type="text" value="" name="value" id="finalPayload" style="border-bottom: 0px; font-size: 1em;" readonly /> &nbsp;&nbsp;<input class="button" type="submit" value="Submit" /><br>

                    <div><br>
                        <label style=" left:80px;">Text&nbsp;&nbsp;&nbsp;&nbsp;➟ &nbsp;&nbsp;&nbsp;</label>
                        <input style=" left:80px;" type="text" id="textResult" />
                    </div>
                    <div><br>
                        <label style=" left:80px;">Hex&nbsp;&nbsp;&nbsp;&nbsp;➟&nbsp;&nbsp;&nbsp;</label>
                        <input style=" left:80px;" type="text" id="hexResult" pattern="[0-9a-fA-F]+" />
                    </div>
                    <div><br>
                        <label style=" left:80px;">Base64&nbsp;&nbsp;&nbsp;&nbsp;➟ &nbsp;&nbsp;&nbsp;</label>
                        <input style=" left:80px;" type="text" id="b64Result" pattern="^([0-9a-zA-Z+/]{4})*(([0-9a-zA-Z+/]{2}==)|([0-9a-zA-Z+/]{3}=))?$" />
                    </div>
                    <br><br>
                 <!--   <h1 style="color:#4E9F3D; font-size: 45px; text-align:center;" ">LED / Sprinkler Status</h1><br>
                   
                
                        <input  value="AQID"  class="button" type="submit" name="value" style=""/>
                        <input  value="AAAB"  class="button" type="submit" name="value" style=""/>
                  -->
                        </form>


                </div>              
            </div>
        </div>


        <script>
            function toHex(str) {
                var result = '';
                for (var i = 0; i < str.length; i++) {
                    result += str.charCodeAt(i).toString(16);
                }
                return result;
            }

            function hexToBase64(str) {
                return btoa(String.fromCharCode.apply(null,
                    str.replace(/\r|\n/g, "").replace(/([\da-fA-F]{2}) ?/g, "0x$1 ").replace(/ +$/, "").split(" ")));
            }

            function hexToText(hexx) {
                var hex = hexx.toString(); //force conversion
                var str = '';
                for (var i = 0; i < hex.length; i += 2)
                    str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
                return str;
            }

            function base64ToHex(str) {
                const raw = atob(str);
                let result = '';
                for (let i = 0; i < raw.length; i++) {
                    const hex = raw.charCodeAt(i).toString(16);
                    result += (hex.length === 2 ? hex : '0' + hex);
                }
                return result.toUpperCase();
            }

            $(document).ready(function() {
                $('#textResult').on('propertychange input keyup', function() {
                    var thisVal = $(this).val();
                    $('#hexResult').val(toHex(thisVal));
                    $('#b64Result').val(btoa(thisVal));
                    $('#finalPayload').val(btoa(thisVal));
                });
                $('#hexResult').on('propertychange input keyup', function() {
                    var thisVal = $(this).val();
                    $('#textResult').val(hexToText(thisVal));
                    $('#b64Result').val(hexToBase64(thisVal));
                    $('#finalPayload').val(hexToBase64(thisVal));
                });

                $('#b64Result').on('propertychange input keyup', function() {
                    var thisVal = $(this).val();
                    $('#textResult').val(atob(thisVal));
                    $('#hexResult').val(base64ToHex(thisVal));
                    $('#finalPayload').val(thisVal);
                });
            });
        </script>

    </div>
    </div>
</body>

</html>