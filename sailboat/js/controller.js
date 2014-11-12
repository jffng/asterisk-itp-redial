var Controller = function () {
	this.game_started = false;

	this.game_ended = false;

	var self = this;

	loadSong("sailing-theme-8bit.mp3");
	var context = new AudioContext();
	var song;

	document.getElementById("start").addEventListener("click", function(){
		var element = document.getElementById("instructions");
		element.parentNode.removeChild(element);

		self.game_started = true;

		playSound(song);
	});	

	function loadSong(url) {
		var request = new XMLHttpRequest();
		request.open('GET', url, true);
		request.responseType = 'arraybuffer';

		// Decode asynchronously
		request.onload = function() {
				context.decodeAudioData(request.response, function(buffer) {
				song = buffer;
			});
		}
		request.send();
	}

	function playSound(buffer) {
		var source = context.createBufferSource(); // creates a sound source
		source.buffer = buffer;                    // tell the source which sound to play
		source.connect(context.destination);       // connect the source to the context's destination (the speakers)
		source.start(0);                           // play the source now
		                                         // note: on older systems, may have to use deprecated noteOn(time);
	}	
}

Controller.prototype.start_game = function(players) {
	for(var i = 0; i < players.length; i++){
		players[i].enabled = true;
	}

	this.game_started = true;
};

Controller.prototype.update = function(players){
	fill(10);
	textFont("Courier New");
	textAlign(CENTER);
	textSize(72);
	var welcomeString = "206-203-7127 to join";

	if(this.game_started) 	this.start_game(players);
	else 					text(welcomeString, width / 2, height / 2);	

	for(var i = 0; i < players.length; i++){
		if(players[i].position.x > width * .95){
			var digits = players[i].id.toString();
			digits = "#" + digits.slice(6,10) + " WINS!!!!";

			this.game_ended = true;

			text(digits, width / 2, height / 2);			
		}
	}

	if(this.game_ended){
		for(var i = 0; i < players.length; i++){
			players[i].enabled = false;
		}
	}
}

//////////////////////////////////////////////////////////////////////////
///
///					AUDIO 
///
//////////////////////////////////////////////////////////////////////////




