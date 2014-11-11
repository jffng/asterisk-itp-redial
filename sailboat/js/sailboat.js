var Sailboat = function (callerid, img) {
	this.id = callerid;

	this.orientation = "east";
	this.mass = 1;

	this.position = createVector(5, Math.random()*height);
	this.velocity = createVector(0, 0);
	this.acceleration = createVector(0, 0);

	this.img = img;

	var self = this;

	this.img = img;
	// this.img_loaded = true;

	// this.img = loadImage(img, function(){
	// 	console.log("loaded: " + img);
	// 	self.img_loaded = true;
	// });
}

Sailboat.prototype.apply_force = function(mag) {
	var force;

	switch (this.orientation){
		case "east":
			force = createVector( mag, 0);
			break;
		case "west":
			force = createVector( -mag , 0 );
			break;
		case "north":
			force = createVector(0, -mag);
			break;
		case "south":
			force = createVector(0, mag);
			break;
	};

	var f = p5.Vector.div(force, this.mass);
	this.acceleration.add(f);
};

Sailboat.prototype.change_orientation = function(orientation){
	switch (orientation){
		case "6":
			this.orientation = "east";
			break;
		case "4":
			this.orientation = "west";
			break;
		case "2":
			this.orientation = "north";
			break;
		case "8":
			this.orientation = "south";
			break;
	};
};

Sailboat.prototype.update = function(){
	this.velocity.add(this.acceleration);
	this.position.add(this.velocity);
	this.velocity.mult(.975);
	this.acceleration.mult(0);
};

Sailboat.prototype.check_borders = function(){
	if(this.position.y >= height || this.position.y <= 0) this.velocity.mult(-1);
	if(this.position.x < 0) this.velocity.mult(-1);
};

Sailboat.prototype.display = function(scaleFactor){
	image(this.img, this.position.x, this.position.y, this.img.width / scaleFactor, this.img.height / scaleFactor);

	var digits = this.id.toString();
	digits = "#" + digits.slice(6,10);
	
	fill(0);
	textAlign(CENTER);
	textSize(32 / scaleFactor);
	text(digits, this.position.x + this.img.width / scaleFactor, this.position.y + this.img.height / scaleFactor / 2);
}


function calculateDrag(m) {
	var dragCoefficient = 1;
	// Magnitude is coefficient * speed squared
	var speed = m.velocity.mag();
	var dragMagnitude = dragCoefficient * speed * speed;

	// Direction is inverse of velocity
	var dragForce = m.velocity.get();
	dragForce.mult(-1);

	// Scale according to magnitude
	dragForce.setMag(dragMagnitude);
	dragForce.normalize();
	dragForce.mult(dragMagnitude);
	return dragForce;
};