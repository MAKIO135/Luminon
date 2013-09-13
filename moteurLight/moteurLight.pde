import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

final int NB_PNX_WALL = 6;
final int NB_LEDSTRIPS = 27;
final int MARGE = 50;

Panneau[] pnx;

int nbModes = 20;
int displayMode = 11;
float w, h, hLed;
PGraphics left, right;
int pw, ph;//PGraphics width / height

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

	left = createGraphics(NB_PNX_WALL, NB_LEDSTRIPS, P2D);
	right = createGraphics(NB_PNX_WALL, NB_LEDSTRIPS, P2D);
	pw = NB_PNX_WALL;
	ph = NB_LEDSTRIPS;

	// OSC Communication
	oscP5 = new OscP5(this, 3008);
	myRemoteLocation = new NetAddress("127.0.0.1", 3007);
}

void draw() {
	background(0);
	updateGraphics();
	// image(left,0,0,width,height/2);
	// image(right,0,height/2,width,height/2);

	for (int i=0, len=pnx.length; i<len; i++) {
		pnx[i].draw();
	}

	sendOsc();
	// if(frameCount%500 == 0) displayMode = int(random(nbModes));
}

void sendOsc() {
	for (int i=0, len=pnx.length; i<len; i++) {
		OscMessage myMessage = new OscMessage("/Pano"+(i+1));
		myMessage.add(pnx[i].ledTar);
		oscP5.send(myMessage, myRemoteLocation);
		println("myMessage: "+ myMessage);
	}
}

void keyPressed() {
	if(key == '+'){
		displayMode++;
		displayMode = constrain(displayMode, 0, nbModes);
	}
	else if(key == '-'){
		displayMode--;
		displayMode = constrain(displayMode, 0, nbModes);
	}
	else{
		try {
			String s = "";
			s+=key;
			// println("key: "+Integer.parseInt(s));
			displayMode = Integer.parseInt(s);
			for (int i=0, len=pnx.length; i<len; i++) {
				pnx[i].initUpdate = true;
			}
		}
		catch (Exception e) {
			// println("e: "+e);
			// println("key: "+int(key));
		}
	}
	println("displayMode: "+displayMode);
}