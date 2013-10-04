int displayMode = 0;
int nbModes = 20;
int base = 44; //rythme à augmenter ou ralentir

void updateGraphics(){
	// respiration background
	if(displayMode == 0){
		left.beginDraw();
		left.background(abs(sin(radians(frameCount)))*255);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// respiration ellipse
	else if(displayMode == 1){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.ellipse(pw/2.,ph/2.,sin(radians(frameCount))*ph,sin(radians(frameCount))*ph);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// respiration verticale
	else if(displayMode == 2){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(0,ph-abs(sin(radians(frameCount)))*ph,pw,ph);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// k2000 vertical
	else if(displayMode == 3){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(0,abs(sin(radians(frameCount)))*(ph-1),pw,2);
		left.rect(0,ph-abs(sin(radians(frameCount)))*(ph-1),pw,2);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// k2000 horizontal
	else if(displayMode == 4){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(abs(sin(radians(frameCount)))*(pw+1)-1,0,2,ph);
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255,150);
		right.rect(pw-(abs(sin(radians(frameCount)))*(pw+1)),0,2,ph);
		right.endDraw();
	}

	else if(displayMode == 5){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255,150);
		left.rect(abs(sin(radians(frameCount)))*(pw+1)-1,0,2,ph/2);
		left.rect(pw-(abs(sin(radians(frameCount)))*(pw+1)),ph/2,2,ph/2);
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255,150);
		right.rect(abs(sin(radians(frameCount)))*(pw+1)-1,ph/2,2,ph/2);
		right.rect(pw-(abs(sin(radians(frameCount)))*(pw+1)),0,2,ph/2);
		right.endDraw();
	}

	else if(displayMode == 6){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		float x = abs(sin(radians(frameCount)))*pw;
		left.rect(x,0,1,ph);
		left.rect(pw-x,0,1,ph);
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		x = abs(sin(radians(frameCount+90)))*(pw);
		right.rect(x,0,1,ph);
		right.rect(pw-x,0,1,ph);
		right.endDraw();
	}

	else if(displayMode == 7){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%2;
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) right.rect(i,0,1,ph);
		}
		right.endDraw();
	}

	else if(displayMode == 8){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%2;
		for (int i = 0; i<pw; i++){
			if(i%2 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
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
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		int alt = (frameCount/int(base))%3;
		for (int i = 0; i<pw; i++){
			if(i%3 == alt) left.rect(i,0,1,ph);
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
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
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		if(frameCount%base/2==0){
			for(int i=0;i<3;i++){
				left.rect(int(random(pw)),int(random(ph)),2,2);
			}
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		right.fill(255);
		if(frameCount%base/2==0){
			for(int i=0;i<3;i++) {
				right.rect(int(random(pw)),int(random(ph)),2,2);
			}
		}
		right.endDraw();
	}

	else if(displayMode == 11){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.stroke(255);
		left.rect(frameCount/5%pw,frameCount/5/int(pw)%ph,1,3);
		left.rect(frameCount/5%pw,(frameCount/5/int(pw)+ph/2)%ph,1,3);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 12){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		for (int i = 0; i<ph; i++){
			if(i%2==0) left.rect(abs(sin(radians(frameCount)))*pw,i,1,1);
			else left.rect(pw-(abs(sin(radians(frameCount)))*pw),i,1,1);
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 13){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.fill(255);
		for (int i = 0; i<pw; i++){
			left.rect(i,int(abs(cos(radians(i*30+frameCount)))*(NB_LEDSTRIPS-2)),1,2);
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 14){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.fill(255);
		for (int i = 0; i<pw; i++){
			left.rect(i,0,1,int(map(cos(radians(i*90+frameCount)),-1,1,0,1)*(NB_LEDSTRIPS-1)));
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 15){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.fill(255);
		for (int i = 0; i<pw; i++){
			left.rect(i,int(abs(cos(radians(i*30+frameCount)))*(NB_LEDSTRIPS-2)),1,2);
			left.rect(i,NB_LEDSTRIPS-2-int(abs(cos(radians(i*30+frameCount)))*(NB_LEDSTRIPS-2)),1,2);
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 16){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		left.rect(frameCount/10%pw,sin(radians(frameCount))*(ph-2),1,2);
		left.rect((frameCount/10+2)%pw,sin(radians(frameCount+120))*(ph-2),1,2);
		left.rect((frameCount/10+4)%pw,sin(radians(frameCount+60))*(ph-2),1,2);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 17){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.fill(255);
		for (int i = 0; i<pw; i++){
			if(i%2==0) left.rect(i,ph,1,-int(map(cos(radians(i*90+frameCount*2)),-1,1,0,1)*(NB_LEDSTRIPS-1)));
			else left.rect(i,0,1,int(map(cos(radians(i*90+frameCount*2)),-1,1,0,1)*(NB_LEDSTRIPS-1)));
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 18){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);

		left.stroke(255);
		left.rect(frameCount/5%pw,frameCount/5%ph,1,3);
		left.rect(frameCount/5%pw,(frameCount/5+ph/2)%ph,1,3);
		left.rect((pw-2-frameCount/5)%pw,frameCount/5%ph,1,3);
		left.rect((pw-2-frameCount/5)%pw,(frameCount/5+ph/2)%ph,1,3);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	else if(displayMode == 19){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.fill(255);
		if(frameCount%base==0){
			for (int i = 0; i<3; i++){
				left.rect(int(random(pw)),0,1,ph);		
			}
		}
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}



	else if(displayMode == 999){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		left.background(frameCount%255);
		left.endDraw();

		right.beginDraw();
		right.image(left,0,0);
		right.endDraw();
	}

	// noise 3d  (x,y,temps)
	else if(displayMode == 1000){
		left.beginDraw();
		left.fill(0,30);
		left.noStroke();
		left.rect(0,0,pw,ph);
		for (int i = 0; i<pw; i++){
			for (int j = 0; j<ph; j++){
				left.stroke(constrain((.75-noise(i/10.,j/10.,frameCount/float(base)))*500,0,255));
				left.point(i,j);
			}
		}
		left.endDraw();

		right.beginDraw();
		right.fill(0,30);
		right.noStroke();
		right.rect(0,0,pw,ph);
		for (int i = 0; i<pw; i++){
			for (int j = 0; j<ph; j++){
				right.stroke(constrain((.75-noise(i/10.,j/10.,(1000-frameCount)/float(base)))*500,0,255));
				right.point(i,j);
			}
		}
		right.endDraw();
	}
}