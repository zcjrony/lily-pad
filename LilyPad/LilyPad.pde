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
import java.io.*;

BDIM flow;
//Body body;
//NACA body;
Rectangle body;
SaveData dat;
FloodPlot flood;
StreamPlot stream;
int resolution = 32;
float L = resolution / 2;
float omega = 0.15;
float angle = 0;
float amplitude = PI / 4;
float theta;
float centerX = 4.5 * L;
float centerY = 2.5 * L;
float rTrace = centerX - 2 * L;
float dtheta;
float time = 0;
float Re = 12000;
float nu = L * amplitude * omega * rTrace * L / Re;
PVector force = new PVector(0,0);
VectorField uinit;

//BDIM( int n_, int m_, float dt_, AbstractBody body, VectorField uinit, float nu_, boolean QUICK_ )

void setup(){
  size(700,700);                             // display window size
  int n = resolution * 4;                       // number of grid points
  L = n/8;                            // length-scale in grid units
  Window view = new Window(n,n);
  uinit = new VectorField(n + 2, n + 2, 0, 0);
  body = new Rectangle(2 * L, 2.5 * L, L, L / 8, view);
  flow = new BDIM(n, n, 0.1, body, uinit, nu, true);             // solve for flow using BDIM
  //flow = new BDIM(n,n,0,body,1e-3,true);
  flow = new BDIM(n,n,nu,body);
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-10,10);       //    and its legend
  stream = new StreamPlot(view, flow, 10);
  stream.setLegend("stream", -2, 2);

}
void draw(){
  centerX = 3.5 * L;
  centerY = 2.5 * L;
  rTrace = centerX - L;
  angle += flow.dt * omega;
  time += flow.dt;
  theta = amplitude* sin(angle - PI / 2) + amplitude;
  dtheta = amplitude * omega * cos(angle - PI / 2) * flow.dt;
  body.rotate(- dtheta);
  body.translate(rTrace * sin(theta) * dtheta, rTrace * cos(theta) * dtheta);
  
  force=body.pressForce(flow.p);
  println(time + "," + force + "," + theta);

  try{
    File file=new File(".\\forces.txt");
    FileOutputStream f1 = new FileOutputStream(file, true);
    String str = time + "," + force + "," + theta;
    byte[] buff=str.getBytes();
    f1.write(buff);
    f1.write("\r\n".getBytes());
  } catch (Exception e) {// Catch exception if any
    System.err.println("Error: " + e.getMessage());
  }

  flow.update(body); flow.update2();         // 2-step fluid update
  flood.display(flow.u.curl());              // compute and display vorticity
  body.display();                            // display the body

  //stream.display(flow.u.curl());
  //dat.addData(t, test.foil.pressForce(test.flow.p), test.foil, test.flow.p);
}
void mousePressed(){body.mousePressed();}    // user mouse...
void mouseReleased(){body.mouseReleased();}  // interaction methods
void mouseWheel(MouseEvent event){body.mouseWheel(event);}