<!DOCTYPE html>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
 <head>
  <title>Digital Card Store</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <style>

.dashboard-page {
  padding-top: 50px;
}
.form {
  position: relative;
  z-index: 1;
  background: #FFFFFF;
  max-width: 360px;
  margin: 10px;
  padding: 10px ;
  text-align: center;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}
.form input {
  font-family: "Tahoma", sans-serif;
  outline: 0;
  background: #f2f2f2;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}
.form button {
  font-family: "Tahoma", sans-serif;
  outline: 0;
  background: #4CAF50;
  width: 100%;
  border: 0;
  padding: 15px;
  color: #FFFFFF;
  font-size: 14px;
  -webkit-transition: all 0.3 ease;
  transition: all 0.3 ease;
  cursor: pointer;
}
.form button:hover,.form button:active,.form button:focus {
  background: #43A047;
}
.form .message {
  margin: 15px 0 0;
  color: #b3b3b3;
  font-size: 12px;
}
.form .message a {
  color: #4CAF50;
  text-decoration: none;
}
.container {
  position: relative;
  z-index: 1;
  max-width: 300px;
  margin: 0 auto;
}
.container:before, .container:after {
  content: "";
  display: block;
  clear: both;
}
.container .info {
  margin: 50px auto;
  text-align: center;
}
.container .info h1 {
  margin: 0 0 15px;
  padding: 0;
  font-size: 36px;
  font-weight: 300;
  color: #1a1a1a;
}
.container .info span {
  color: #4d4d4d;
  font-size: 12px;
}
.container .info span a {
  color: #000000;
  text-decoration: none;
}
.container .info span .fa {
  color: #EF3B3A;
}
body {
  background: #76b852; /* fallback for old browsers */
  background: -webkit-linear-gradient(right, #76b852, #8DC26F);
  background: -moz-linear-gradient(right, #76b852, #8DC26F);
  background: -o-linear-gradient(right, #76b852, #8DC26F);
  background: linear-gradient(to left, #76b852, #8DC26F);
  font-family: "Roboto", sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;      
}

table {
	background-color: black;
}

th {
	background-color: lightgray;
}

td {
	background-color: white;
	padding: 5px;
}
#notif-container {
	width: 90%;
	margin: auto;
	border: 1px solid black; 
	background: white;
	font-size: 14px 
}
#notif-container img {
	vertical-align: middle;
}

#notif-title {
	padding: 2px;
	border-bottom: 1px solid black;
	background-color: #d1ecc2;
}
#notifications {
	padding: 5px;
}
#audioRecdPanel {
	float: right;
	background-color: white;
}

.chatContainer
{
  clear: both;	
  width: 422px;
  float: right;
  border: 1px solid black;
  margin-top: 60px;
  height: 842px;
  margin-right: 4px;
}

.chat
{
  clear: both;
  width: auto;
  border: none;
  padding: 10px;
  background-color: white;
  overflow: scroll;
  height: 800px;
}

.chat p
{
  font-family: Arial;
  font-size: 14px;
  border-radius: 6px;
  padding: 6px;
  clear: both;
  border: 1px solid navy;
  margin-bottom: 3px;
  margin-top: 3px;
}

.me 
{
  float: left;
  background-color: #AABBFF;
  margin-right: 20%;
}

.bot
{
  float: right;
  background-color: #EEEEEE;
  margin-left: 20%;
}

#speechStatus
{
	font-family: Arial;
	font-size: 14px;
	color: navy;
	background-color: lightgray;
	width: auto;
	border-bottom: 1px solid black;
	padding: 2px;
}
  </style>
  <script>
  // Builds the HTML Table out of list.
  function buildHtmlTable(list, columnList, selector, actionHeader, handlerName) {
	 $(selector).empty();
	 
    addAllColumnHeaders(columnList, selector, actionHeader);

    for (var i = 0; i < list.length; i++) {
      var row$ = $('<tr/>');
      for (var colIndex = 0; colIndex < columnList.length; colIndex++) {
        var cellValue = list[i][columnList[colIndex]];
        if (cellValue == null) cellValue = "";
        if (columnList[colIndex] == 'imageUrl')
        	cellValue = '<img style="border:1px solid gray;height:160px;width:120px;" src="' + cellValue + '"/>';
        row$.append($('<td/>').html(cellValue));
      }
      row$.append($('<td>&nbsp;</td>'));
      row$.append($('<td><button onclick="' + handlerName + '(' + i + ')">O</button></td>'));
      $(selector).append(row$);
    }
  }

  // Adds a header row to the table and returns the set of columns.
  // Need to do union of keys from all records as some records may not contain
  // all records.
  function addAllColumnHeaders(columns, selector, actionHeader) {
    var headerTr$ = $('<tr/>');

    for (var i = 0; i < columns.length; i++) {
       headerTr$.append($('<th/>').html(columns[i]));
    }
    headerTr$.append($('<th/>').html("&nbsp;"));
    headerTr$.append($('<th/>').html(actionHeader));
    $(selector).append(headerTr$);
  }
  
  function convertFormToJSON(form){
	    var array = jQuery(form).serializeArray();
	    var json = {};
	    
	    jQuery.each(array, function() {
	        json[this.name] = this.value || '';
	    });
	    
	    return json;
   }
 
  function setBalance(newBalance) {
	  $("#balance").html('<b>' + newBalance + '</b>');
  }
  
	function handleBuyCardResponse(name, res) {
		if (res.error)
			alert("Can't buy card " + name + '. Error: ' + res.error);
		else {
			setBalance(res.newBalance);
			//alert('Card ' + name + ' bought successfully. Your current balance is ' + res.newBalance);
			listCards(true);
		}
	}
	function buyCard(owner, name) {
	   $.ajax({
		   type: "POST",
		   url: "buy",
		   data: JSON.stringify({owner:owner, name: name}),
		   success: function(data){handleBuyCardResponse(name, data);},
		   dataType: "json",
		   contentType : "application/json"
		 });
   }
   function buyCardClicked(idx) {
	   var owner = $('#insale-cards-table')[0].childNodes[idx+1].childNodes[2].innerText;
	   var name = $('#insale-cards-table')[0].childNodes[idx+1].childNodes[0].innerText;
	   var price = $('#insale-cards-table')[0].childNodes[idx+1].childNodes[3].innerText;
	   
	   if (confirm("Are you sure to buy the card " + name + " at the price " + price + " ?"))
		   buyCard(owner, name);
   } 
  
  function defaultHandleSellCardCallback(text) {
	  alert(text);
  }
  function handleSellCardResponse(name, res, sellCardCallback) {
	   var text;
	   if (res)
		   text = 'Card ' + name + ' marked as OnSale successfully.';
	   else
		   text = "Can't mark card " + name + ' as OnSale.';
	   var cb = sellCardCallback || defaultHandleSellCardCallback;
	   cb(text);
   }
   function sellCard(name, price, sellCardCallback) {
	   $.ajax({
		   type: "POST",
		   url: "sell",
		   data: JSON.stringify({name:name, price: price}),
		   success: function(data){handleSellCardResponse(name, data, sellCardCallback);},
		   dataType: "json",
		   contentType : "application/json"
		 });
   }
   function sellCardClicked(idx) {
	   var name = $('#my-cards-table')[0].childNodes[idx+1].childNodes[0].innerText;
	   var price = window.prompt("Please enter the sell price for the card " + name, "10")
	   sellCard(name, price);
   } 
   
   function showMyCards(res) {
	   buildHtmlTable(res, ['name', 'dateLoaded', 'imageUrl'], '#my-cards-table', 'Sell', 'sellCardClicked');
   }
   function showInSaleCards(res) {
	   buildHtmlTable(res, ['name', 'dateLoaded', 'owner', 'price', 'imageUrl'], '#insale-cards-table', 'Buy', 'buyCardClicked');
   }
   function listCards(inSale) {
	   $.ajax({
		   type: "GET",
		   url: "cards?inSale=" + inSale,
		   success: function(data){if (inSale) { showInSaleCards(data)} else { showMyCards(data);}},
		   dataType: "json",
		   contentType : "application/json"
		 });
   }

   function handleAddCardResponse(card) {
	   alert('Card ' + card.name + ' added successfully.');
	   $("#add-card-form")[0].reset();
	   $("#add-card-form-div").hide();
   }
   function addCard() {
	   var formData = convertFormToJSON($("#add-card-form"));
	   $.ajax({
		   type: "POST",
		   url: "cards",
		   data: JSON.stringify(formData),
		   success: function(data){handleAddCardResponse(data);},
		   dataType: "json",
		   contentType : "application/json"
		 });
   }
   function addCardClicked() {
	   $("#add-card-form-div").show(); 
	   $("#my-cards-table-div").hide(); 
	   $("#insale-cards-table-div").hide();
   }
   
   function listMyCards() {
	   $("#add-card-form-div").hide(); 
	   $("#my-cards-table-div").show(); 
	   $("#insale-cards-table-div").hide();
	   listCards(false);
   }
   function listInSaleCards() {
	   $("#add-card-form-div").hide(); 
	   $("#my-cards-table-div").hide(); 
	   $("#insale-cards-table-div").show();
	   listCards(true);
   }
   
   function logout() {
	   $.ajax({
		   type: "POST",
		   url: "logout",
		   success: function(data){ window.location.reload(); },
		   dataType: "json",
		   contentType : "application/json"
		 });
   }
   
	function doCardImageFileUpload(file, data){

		var formData = new FormData();
		
		formData.append('key', data.fileName);
		formData.append('acl', 'public-read');
		formData.append('Content-Type', data.contentType);
		formData.append('X-Amz-Credential', data.credential);
		formData.append('X-Amz-Algorithm', "AWS4-HMAC-SHA256");
		formData.append('X-Amz-Date', data.date);
		formData.append('Policy', data.policy);
		formData.append('X-Amz-Signature', data.signature);
		formData.append('file', $('input[type=file]')[0].files[0]);
		
		$.ajax({
		    url: data.bucketUrl,
		    data: formData,
		    type: 'POST',
		    contentType: false,
		    processData: false,
		    success: function () {
		    	var imageUrl = data.bucketUrl + "/" + data.fileName;
		    
		    	document.getElementById('cardImagePreview').src = imageUrl;
		    	document.getElementById('cardImageUrl').value = imageUrl;
		    },
		    error: function () { 
		    	alert("Upload error."); 
		    }
		});
	}

	function startCardImageFileUpload(file) {
		$.ajax({
		  type: "POST",
		  url: "presign",
		  data: 'contentType=' + encodeURIComponent(file.type) + '&fileName=' + encodeURIComponent(file.name), 
		  success: function(data){
			  if (data.errorMessage)
				alert(data.errorMessage);
			  else
		      	doCardImageFileUpload(file, data);
		  },
		});
	}
   
	function cardImageFileUpdated(){	
		var file = document.getElementById('cardImageInput').files[0];
	 	
		if (file != null)
			startCardImageFileUpload(file);
	}

	function messageForData(data) {
		return "Your card, " + data.name + ", has been bought by " + data.newOwner + ", for " + data.price + "$";
	}
	
	function playAudio(data) {
		var audio = new Audio('audio?msg=' + messageForData(data));
		audio.play();
	}
	
	function animateSpeaker() {
		$('#speaker').fadeTo("slow", 0.15).delay(400).fadeTo("slow", 1).delay(400).fadeTo("slow", 0.15).delay(400).fadeTo("slow", 1).delay(400).fadeTo("slow", 0.15).delay(400).fadeTo("slow", 1);
	}
	
	function setNotification(data) {
    	var msg = messageForData(data);
    	var spn$ = $('<span/>').html(msg + '&nbsp;<img id="speaker" src="images/speaker.png"/>');
    	$('#notifications').empty().append(spn$);
    	animateSpeaker();
	}
	
	function processCardSoldEvent(data) {
		setBalance(data.oldOwnerBalance);
		setNotification(data);
		playAudio(data);
	}
	
	function initNotifications() {
		if (typeof (EventSource) !== "undefined") {
			var source = new EventSource("feed");
			source.addEventListener('cardSold', function(event) {
				var data = JSON.parse(event.data);
				processCardSoldEvent(data);
			});
		}
	}
	
	var speechRecorder = {};

	function playAudioFromUrl(url, finishHandler) {
		setSpeechStatus('Speaking...');
		var audio = new Audio(url);
		audio.onended = function() { 
			if (finishHandler)
				finishHandler();
		}
		audio.play();
	}
	function stopRecording() {
		speechRecorder.recorder.stop();
	}
	function startRecording() {
		setSpeechStatus('Listening...');
		speechRecorder.recorder.start();
		setTimeout(stopRecording, 4000);
	}
	function handleLexResponse(speechRes) {
   		if (speechRes.command == 'LOGOUT') {
   			playChatResponse('Okay. You are logging out, good bye.', function() {
   				logout();
			});
   			return;
   		}
		replaceChatAudioInputLine(speechRes.inputText);
		if (speechRes.command == 'UNKNOWN') {
			addChatBotResponse(speechRes.responseText);
  			playAudioFromUrl('speechResponseAudio', startRecording);
		}
		else {
			if (speechRes.command == 'ADD_CARD') {
				playChatResponse('Okay. You can add your card using this form.', function() {
					addCardClicked();
					startRecording();
				});
			}
			else if (speechRes.command == 'SHOW_MY_CARDS') {
				playChatResponse('Okay. Here are your cards.', function() {
					listMyCards();
					startRecording();
				});
			}
			else if (speechRes.command == 'SELL_CARD')
				sellCard(speechRes.cardName, speechRes.cardPrice, function (resultMessage) {
					playChatResponse(resultMessage, startRecording);
				});
   		}
	}
	function sendAudioToLex(audioData) {
		setSpeechStatus('Analyzing...');
		addChatAudioInputLine();
		$.ajax({
			type: 'POST',
			url: 'speech',
			data: audioData,
			contentType: false,
			cache: false,
			processData: false,
	    	success: handleLexResponse,
		    error: function () { 
		    	alert("Can't send audio.");
		    	startRecording();
		    }
		});		
	}

    function reSample(audioBuffer, targetSampleRate, onComplete) {
        var channel = audioBuffer.numberOfChannels;
        var samples = audioBuffer.length * targetSampleRate / audioBuffer.sampleRate;

        var offlineContext = new OfflineAudioContext(channel, samples, targetSampleRate);
        var bufferSource = offlineContext.createBufferSource();
        bufferSource.buffer = audioBuffer;

        bufferSource.connect(offlineContext.destination);
        bufferSource.start(0);
        offlineContext.startRendering().then(function(renderedBuffer){
          onComplete(renderedBuffer);
        })
    }

    var SILENCE_THRESHOLD = 0.04;
    
    function removeSilence(buffer) {
        var l = buffer.length;
        var nonSilenceStart = 0;
        var nonSilenceEnd = l;
        while (nonSilenceStart < l) {
            if (Math.abs(buffer[nonSilenceStart]) > SILENCE_THRESHOLD)
            	break;
            nonSilenceStart++;
	    }
        while (nonSilenceEnd > nonSilenceStart) {
            if (Math.abs(buffer[nonSilenceEnd]) > SILENCE_THRESHOLD)
            	break;
            nonSilenceEnd--;
	    }
        var retBuffer = buffer;
        if (nonSilenceStart != 0 || nonSilenceEnd != l) {
        	retBuffer = buffer.subarray(nonSilenceStart, nonSilenceEnd);
        }
        return retBuffer;
    }

    function convertFloat32ToInt16(buffer) {
    	buffer = removeSilence(buffer);
        var l = buffer.length;
        var buf = new Int16Array(l);
        while (l--) {
                buf[l] = Math.min(1, buffer[l]) * 0x7FFF;
        }
        return buf.buffer;
    }
    
	function initSpeechRecording() {
        navigator.mediaDevices.getUserMedia({
            audio: true
        }).then(
            function onSuccess(stream) {

                var data = [];
               
                speechRecorder.recorder = new MediaRecorder(stream);
                speechRecorder.audioContext = new AudioContext();

                speechRecorder.recorder.ondataavailable = function(e) {
                    data.push(e.data);
                };

                speechRecorder.recorder.onerror = function(e) {
                    throw e.error || new Error(e.name);
                }

                speechRecorder.recorder.onstart = function(e) {
                    data = [];
                }

                speechRecorder.recorder.onstop = function(e) {
                	setSpeechStatus('Checking silence...');
                	var blobData = new Blob(data, {type: 'audio/x-l16'});
                    var reader = new FileReader();

                    reader.onload = function() {
                    	speechRecorder.audioContext.decodeAudioData(reader.result, function(buffer) {
                    		reSample(buffer, 16000, function(newBuffer) {
								var trimmedBuffer = removeSilence(newBuffer.getChannelData(0));
								if (trimmedBuffer.length > 0) // if its not fully silence, send to Lex
	                            	sendAudioToLex(convertFloat32ToInt16(trimmedBuffer));
                            	else 
                            		startRecording();
                            });
                        });
                    };
                    reader.readAsArrayBuffer(blobData);
                }
            });
	}
	var lastAudioInputId = 0;

	function addChatAudioInputLine() {
		var row$ = $('<p id="audioInput' + ++lastAudioInputId + '" class="me">Audio input</p>');
		$('#chat').append(row$);
		$("#chat").scrollTop($("#chat")[0].scrollHeight);
	}
	function replaceChatAudioInputLine(txt) {
		$('#audioInput' + lastAudioInputId).html(txt);
	}
	function addChatBotResponse(txt) {
		var row$ = $('<p class="bot">' + (txt || '&nbsp;') + '</p>');
		$('#chat').append(row$);
		$("#chat").scrollTop($("#chat")[0].scrollHeight);
	}
	function playChatResponse(txt, callback) {
		addChatBotResponse(txt);
		playAudioFromUrl('audio?msg=' + txt, callback);
	}
	function setSpeechStatus(txt) {
		$('#speechStatus').html(txt);
	}
	function initPage() {
		initNotifications();
		initSpeechRecording();
		playChatResponse('Welcome ${user.name}. Your current balance is ${user.balance}$. What would you like to do ?', startRecording);
	}
	</script>
 </head>
 <body onload="initPage()">
	<div class="chatContainer">
		<div id="speechStatus"></div>
		<div id="chat" class="chat"></div>
	</div>
	<div id="notif-container">
		<div id="notif-title">
			<img src="images/notification.png"/>
			<span>Notifications</span>
		</div>
		<div id="notifications"></div>
	</div>
	<div class="dashboard-page">
		<span><b>Welcome ${user.name}</b></span>
		<br/>
		<span>Balance</span>
		<span id="balance"><b>${user.balance}</b></span>
		<br/>
		<br/>
		<div>
			<button onclick="addCardClicked()">Add Card</button>
			<button onclick="listMyCards()">My Cards</button>
			<button onclick="listInSaleCards()">On Sale Cards</button>
			&nbsp;
			&nbsp;
			<button onclick="logout()">Logout</button>
		</div>
		<br/>
		<br/>
		<div id="add-card-form-div" style="display:none">
			<form id="add-card-form" onsubmit="return false;">
				<span>Card Name</span>
				<input type="text" name="name" placeholder="name" /><br/>
				
				<span>Card Image File</span> 
				<input type="file" id="cardImageInput" accept="image/*" onchange="cardImageFileUpdated()"/>
				<br/>
				<img style="border:1px solid gray;height:160px;width:120px;" id="cardImagePreview" src="/images/default-card.png"/>
				<input type="hidden" id="cardImageUrl" name="imageUrl" value="/images/default-card.png"/> <br/>
				<br/>
				<button onclick="addCard()">Add</button>
			</form>
		</div>
		<div id="my-cards-table-div">
			<table id="my-cards-table" cellspacing=1 cellpadding=2>
			</table>
		</div>
		<div id="insale-cards-table-div">
			<table id="insale-cards-table" cellspacing=1 cellpadding=2>
			</table>
		</div>
	</div>
	
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.js"></script>
  <script src="https://www.WebRTC-Experiment.com/RecordRTC.js"></script>
</body>
</html>
