/*
		__	__  ____  ________   ______  _   __
	   / /   / / / /  |/  /  _/ | / / __ \/ | / /
	  / /   / / / / /|_/ // //  |/ / / / /  |/ / 
	 / /___/ /_/ / /  / // // /|  / /_/ / /|  /  
	/_____/\____/_/  /_/___/_/ |_/\____/_/ |_/   
	
	Touche [+]: displayMode suivant
	Touche [-]: displayMode précédent
	Touche [SPACE]: displayMode aléatoire
	Touche [a]: manual start
	Touche [z]: manual stop
	Touche [0]: reset frameCount
*/
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

boolean DEBUG = true;

final int NB_PNX_WALL = 5;
final int NB_LEDSTRIPS = 20;

// Spatialisation son
final int[] group1 = { 0, 1, NB_PNX_WALL, NB_PNX_WALL+1 };
final int[] group2 = { 1,2,3,6,7,8 };
final int[] group3 = { NB_PNX_WALL-1, NB_PNX_WALL-2, NB_PNX_WALL*2-2, NB_PNX_WALL*2-1 };
int moy1, moy2, moy3;
float easingMoySon = 0.1;

// Beat Detection
Minim minim;
AudioInput in;
BeatDetect beat;
int startTime = 0;
int track = 1;

final int MARGE = 20;
Panneau[] pnx;
float w, h, hLed;
PGraphics left, right;
int pw, ph;//PGraphics width / height

void setup() {
	size(300, 200);
	frame.setAlwaysOnTop(true);
	// size(screen.width+1, screen.height);
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

	// Beat Detection
	minim = new Minim(this);
	minim.debugOn();
	// get a line in from Minim, default bit depth is 16
	in = minim.getLineIn(Minim.STEREO, int(1024));
	// a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
	beat = new BeatDetect();
	beat.setSensitivity(2500);
	// beat.detectMode(BeatDetect.FREQ_ENERGY);
}

void draw() {
	beat.detect(in.mix);
	if ( beat.isOnset() ){
		frameCount = 0;
	}

	updateGraphics();
	for (int i=0, len=pnx.length; i<len; i++) {
		pnx[i].update();
	}

	if(DEBUG){
		background(0);
		if ( beat.isOnset() ){
			fill(255,0,0);
			rect(0,h,width,MARGE);
		}
		beat.drawGraph(this);
		
		for (int i=0, len=pnx.length; i<len; i++) {
			noStroke();
			pnx[i].draw();
		}

	}

	sendOsc();
	if(millis()-startTime > 100000){
		displayMode = int(random(nbModes));
		println("displayMode: "+displayMode);
		startTime = millis();
	}
}

void sendOsc() {
	for (int i=0, len=pnx.length; i<len; i++) {
		OscMessage myMessage = new OscMessage("/Pano"+(i+1));
		myMessage.add(pnx[i].led);
		oscP5.send(myMessage, myRemoteLocation);
		// println("myMessage: "+ myMessage);
	}

	int average1 = 0;
	for (int i = 0; i<group1.length; i++){
		for (int j = 0; j<NB_LEDSTRIPS; j++){
			average1 += pnx[group1[i]].led[j];
		}
	}
	average1 = int(average1/(group1.length*NB_LEDSTRIPS));
	moy1 = ease(moy1, average1, easingMoySon);
	// println("average1: "+average1);
	OscMessage mess1 = new OscMessage("/group1");
	mess1.add(average1);
	oscP5.send(mess1, myRemoteLocation);

	int average2 = 0;
	for (int i = 0; i<group2.length; i++){
		for (int j = 0; j<NB_LEDSTRIPS; j++){
			average2 += pnx[group2[i]].led[j];
		}
	}
	average2 = int(average2/(group2.length*NB_LEDSTRIPS));
	moy2 = ease(moy2, average2, easingMoySon);
	// println("average2: "+average2);
	OscMessage mess2 = new OscMessage("/group2");
	mess2.add(average2);
	oscP5.send(mess2, myRemoteLocation);

	int average3 = 0;
	for (int i = 0; i<group3.length; i++){
		for (int j = 0; j<NB_LEDSTRIPS; j++){
			average3 += pnx[group3[i]].led[j];
		}
	}
	average3 = int(average3/(group3.length*NB_LEDSTRIPS));
	moy3 = ease(moy3, average3, easingMoySon);
	// println("average3: "+average3);
	OscMessage mess3 = new OscMessage("/group3");
	mess3.add(average3);
	oscP5.send(mess3, myRemoteLocation);
}

void oscEvent(OscMessage messageEntrant) {
	println(messageEntrant.toString());
	if (messageEntrant.addrPattern().equals("/play") == true) {
		displayMode = 0;
		startTime = millis();
		fill(0,255,0);
		rect(0,h,width,MARGE);
		// if (messageEntrant.typetag().equals("i") == true) {
			// mouse_x = messageEntrant.get(0).intValue();
			// mouse_y = messageEntrant.get(1).intValue();
		// }
	}
	else if (messageEntrant.addrPattern().equals("/stop") == true) {
		displayMode = 1000;
		startTime = millis();
		fill(255,255,0);
		rect(0,h,width,MARGE);
		// if (messageEntrant.typetag().equals("i") == true) {
			// mouse_x = messageEntrant.get(0).intValue();
			// mouse_y = messageEntrant.get(1).intValue();
		// }
	}
}

void keyPressed() {
	if(key == '+'){
		displayMode++;
		startTime = millis();
		displayMode = constrain(displayMode, 0, nbModes);
	}
	else if(key == '-'){
		displayMode--;
		startTime = millis();
		displayMode = constrain(displayMode, 0, nbModes);
	}
	else if (key == ' ') {
		displayMode = int(random(nbModes));
		startTime = millis();
	}
	else if (key=='d' || key =='D') {
		DEBUG = !DEBUG;
	}
	else if (key=='0') {
		frameCount = base;
	}
	else if (key=='a' || key=='A'){//manual start
		displayMode = 0;
		startTime = millis();
		fill(0,255,0);
		rect(0,h,width,MARGE);
	}
	else if (key=='z' || key=='Z'){//manual stop
		displayMode = 1000;
		startTime = millis();
		fill(0,255,0);
		rect(0,h,width,MARGE);
	}
	/*else{
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
	}*/
	println("displayMode: "+displayMode);
}

void stop() {
	in.close();
	minim.stop();
	super.stop();
}


float ease(float variable,float target,float easingVal) {
	float d = target - variable;
	if(abs(d)>1) variable+= d*easingVal;
	return variable;
}