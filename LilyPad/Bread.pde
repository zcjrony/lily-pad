/********************************
 Bread class by tree for fluid sensing
 simple version 1

Examlpe code: 

Body body;
void setup(){
  size(400,400);
  Window window = new Window(300,300);
  body = new Bread(70,70,1,1.5,4,window);
}
void draw(){
  background(0);
  body.follow();
  body.display();
}
void mousePressed(){body.mousePressed();}
void mouseReleased(){body.mouseReleased();}

 ********************************/


class Bread extends Body {
  int m = 80;//elipse and straight lines have both 80 points. We can modify the num later.
  float ratio = 30;//make it bigger
  Bread( float x, float y, float _h, float _l1, float _l2, Window window) {
    super(x, y, window);
    float h= ratio * _h;
    float l1= ratio * _l1;
    float l2= ratio * _l2;
    for ( int i=0; i<m/2; i++ ) {//left ellipse
      float theta = -TWO_PI*i/((float)m);
      add(xc.x+l1*cos(theta-PI/2), xc.y+h*sin(theta-PI/2));
    }
    for ( int i=0; i<m/2; i++ ) {//down straight
      add(xc.x+l2*i/m, xc.y+h);
    }
    for ( int i=m/2; i<m; i++ ) {//right ellipse
      float theta = -TWO_PI*i/((float)m);
      add(xc.x+l2+l1*cos(theta-PI/2), xc.y+h*sin(theta-PI/2));
    }
    for ( int i=m/2; i<m; i++ ) {//up straight
      add(xc.x+l2*(1-float(i)/m), xc.y-h);
    }
    end(); // finalize shape
  }
}
