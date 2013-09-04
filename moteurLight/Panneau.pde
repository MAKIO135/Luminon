class Panneau{
	int id, posX, posY;
	int[] led;
	int[] ledTar;
	boolean initUpdate = true;

	Panneau(int _id) {
		id = _id;
		// console.log("id: "+id);

		posX = int((id%NB_PNX_WALL)*w);
		posY = int(id/NB_PNX_WALL) + int((id<NB_PNX_WALL)?0:(h+MARGE));
		// console.log(posX+" "+posY);

		led = new int[NB_LEDSTRIPS];
		ledTar = new int[NB_LEDSTRIPS];
		for (int i = 0; i<NB_LEDSTRIPS; i++){
			led[i] = 0;
			ledTar[i] = 255;
		}
	}

	void draw(){
		// fill((id%NB_PNX_WALL)*(255/NB_PNX_WALL));
		// rect(posX, posY, w, h);
		switch (displayMode){
			case 0: update0(); break;
			case 1: update1(); break;
			case 2: update2(); break;
			case 3: update3(); break;
			case 4: update4(); break;
			case 5: update5(); break;
			case 6: update6(); break;
			case 7: update7(); break;
			case 8: update8(); break;
			case 9: update9(); break;
		}

		for(int i=0; i<NB_LEDSTRIPS; i++){
			// led[i]=int(ease(led[i], ledTar[i], 0.08));
			fill(ledTar[i]);
			rect(posX, posY+i*hLed, w, hLed);
		}
	}

	float common;
	void update0(){
		if(initUpdate){
			for(int i=0; i<NB_LEDSTRIPS; i++){
				ledTar[i] = 0;
			}
			initUpdate = false;
		}
		common = abs(sin(frameCount/100.)*255);
		for(int i=0; i<NB_LEDSTRIPS; i++){
			ledTar[i] = int(common);
		}
	}

	void update1(){
		if(initUpdate){
			for(int i=0; i<NB_LEDSTRIPS; i++){
				ledTar[i] = 255/NB_LEDSTRIPS*(i+1);
			}
			initUpdate = false;
		}
		for(int i=0; i<NB_LEDSTRIPS; i++){
			ledTar[i] = max((((256/NB_LEDSTRIPS)*i)+frameCount)%306-50, 0);
		}
	}

	void update2(){
		if(initUpdate){
			for(int i=0; i<NB_LEDSTRIPS; i++){
				ledTar[i] = 255/NB_LEDSTRIPS*(i+1);
			}
			initUpdate = false;
		}
		for(int i=0; i<NB_LEDSTRIPS; i++){
			ledTar[i] = max((((256/NB_LEDSTRIPS)*i)+(1+id%NB_PNX_WALL)*frameCount)%306-50, 0);
			// ledTar[i] = (ledTar[i]+1)%256;
		}
	}

	void update3(){
		for(int i=0; i<NB_LEDSTRIPS; i++){
			ledTar[i] = int(constrain(noise((id+frameCount)/100.,i/10.)*768-256,0,255));
		}
	}

	void update4(){

	}

	void update5(){

	}

	void update6(){

	}

	void update7(){

	}

	void update8(){

	}

	void update9(){

	}
	
};

float ease(float variable,float target,float easingVal) {
	float d = target - variable;
	if(abs(d)>1) variable+= d*easingVal;
	return variable;
}
