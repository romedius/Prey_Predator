private static final long serialVersionUID = 1L;

	private static final float boxSize = 20;
	private static final float margin = boxSize * 2;
	private static final float depth = 400;
	private static final int nX = 150;
	private static final int nY = 100;
	private int now = 0;

	private Random r = new Random(System.currentTimeMillis());
	
	private static final int pb=90; // probaility that a bear "replicates" after a good meal
	private static final int pbd=5; // probability that a bear dies
	
	private static final int pf=100; // probaility that a fox "replicates" after a good meal
	private static final int pfd=2; // probability that a fox dies
	
	private static final int pp=100; // probaility that a bunny "replicates" after a good meal 

	/*
	 * Type is
	 * 
	 * 0: vacant 1: rabbit 2: fox 3: bear
	 */
	int[][][] population = new int[150][100][2]; // X Y [Type/direction]

	public void setup() {
		size(1400, 800, P3D);
		noStroke();
		for (int i = 0; i < nX; i++) {
			for (int j = 0; j < nY; j++) {
				population[i][j][0] = r.nextInt() % 4;
				population[i][j][1] = 0;
			}
		}
	}

	public void draw() {
		background(60);

		// Center and spin grid
		translate(width / 2, height / 2, -depth);
		rotateY((width / 2 - mouseX) * 0.001f);
		rotateX((height / 2 - mouseY) * 0.001f);
		// Build grid using multiple translations
		 r = new Random(System.currentTimeMillis());
		for (int i = 0; i < 2400; i++) {
			// Calculate the neighor and the field to test
			int pX = Math.abs(r.nextInt()) % nX;
			int pY = Math.abs(r.nextInt()) % nY;
			int nbX, nbY;
			// calculate future direction
			
			if (Math.abs(r.nextInt()) % 2 == 0) {
				nbY = pY;
				if (Math.abs(r.nextInt()) % 2 == 0) {
					nbX = (pX + 1 )%nX;
				} else {
					nbX = (pX - 1 + nX )%nX;
				}
			} else {
				nbX = pX;
				if (Math.abs(r.nextInt()) % 2 == 0) {
					nbY = (pY + 1 )%nY;
				} else {
					nbY = (pY - 1 + nY )%nY;
				} 
			}

			switch (population[pX][pY][0]) {
			case 3: {
				if (population[nbX][nbY][0] == 2){// bear eats fox
					population[nbX][nbY][0] = (((Math.abs(r.nextInt())%100)<pb)?3:0);
				}else{
					if(((Math.abs(r.nextInt())%100)<pbd)){ // bear dies
						population[pX][pY][0] = 0;
					}else{
						if (population[nbX][nbY][0] == 0){ // bear moves to vacant
							population[nbX][nbY][0] = 3;
							population[pX][pY][0] = 0;
						}						
					}
				}
				break;
			}
			case 2: {
				if (population[nbX][nbY][0] == 1){// fox eats rabbit
					population[nbX][nbY][0] = (((Math.abs(r.nextInt())%100)<pf)?2:0);
				}else{
					if(((Math.abs(r.nextInt())%100)<pfd)){ // fox dies
						population[pX][pY][0] = 0;
					}else{
						if (population[nbX][nbY][0] == 0){ // fox moves to vacant
							population[nbX][nbY][0] = 2;
							population[pX][pY][0] = 0;
						}						
					}
				}
				break;
			}
			case 1: { // bunny
				if (population[nbX][nbY][0] == 0){ // bunny moves to vacant
					population[nbX][nbY][0] = 1;
					population[pX][pY][0] = (((Math.abs(r.nextInt())%100)<pp)?1:0);
				}						
				break;
			}
			}
		}
		// Actuallize Array with the Simulation
		/*for T steps do
			2: for N sites do
			3: choose a random site i
			4: choose a random neighbour j
			5: if i = bear and j = fox then
			6: bear eats fox and fox becomes bear with
			probability b
			7: else if i = bear then
			8: bear dies with probability pb
			9: else if i = bear and j = vacancy then
			10: bear moves to vacancy

			11: else if i = fox and j = rabbit then
			12: fox eats rabbit and rabbit becomes fox with
			probability f
			13: else if i = fox then
			14: fox dies with probability pf
			15: else if i = fox and j = vacancy then
			16: fox moves to vacancy
			
			17: else if i = rabbit and j = vacancy then
			18: rabbit reproduces into vacancy with probability
			μ or rabbit moves into vacancy
			19: end if
			20: end for
			21: end for
		 */

		for (int j = 0; j < nX; j++) {
			pushMatrix();
			for (int k = 0; k < nY; k++) {
				// Base fill color on counter values, abs function
				// ensures values stay within legal range
				switch (population[j][k][0]) {
				case 1: {// bunny
					// boxFill = color(255, abs((j-nX/2))*255/nX*2,
					// abs((k-nY/2))*255/nY*2, 255);
					int boxFill = color(0, 255 - (now - population[j][k][1]),
							0, 255);
					pushMatrix();
					translate((j - nX / 2) * boxSize, (k - nY / 2) * boxSize, 0);
					fill(boxFill);
					box(boxSize, boxSize, 1);//population[j][k][1]);
					popMatrix();
					break;
				}
				case 2: {
					int boxFill = color(255 - (now - population[j][k][1]), 0,
							0, 255);
					pushMatrix();
					translate((j - nX / 2) * boxSize, (k - nY / 2) * boxSize, 0);
					fill(boxFill);
					box(boxSize, boxSize, 1);// population[j][k][1]);
					popMatrix();
					break;
				}
				case 3: {
					int boxFill = color(0, 0,
							255 - (now - population[j][k][1]), 255);
					pushMatrix();
					translate((j - nX / 2) * boxSize, (k - nY / 2) * boxSize, 0);
					fill(boxFill);
					box(boxSize, boxSize, 1);//population[j][k][1]);
					popMatrix();
					break;
				}
				}
			}
			popMatrix();
		}
	}

