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
//NACA body;
Rectangle body;

FloodPlot flood;
float Re = 10;
int resolution = (int)pow(2,5);
float omega = 0.05;
float angle = 0;
float amplitude = PI / 4;
float theta;
float centerX;
float centerY;
float rTrace;
float dtheta;
float L;

void setup(){
  size(700,700);                             // display window size
  int n= resolution * 4;                       // number of grid points
  L = n/8.;                            // length-scale in grid units
  Window view = new Window(n,n);

  //body = new CircleBody(n/3,n/2,L,view);     // define geom
  //body = new NACA(L, 4 * L, L, 0.20, view);
  body = new Rectangle(L, 2 * L, L, L / 8, view);
  flow = new BDIM(n,n,1.5,body);             // solve for flow using BDIM
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-2,2);       //    and its legend
}
void draw(){
  centerX = 3.5 * L;
  centerY = 2 * L;
  rTrace = centerX - L;
  angle += flow.dt * omega;
  theta = amplitude* sin(angle - PI / 2) + amplitude;
  dtheta = amplitude * omega * cos(angle - PI / 2) * flow.dt;
  body.rotate(- dtheta);
  body.translate(rTrace * sin(theta) * dtheta, rTrace * cos(theta) * dtheta);

  flow.update(body); flow.update2();         // 2-step fluid update
  flood.display(flow.u.curl());              // compute and display vorticity
  body.display();                            // display the body
}
void mousePressed(){body.mousePressed();}    // user mouse...
void mouseReleased(){body.mouseReleased();}  // interaction methods
void mouseWheel(MouseEvent event){body.mouseWheel(event);}