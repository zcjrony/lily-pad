/*********************************************************
                  Main Window!

Click the "Run" button to Run the simulation.

Change the geometry, flow conditions, numerical parameters
visualizations and measurements from this window.

This screen has an example. Other examples are found at 
the top of each tab. Copy/paste them here to run, but you 
can only have one setup & run at a time.

*********************************************************/
// Circle that can be dragged by the mouse
BDIM flow;
//Body body;
NACA body;

FloodPlot flood;
float Re = 10;
int resolution = (int)pow(2,5);
float omega = 0.005;
//double time = 0;
double angle = 0;
int flag = 1;
//float nu = resolution / Re;

void setup(){
  size(700,700);                             // display window size
  int n= resolution * 4;                       // number of grid points
  float L = n/8.;                            // length-scale in grid units
  Window view = new Window(n,n);

  //body = new CircleBody(n/3,n/2,L,view);     // define geom
  body = new NACA(L, 4 * L, L, 0.20, view);
  flow = new BDIM(n,n,1.5,body);             // solve for flow using BDIM
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);       //    and its legend
}
void draw(){
  //body.follow();                             // update the body
  if(angle > PI / 4){
    flag = -1;
  }else if(angle < -PI / 4){
    flag = 1;
  }
  angle += flag * flow.dt * omega;
  body.rotate(flag * flow.dt * omega);
  flow.update(body); flow.update2();         // 2-step fluid update
  flood.display(flow.u.curl());              // compute and display vorticity
  body.display();                            // display the body
}
void mousePressed(){body.mousePressed();}    // user mouse...
void mouseReleased(){body.mouseReleased();}  // interaction methods
void mouseWheel(MouseEvent event){body.mouseWheel(event);}