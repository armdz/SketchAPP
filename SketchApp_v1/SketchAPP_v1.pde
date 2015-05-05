//  sketch app v1 
//  made in a moment of 2013 for my friends in chascomús //
//  do anything with this app
//  by Lolo, http://armdz.com

import controlP5.*;
import codeanticode.syphon.*;


ControlP5 cp5;


int  con = 0;
int  arx, ax, ay, ary;
int  step = 10;
int  tempStep = 10;
int  alf = 200;
int  minAlf = 200;
int  maxAlf = 255;


int    PRIMER_PRESS = 1;
int    AREA_SIZE = 50;
float  lineWeight = .5;

PImage  area;
PGraphics  rubberCanvas;
PGraphics  canvas;
PGraphics  fondo;
PGraphics  controlCanvas;

int  POS_UI_H;
int  ALTO_UI = 60;
int  UI_O_X = 10;
int  UI_O_Y = 10;

int    RED, GREEN, BLUE, ALPHA = 0;
int    MIN_STEP = 1;
int    MAX_STEP = (int) AREA_SIZE/2;
float  LINE_WEIGHT = .5;
int    LINE_COUNT = MIN_STEP;

int  OFFSET_M_Y = 30;
float  oMouseY;
float  pMouseY;

boolean  condicionMenu = true;
boolean  rubber = false;

Accordion settingsMenu;
Group     groupSettings;
RadioButton  r, rS;

boolean  invertir = false;
int  IN_FLAG = 0;
int  RUBBER_SIZE = 30;

Slider  sliderR, sliderG, sliderB, sliderA;

//  SYPHON

SyphonServer server;
PGraphics syphonCanvas;
boolean  syphonOn = false;

void  setup() {


  size(800, 630, P3D);
  POS_UI_H = height - ALTO_UI;

  //  IDE

  LINE_COUNT = 10;
  AREA_SIZE=50;

  cp5 = new ControlP5(this);

  r = cp5.addRadioButton("radioButton")
    .setPosition(250, 10)
      .setSize(40, 10)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setItemsPerRow(5)
                .setSpacingColumn(50)
                  .addItem("INVERT_BACKGROUND", 1)
                    ;

  rS = cp5.addRadioButton("radioButton2")
    .setPosition(400, 10)
      .setSize(40, 10)
        .setColorForeground(color(120))
          .setColorActive(color(255))
            .setColorLabel(color(255))
              .setSpacingColumn(50)
                .addItem("SYPHON", 1)
                  ;

  cp5.addButton("CLEAR")
    .setValue(0)
      .setPosition(width-65, 10)
        .setSize(50, 10)
          ;

  groupSettings = cp5.addGroup("SETTINGS")
    .setBackgroundColor(color(100, 100))
      .setBackgroundHeight(115)

        ;

  cp5.addButton("WHITE")
    .setValue(0)
      .setPosition(10+UI_O_X+100, 110+4)
        .setSize(50, 10)

          .moveTo(groupSettings)
            ;

  cp5.addButton("BLACK")
    .setValue(0)
      .setPosition(10+UI_O_X+100, 110+17)
        .setSize(50, 10)
          .moveTo(groupSettings)
            ;

  cp5.addSlider("LINE_WEIGHT")
    .setPosition(UI_O_X, UI_O_Y)
      .moveTo(groupSettings)
        .setRange(.1, 2)

          .setDefaultValue(LINE_WEIGHT);

  cp5.addSlider("LINE_COUNT")
    .setPosition(UI_O_X, UI_O_Y*2.2)
      .moveTo(groupSettings)
        .setRange(MIN_STEP, MAX_STEP)
          .setDefaultValue(LINE_COUNT);

  AREA_SIZE = 50;     
  cp5.addSlider("AREA_SIZE")
    .setPosition(UI_O_X, UI_O_Y*3.4)
      .moveTo(groupSettings)
        .setRange(10, 100)
          .setDefaultValue(50);

  RED=0;

  sliderR = cp5.addSlider("RED")
    .setPosition(UI_O_X, UI_O_Y*5)
      .moveTo(groupSettings)
        .setColorBackground(color(0, 0, 0, 255))
          .setColorActive(color(255, 0, 0, 255)) 
            .setColorForeground(color(255, 0, 0, 255)) 
              .setRange(0, 255)
                .setDefaultValue(0);

  GREEN = 0;
  sliderG= cp5.addSlider("GREEN")
    .setPosition(UI_O_X, UI_O_Y*6.5)
      .moveTo(groupSettings)
        .setColorBackground(color(0, 0, 0, 255))
          .setColorActive(color(0, 255, 0, 255)) 
            .setColorForeground(color(0, 255, 0, 255)) 
              .setRange(0, 255)
                .setDefaultValue(0);

  BLUE=0;
  sliderB=cp5.addSlider("BLUE")
    .setPosition(UI_O_X, UI_O_Y*8)
      .moveTo(groupSettings)
        .setColorBackground(color(0, 0, 0, 255))
          .setColorActive(color(0, 0, 255, 255)) 
            .setColorForeground(color(0, 0, 255, 255)) 
              .setRange(0, 255)
                .setDefaultValue(0);
  ALPHA = 255;

  sliderA=cp5.addSlider("ALPHA")
    .setPosition(UI_O_X, UI_O_Y*9.5)
      .moveTo(groupSettings)
        .setColorBackground(color(0, 0, 0, 255))
          .setColorActive(color(100, 255)) 
            .setColorForeground(color(100, 255)) 
              .setRange(0, 255)
                .setDefaultValue(255);



  settingsMenu = cp5.addAccordion("acc")
    .setPosition(10, 10)
      .setWidth(200)
        .addItem(groupSettings)
          .setHeight(20)
            .setLabel("SETTINGS");
  ;



  settingsMenu.setBarHeight(300);
  canvas = createGraphics(width, height-OFFSET_M_Y);
  canvas.smooth(2);
  canvas.beginDraw();
  /* canvas.fill(255);
   canvas.noStroke();
   canvas.rect(0, 0, width, height);*/
  canvas.endDraw();

  fondo = createGraphics(width, height-OFFSET_M_Y);
  fondo.smooth(2);
  drawBackground(color(255));


  rubberCanvas = createGraphics(RUBBER_SIZE, RUBBER_SIZE);
  rubberCanvas.beginDraw();
  rubberCanvas.background(0);
  rubberCanvas.ellipse(RUBBER_SIZE/2, RUBBER_SIZE/2, RUBBER_SIZE, RUBBER_SIZE);
  rubberCanvas.endDraw();

  syphonCanvas = createGraphics(width, height-OFFSET_M_Y,P3D);

  background(255);

  server = new SyphonServer(this, "SkethcAPP");

  smooth(2);
}



void  draw() {


  background(200);

  oMouseY = mouseY-OFFSET_M_Y;
  pMouseY = pmouseY-OFFSET_M_Y;

  condicionMenu = true;
  canvas.strokeWeight(LINE_WEIGHT);
  if (tempStep != LINE_COUNT) {
    tempStep = LINE_COUNT;
    step = (int) map(LINE_COUNT, MIN_STEP, MAX_STEP, MAX_STEP, MIN_STEP);
  }

  arx=mouseX-AREA_SIZE/2;
  ary=(int) oMouseY-AREA_SIZE/2;

  if (mouseX > width) {
    arx = width-1;
  }
  if (mouseX < 0) {
    arx=0;
  }
  if (oMouseY < 0) {
    ary=0;
  }
  if (oMouseY > height) {
    ary = height-1;
  }
  canvas.beginDraw();

  if (groupSettings.isOpen() && mouseX > 10 && mouseX < (210)) {
    if (oMouseY > 10 && oMouseY < (175-OFFSET_M_Y)) {
      condicionMenu=false;
    }
  }

  if (mousePressed && condicionMenu && !rubber) {
    //  DRAW


    canvas.stroke(RED, GREEN, BLUE, ALPHA);
    canvas.line(pmouseX, pMouseY, mouseX, oMouseY);
    canvas.loadPixels();

    for (int yy=ary;yy<ary+AREA_SIZE;yy+=step) {
      for (int xx=arx;xx<arx+AREA_SIZE;xx+=step) {
        if (yy > 0 && xx > 0 && yy < canvas.height && xx < width) {
          color c = canvas.pixels[xx+yy*canvas.width];
          if (alpha(c) > 0) {
            //con=true;
            float dis=dist(mouseX, oMouseY, xx, yy);
            float valf=map(dis, 0, AREA_SIZE/2, maxAlf, minAlf);
            canvas.stroke(RED, GREEN, BLUE, ALPHA);
            canvas.line(mouseX, oMouseY, xx, yy);
          }
        }
      }
    }
  }

  canvas.endDraw();

  if (rubber) {

    if (mousePressed) {
      canvas.loadPixels();
      rubberCanvas.loadPixels();
      int  rx=mouseX-RUBBER_SIZE/2;
      int  ry=(int) oMouseY-RUBBER_SIZE/2;
      int  iy = 0;
      if (rx > 0 && rx < width && ry > 0 && mouseY < canvas.height) {
        for (int yy=ry;yy<ry+RUBBER_SIZE;yy++) {
          int  ix=0;
          for (int xx=rx;xx<rx+RUBBER_SIZE;xx++) {
            color  rc = rubberCanvas.pixels[ix+iy*rubberCanvas.width];
            if (brightness(rc) > 200) {
              canvas.pixels[xx+yy*canvas.width] = color(0, 0, 0, 0);
            }
            ix++;
          }
          iy++;
        }
        canvas.updatePixels();
      }
    }
  }






  // image(syphonCanvas, 0, OFFSET_M_Y);
  // server.sendImage(syphonCanvas);

  if (syphonOn) {
    syphonCanvas.beginDraw();
    pushMatrix();       
    syphonCanvas.image(fondo, 0, 0);
    syphonCanvas.image(canvas, 0, 0);
    popMatrix();
    syphonCanvas.endDraw();
    image(syphonCanvas, 0, OFFSET_M_Y);
    fill(0);
    text("Server Name: SketchAPP", 500, 15);
  }
  else {
    image(fondo, 0, OFFSET_M_Y);
    image(canvas, 0, OFFSET_M_Y);
  }

  //  UI



  if ( groupSettings.isOpen()) {
    noStroke();
    fill(100, 100);
    rect(10, 110+24, settingsMenu.getWidth(), 40);
    stroke(0);
    strokeWeight(.5);
    fill(RED, GREEN, BLUE, ALPHA);
    rect(10+UI_O_X, 110+24, 99, 30);
  }
  if (rubber) {
    stroke(100);
    fill(255, 100);
    ellipseMode(CENTER);
    ellipse(mouseX, mouseY, RUBBER_SIZE, RUBBER_SIZE);
  }



  server.sendImage(syphonCanvas);
}

void  drawBackground(color c) {
  fondo.beginDraw();
  fondo.fill(c);
  fondo.noStroke();
  fondo.rect(0, 0, width, fondo.height);
  fondo.endDraw();
}


public void CLEAR(int val) {
  if (canvas != null) {
    canvas.loadPixels();
    for (int yy=0;yy<canvas.height;yy++) {
      for (int xx=0;xx<canvas.width;xx++) {
        canvas.pixels[xx+yy*canvas.width] = color(255, 255, 255, 0);
      }
    }
    canvas.updatePixels();
  }
}

void radioButton(int a) {
  IN_FLAG=1;
  if (a==1) {
    drawBackground(color(0));
  }
  else {
    drawBackground(color(255));
  }
}

void radioButton2(int a) {

  if (a==1) {
    syphonOn=true;
  }
  else {
    syphonOn=false;
  }
}

void  WHITE(int val) {
  if (sliderR != null) {
    RED=255;
    GREEN = 255;
    BLUE = 255;
    ALPHA = 255;
    sliderR.setValue(255);
    sliderG.setValue(255);
    sliderB.setValue(255);
    sliderA.setValue(255);
  }
}

void  BLACK(int val) {
  if (sliderR != null) {
    RED=0;
    GREEN = 0;
    BLUE = 0;
    ALPHA = 255;
    sliderR.setValue(0);
    sliderG.setValue(0);
    sliderB.setValue(0);
    sliderA.setValue(255);
  }
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    rubber=true;
  }
}

void  keyReleased() {
  if (key == 'e' || key == 'E') {
    rubber=false;
  }
}


//  OLD

/*
    for (int yy=0;yy<area.height;yy+=step) {
 for (int xx=0;xx<area.width;xx+=step) {
 color c = area.pixels[xx+yy*area.width];
 //  println(red(c) + " " + green(c) + " " + blue(c));
 boolean  con = false;
 if (invertir) {
 if (red(c) == 0 && green(c) == 0 && blue(c) == 0) {
 con=true;
 }
 }
 else {
 if (red(c) != 254 && green(c) != 254 && blue(c) != 254) {
 con=true;
 }
 }
 
 
 
 
 
 if (con) {
 float dis=dist(mouseX, oMouseY, (mouseX-area.width/2)+xx, (oMouseY-area.height/2)+yy);
 float valf=map(dis, 0, area.width/2, maxAlf, minAlf);
 canvas.stroke(RED, GREEN, BLUE, ALPHA);
 canvas.line(mouseX, oMouseY, (mouseX-area.width/2)+xx, (oMouseY-area.height/2)+yy);
 }
 }
 }
 // canvas.loadPixels();
/*
 color col =canvas.pixels[(int) mouseX+(int) mouseY*canvas.width];
 println(red(col) + " " + green(col) + " " + blue(col));
 */
