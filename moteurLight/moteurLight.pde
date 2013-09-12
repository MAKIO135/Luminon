// import oscP5.*;
// import netP5.*;

// OscP5 oscP5;
// NetAddress myRemoteLocation;

final int NB_PNX_WALL = 6;
final int NB_LEDSTRIPS = 27;
final int MARGE = 50;

Panneau[] pnx;

int displayMode = 0;
float w, h, hLed;

void setup() {
	size(600, 400);
	frameRate(20);
	noStroke();

	w = int(width/NB_PNX_WALL);
	h = (height-MARGE)/2;
	hLed = h/NB_LEDSTRIPS;
	pnx = new Panneau[NB_PNX_WALL*2];
	// console.log("pnx.length: "+pnx.length);
	for (int i=0, len=pnx.length; i<len; i++) {
		pnx[i] = new Panneau(i);
	}

	// OSC Communication
	// oscP5 = new OscP5(this, 3008);
	// myRemoteLocation = new NetAddress("192.168.0.19", 3007);
	// myRemoteLocation = new NetAddress("127.0.0.1", 3007);
}

void draw() {
	background(0);

	for (int i=0, len=pnx.length; i<len; i++) {
		pnx[i].draw();
	}
	// sendOsc();
}

void sendOsc() {
	for (int i=0, len=pnx.length; i<len; i++) {
		OscMessage myMessage = new OscMessage("/Pano"+(i+1));
		myMessage.add(pnx[i].ledTar);
		oscP5.send(myMessage, myRemoteLocation);
	}
}

void keyPressed() {
	if (key=='1') {
		displayMode = 1;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='2') {
		displayMode = 2;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='3') {
		displayMode = 3;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='4') {
		displayMode = 4;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='5') {
		displayMode = 5;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='6') {
		displayMode = 6;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='7') {
		displayMode = 7;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='8') {
		displayMode = 8;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	else if (key=='9') {
		displayMode = 9;
		for (int i=0, len=pnx.length; i<len; i++) {
			pnx[i].initUpdate = true;
		}
	}
	/*else if(key=='10'){
	 		displayMode = 10;
	 		for (int i=0, len=pnx.length; i<len; i++){
	 			pnx[i] .initUpdate = true;
	 		}
	 	}*/
}