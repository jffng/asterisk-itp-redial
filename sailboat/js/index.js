var width = window.innerWidth;
var height = window.innerHeight;

var sailboats = [];
var sailboatImages = [
	"sailboats/1.png",
	"sailboats/2.png",
	"sailboats/3.png",
	"sailboats/4.png",
	"sailboats/5.png",
	"sailboats/6.png",
	"sailboats/7.png",
	"sailboats/8.png" ];
var finishLine;

var controller = new Controller();

//////////////////////////////////////////////////////////////////////////
///
///					P5 INIT
///
//////////////////////////////////////////////////////////////////////////

function setup () {
	createCanvas(window.innerWidth, window.innerHeight);
	background(88,195,237);

	finishLine = loadImage("finishline.png");

	for(var i = 0; i < sailboatImages.length; i++){
		sailboatImages[i] = loadImage(sailboatImages[i]);
	}

}

function draw () {
	background(88,195,237);

	imageMode(CENTER);
	image(finishLine, width * .95, height / 2, finishLine.width / 2, finishLine.height * 1.5);

	controller.update(sailboats);

	for(var s in sailboats){
		var dragForce = calculateDrag(sailboats[s]);

		sailboats[s].separate(sailboats);
		sailboats[s].apply_force(dragForce);
		sailboats[s].check_borders();
		sailboats[s].update();
		sailboats[s].display(3);
	}
}

//////////////////////////////////////////////////////////////////////////
///
///					TINYPHONE CONFIG + EVENT LISTENERS
///
//////////////////////////////////////////////////////////////////////////

var phoneNumber = "12062037127";

tinyphone.init("104.236.42.157",12003,phoneNumber);

tinyphone.on('connect', function(){
	console.log("connected to tinyphone with phone number "+tinyphone.phoneNumber);
});

tinyphone.on('new_call', function(caller){
	// console.log("new caller "+caller.callerNumber+" (label "+caller.callerLabel+"), id "+caller.id+", args ["+caller.args.join(", ")+"]");

	sailboats.push(new Sailboat(caller.callerNumber, sailboatImages[sailboats.length % sailboatImages.length]));
});

tinyphone.on('keypress', function(caller){
	// console.log("received keypress '"+caller.keypress+"' from "+caller.callerNumber);

	for(var i = 0; i < sailboats.length; i++){
		if(caller.callerNumber == sailboats[i].id ) sailboats[i].change_orientation(caller.keypress);
	}
});

tinyphone.on('audio_level', function(caller){
	// console.log("received audio level '"+caller.audioLevel+"' from "+caller.callerNumber);

	for(var i = 0; i < sailboats.length; i++){
		if(caller.callerNumber == sailboats[i].id) sailboats[i].apply_force(caller.audioLevel / 5);
	}
});

tinyphone.on('hangup', function(caller){
	for(var i = 0; i < sailboats.length; i++){
		if(caller.callerNumber == sailboats[i].id) sailboats.splice(i, 1);
	}
});

//////////////////////////////////////////////////////////////////////////
///
///					TEST FUNCTIONS
///
//////////////////////////////////////////////////////////////////////////

// function mousePressed(){
// 	sailboats.push(new Sailboat('test12349234', sailboatImages[0]));

// 	// for(var s in sailboats){
// 	// 	sailboats[s].apply_force(.5);
// 	// }
// }

// function keyPressed(){
// 	switch (keyCode){
// 		case UP_ARROW:
// 			sailboats[0].change_orientation("north");
// 			break;
// 		case DOWN_ARROW:
// 			sailboats[0].change_orientation("south");
// 			break;
// 		case RIGHT_ARROW:
// 			for(var s in sailboats){
// 				sailboats[s].apply_force(.25);
// 			}
// 			break;
// 		case LEFT_ARROW:
// 			sailboats[0].change_orientation("west");
// 			break;	
// 	}
// }