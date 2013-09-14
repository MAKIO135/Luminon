import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 

import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class moteurLight extends PApplet {




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

public void setup() {
	size(600, 400);
	frameRate(20);
	noStroke();

	w = PApplet.parseInt(width/NB_PNX_WALL);
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

public void draw() {
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

public void sendOsc() {
	for (int i=0, len=pnx.length; i<len; i++) {
		OscMessage myMessage = new OscMessage("/Pano"+(i+1));
		myMessage.add(pnx[i].ledTar);
		oscP5.send(myMessage, myRemoteLocation);
		// println("myMessage: "+ myMessage);
	}
}

public void keyPressed() {
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
class Panneau{
	int id, posX, posY;
	int[] led;
	int[] ledTar;
	boolean initUpdate = true;

	Panneau(int _id) {
		id = _id;
		// console.log("id: "+id);

		posX = PApplet.parseInt((id%NB_PNX_WALL)*w);
		posY = PApplet.parseInt(id/NB_PNX_WALL) + PApplet.parseInt((id<NB_PNX_WALL)?0:(h+MARGE));
		// console.log(posX+" "+posY);

		led = new int[NB_LEDSTRIPS];
		ledTar = new int[NB_LEDSTRIPS];
		for (int i = 0; i<NB_LEDSTRIPS; i++){
			led[i] = 0;
			ledTar[i] = 255;
		}
	}

	public void draw(){
		for(int i=0; i<NB_LEDSTRIPS; i++){
			led[i] = id<NB_PNX_WALL? left.get(id%NB_PNX_WALL,i) : right.get(id%NB_PNX_WALL,i);
			fill(led[i]);
			rect(posX, posY+i*hLed, w, hLed);
		}
	}
};
float base = 30.f;
public void updateGraphics(){
	// respiration background
	if(displayMode == 0){
		left.beginDraw();
		left.background(abs(cos(frameCount/base))*255);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// respiration ellipse
	/*
	left.noStroke();
	else if(displayMode == 1){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.ellipse(pw/2,ph/2,sin(frameCount/base)*ph,sin(frameCount/base)*ph);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// respiration verticale
	left.noStroke();
	else if(displayMode == 2){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(0,ph-abs(sin(frameCount/base))*ph,pw,ph);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// k2000 vertical
	left.noStroke();
	else if(displayMode == 3){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(0,abs(sin(frameCount/base))*ph-1,pw,2);
		left.rect(0,ph-abs(sin(frameCount/base))*ph-1,pw,2);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// k2000 horizontal
	left.noStroke();
	else if(displayMode == 4){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(abs(sin(frameCount/base))*(pw+1)-1,0,2,ph);
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255,150);
		right.rect(pw-(abs(sin(frameCount/base))*(pw+1)),0,2,ph);
		right.endDraw();
	}

	// noise 3d  (x,y,temps)
	else if(displayMode == 5){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		for (int i = 0; i<pw; i++){
			for (int j = 0; j<ph; j++){
				left.stroke(constrain((.75-noise(i/10.,j/10.,frameCount/base))*500,0,255));
				left.point(i,j);
			}
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		for (int i = 0; i<pw; i++){
			for (int j = 0; j<ph; j++){
				right.stroke(constrain((.75-noise(i/10.,j/10.,(1000-frameCount)/base))*500,0,255));
				right.point(i,j);
			}
		}
		right.endDraw();
	}

	else if(displayMode == 6){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		float x = abs(sin(frameCount/base))*(pw);
		left.rect(x,0,1,ph);
		left.rect(pw-x,0,1,ph);
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		x = abs(sin((frameCount+90)/base))*(pw);
		right.rect(x,0,1,ph);
		right.rect(pw-x,0,1,ph);
		right.endDraw();
	}

	else if(displayMode == 7){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%2;
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.noStroke();
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) right.rect(i,0,1,ph);
		}
		right.endDraw();
	}

	else if(displayMode == 8){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%2;
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		for (int i = 0; i<pw; i++){
			if(i%2 != alt) right.rect(i,0,1,ph);
		}
		right.endDraw();
	}

	else if(displayMode == 9){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%3;
		for (int i = 0; i<pw; i++){
			if(i%3 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		for (int i = 0; i<pw; i++){
			if(i%3 == alt) right.rect(i,0,1,ph);
		}
		right.endDraw();
	}

	else if(displayMode == 10){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		if(frameCount%10==0){
			for(int i=0;i<3;i++){
				left.rect(int(random(pw)),int(random(ph)),2,2);
			}
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,10);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		if(frameCount%10==0){
			for(int i=0;i<3;i++) {
				right.rect(int(random(pw)),int(random(ph)),2,2);
			}
		}
		right.endDraw();
	}
	*/

	else if(displayMode == 11){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.stroke(255);
		left.point(frameCount%pw,frameCount/PApplet.parseInt(pw)%ph);
		left.point(frameCount%pw,(frameCount/PApplet.parseInt(pw)+ph/2)%ph);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 12){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 13){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 14){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 15){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 16){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 17){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 18){
		left.beginDraw();
		left.fill(0,10);
		left.noStroke();
		left.rect(0,0,pw,ph);
		
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}
}
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "moteurLight" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
