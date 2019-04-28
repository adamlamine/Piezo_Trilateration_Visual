float[] cornerX =  {0, 1000, 0, 1000};
float[] cornerY =  {0, 0, 1000, 1000};

float w = 1000;
float h = 1000;

float currentTime = 0;
float measurementStart = currentTime;
float soundSpeed = 3;
float impactTime = 0;
boolean measurementStarted = false;

ArrayList<SoundCircle> circleList = new ArrayList<SoundCircle>();
ArrayList<Piezo> piezoList = new ArrayList<Piezo>();


void setup() {
  size(1000, 1000);
  background(255);
  ellipseMode(RADIUS);

  piezoList.add(new Piezo(0, 0));
  piezoList.add(new Piezo(1000, 0));
  piezoList.add(new Piezo(0, 1000));
  piezoList.add(new Piezo(1000, 1000));
}

void draw() {
  currentTime++;
  strokeWeight(1);
  background(255);

  for (int i = 0; i < 1000; i+=10) {
    for (int j = 0; j < 1000; j+=10) {
      fill(255);
      stroke(225);
      rect(i, j, 10, 10);
    }
  }

  for (int i = 0; i < circleList.size(); i++) {
    circleList.get(i).drawSoundCircle();
  }

  showMeasurement();

  for (int i = 0; i < piezoList.size(); i++) {
    piezoList.get(i).drawPiezo();
    for (int j = 0; j < circleList.size(); j++) {
      if (!piezoList.get(i).collided) {
        piezoList.get(i).collides(circleList.get(j));
      }
    }
  }

  text("d0 = " + piezoList.get(0).deltaZeroTime*soundSpeed, 10, 100);
  text("d0 = " + piezoList.get(1).deltaZeroTime*soundSpeed, 810, 100);
  text("d0 = " + piezoList.get(2).deltaZeroTime*soundSpeed, 10, 900);
  text("d0 = " + piezoList.get(3).deltaZeroTime*soundSpeed, 810, 900);

  text("Δt = " + piezoList.get(0).deltaTime, 10, 130);
  text("Δt = " + piezoList.get(1).deltaTime, 810, 130);
  text("Δt = " + piezoList.get(2).deltaTime, 10, 930);
  text("Δt = " + piezoList.get(3).deltaTime, 810, 930);

  text("Δd1 = " + floor(piezoList.get(0).deltaTime*soundSpeed), 10, 160);
  text("Δd2 = " + floor(piezoList.get(1).deltaTime*soundSpeed), 810, 160);
  text("Δd3 = " + floor(piezoList.get(2).deltaTime*soundSpeed), 10, 960);
  text("Δd4 = " + floor(piezoList.get(3).deltaTime*soundSpeed), 810, 960);
}


void mouseClicked() {
  circleList.clear();
  circleList.add(new SoundCircle(mouseX, mouseY));

  for (int i = 0; i < piezoList.size(); i++) {
    piezoList.get(i).reset();
  }

  measurementStarted = false;
  impactTime = currentTime;
  loop();
}

void showMeasurement() {
  float d1 = piezoList.get(0).deltaTime*soundSpeed;
  float d2 = piezoList.get(1).deltaTime*soundSpeed;
  float d3 = piezoList.get(2).deltaTime*soundSpeed;
  float d4 = piezoList.get(3).deltaTime*soundSpeed;

  float d01 = piezoList.get(0).deltaZeroTime*soundSpeed;
  float d02 = piezoList.get(1).deltaZeroTime*soundSpeed;
  float d03 = piezoList.get(2).deltaZeroTime*soundSpeed;
  float d04 = piezoList.get(3).deltaZeroTime*soundSpeed;

  //HYPERBEL MIT FOCII d1 und d2
  float centerX1 = 500;
  float centerY1 = 0;
  float k1 =  (d1-d2);
  float a1 = k1/2;
  float c1 = w/2;
  //println("1. Hyperbel: " + "((x-500)^2" + "/" + pow(a1, 2) + ")" + "-" + "(y^2)" + "/" + (pow(c1, 2) - pow(a1, 2)) + " = 1");
  

  

  //HYPERBEL MIT FOCII d1 und d3
  float centerX2 = 0;
  float centerY2 = 500;
  float k2 =  (d1-d3);
  float a2 = k2/2;
  float c2 = w/2;
  //println("2. Hyperbel: " + "((y+500)^2" + "/" + pow(a2, 2) + ")" + "-" + "(x^2)" + "/" + (pow(c2, 2) - pow(a2, 2)) + " = 1");
  

  Pofloat floatersection = new Pofloat();

  Pofloat sectorStart = new Pofloat();
  float sectorWidth = w/2;
  float sectorHeight = h/2;


  //SEKTOR BESTIMMUNG
  if (d1 <= 5 && d2 <= 5 && d3 <= 5 && d4 <= 5) {
    sectorStart.x = 480;
    sectorStart.y = 480;
    sectorWidth = 40;
    sectorHeight = 40;
  } else {
    if (d1 == 0) {
      sectorStart.x = 0;
      sectorStart.y = 0;
    } else if (d2 == 0) {
      sectorStart.x = 500;
      sectorStart.y = 0;
    } else if (d3 == 0) {
      sectorStart.x = 0;
      sectorStart.y = 500;
    } else if (d4 == 0) {
      sectorStart.x = 500;
      sectorStart.y = 500;
    }
  }



  strokeWeight(1);
  stroke(1);
  fill(200, 200, 255, 40);
  rect(sectorStart.x, sectorStart.y, sectorWidth, sectorHeight);

  boolean measurementComplete = true;
  noLoop();
  for (int i = 0; i < piezoList.size(); i++) {
    if (!piezoList.get(i).collided) {
      loop();
      measurementComplete = false;
    }
  }
  
  if (measurementComplete) {
    //outer: for (float y = sectorStart.y; y < sectorStart.y+sectorHeight; y+=1) {
    //  for (float x = sectorStart.x; x < sectorStart.x+sectorWidth; x+=1) {
    outer: for (float y = 0; y < h; y+=1) {
      for (float x = 0; x < w; x+=1) {
        strokeWeight(0);
        
        
        float Px = x;
        float Py = 0-y;
        float equationResult1 = (pow((Px - 500),2)/pow(a1, 2)) - pow(Py,2)/(pow(c1, 2) - pow(a1, 2));
        float equationResult2 = (pow( (Py + 500) ,2) /pow(a2, 2)) - pow(Px,2)/(pow(c2, 2) - pow(a2, 2));
        
        if(abs(equationResult1-1) < 0.1 || abs(equationResult2-1) < 0.1){
          fill(255, 200, 200, 100);
          rect(x, y, 1, 1);
          if(abs(equationResult1-1) < 0.1 && abs(equationResult2-1) < 0.1){
            //fill(255,0,0,255);
            //circle(Px, -Py, 10);
            //break outer;
          }
        } else {
          fill(200, 255, 200, 100);
        }
        
        
        
        
        
      }
    }
  }
}
