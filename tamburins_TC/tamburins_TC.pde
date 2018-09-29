/*------ Headers to Include ------*/
import processing.video.*;
import SimpleOpenNI.*;


/*------ Value Define ------*/

/*------ Objects ------*/
Movie routine_movie;
Movie opening_movie;
SimpleOpenNI kinect;
PImage result;

/*------ Functions ------*/

/*------ Global Variables ------*/
int seq = 2;

int time_ms;
int time_stamp;
int time_stamp_2;
int [] userMap;

void setup() {
  size(1440, 800, P3D);
  //size(640, 540, P2D);
  //fullScreen(P2D);
  
  smooth(4);

  routine_movie = new Movie(this, "routine.mp4");
  opening_movie = new Movie(this, "opening.mp4");

  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth(); // enable depthMap generation 
  kinect.enableRGB();  // enable RGB camera
  kinect.enableUser(); // enable skeleton generation for all joints
  kinect.alternativeViewPointDepthToImage(); // turn on depth-color alignment 

  result = createImage(width, height, RGB);
  phase1_setup ();
  text_setup();
  time_stamp = millis();
  time_stamp_2 = millis();
  lastTime = millis();
}

void draw() {
  background(0, 60);

  if (seq == -1) {
    routine_movie.loop();
    image(routine_movie, 0, 0, width, height);
  } else if (seq == 0) { // 사람이 오면으로 변경
    routine_movie.stop();
    opening_movie.play();
    image(opening_movie, 0, 0, width, height);
    float md = opening_movie.duration();
    float mt = opening_movie.time();
    if (mt == md) {
      time_stamp = millis();
      seq = 1;
    }
  } else if (seq == 1) {
    phase1_kinect_update();
    if (closestValue > close_d && closestValue < far_d) {
      phase1_DP_update(closestX, closestY);
    }
    phase1_DP();
  } else if (seq == 2) {
    text_2();
   
  } else if (seq == 3) {
    phase2_kinect_update();
  }
}