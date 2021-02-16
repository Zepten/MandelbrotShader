PShader s;

float zoom = 1, zoomTo = zoom, zoomFactor = 1.5;
float posx = 0, posy = 0;
boolean drag = false;

void mouseWheel(MouseEvent event) {
  int e = event.getCount();
  if (e < 0) zoomTo *= zoomFactor;
  else if (e > 0) zoomTo /= zoomFactor;
}

void mousePressed(){
  drag = true;
}

void mouseReleased(){
  drag = false;
}

void setup(){
  size(800, 600, P2D);
  s = loadShader("shader.glsl");
}

void draw(){
  if (drag){
    posx -= (mouseX - pmouseX) / zoom;
    posy -= (mouseY - pmouseY) / zoom;
  }
  
  s.set("u_res", (float)width, (float)height);
  s.set("u_translate", (float)posx, (float)posy);
  s.set("u_zoom", zoom);
  
  shader(s);
  rect(0, 0, width, height);
  
  zoom += (zoomTo-zoom)*0.15;
  println("FPS: "+(int)frameRate);
}
