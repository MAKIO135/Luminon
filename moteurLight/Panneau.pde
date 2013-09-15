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
		for(int i=0; i<NB_LEDSTRIPS; i++){
			led[i] = id<NB_PNX_WALL? left.get(id%NB_PNX_WALL,i) : right.get(id%NB_PNX_WALL,i);
			led[i] = int(brightness(led[i]));
			fill(led[i]);
			rect(posX, posY+i*hLed, w, hLed);
		}
	}
};