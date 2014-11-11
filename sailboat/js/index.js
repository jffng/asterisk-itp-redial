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

var imagesLoaded = false;

function setup () {
	createCanvas(window.innerWidth, window.innerHeight);
	background(88,195,237);

	for(var i = 0; i < 5; i++){
		var imgIndex = i % sailboatImages.length;
		sailboats[i] = new Sailboat(i, sailboatImages[imgIndex]);
	}
}

function draw () {
	background(88,195,237);

	for(var s in sailboats){
		var dragForce = calculateDrag(sailboats[s]);

		sailboats[s].apply_force(dragForce);
		sailboats[s].check_borders();
		sailboats[s].update();
		sailboats[s].display(3);
	}
}

function mousePressed(){
	for(var s in sailboats){
		sailboats[s].apply_force(.5);
	}
}

function keyPressed(){
	switch (keyCode){
		case UP_ARROW:
			sailboats[0].change_orientation("north");
			break;
		case DOWN_ARROW:
			sailboats[0].change_orientation("south");
			break;
		case RIGHT_ARROW:
			sailboats[0].change_orientation("east");
			break;
		case LEFT_ARROW:
			sailboats[0].change_orientation("west");
			break;	
	}
}