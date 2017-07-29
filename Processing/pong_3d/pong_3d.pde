import processing.serial.*;

// Arena is 500 x 500 x 500
// Center of the arena is (0, 0, 0)

final float player1_r = 50;
final float player2_r = 50;
final float bal_r = 50.0;
final float minx = -500.0;
final float maxx =  500.0;
final float miny = -250.0;
final float maxy =  250.0;

// Use Ball from https://processing.org/examples/circlecollision.html


final float bal_x = 0.0;
final float bal_y = 0.0;
float bal_dx = 5.0;
float bal_dy = 3.0;
final float player1_x = minx + (1.0 * player1_r);
final float player1_y = 0.0;
final float player1_dy = 0.0;
final float player2_x = maxx - (1.0 * player2_r);
final float player2_y = 0.0;
float player2_dy = 0.0;
float hoek_z = 0.0;
int score1 = 0;
int score2 = 0;

Ball player_1 = new Ball(player1_x, player1_y, player1_r);
Ball player_2 = new Ball(player2_x, player2_y, player2_r);
Ball bal = new Ball(bal_x, bal_y, bal_r);

Serial serial_port;

/// standalone means without Arduino
final boolean standalone = true;

void setup()
{
  size(1000, 1000, P3D);  
  //println(Serial.list());
  if (!standalone)
  {
    serial_port = new Serial(this, Serial.list()[0], 9600);
  }
}

void draw()
{
  if (!standalone)
  {
    while (serial_port.available() > 0) 
    {
      final int spacer_value = serial_port.read();
      if (spacer_value != 0) continue; 
      if (serial_port.available() == 0) break;
      player_1.set_y(map(serial_port.read(), 1, 255, miny, maxy));
      if (serial_port.available() == 0) break;
      player_2.set_y(map(serial_port.read(), 1, 255, miny, maxy));
    }
  }
  background(0);
  noStroke();
  directionalLight(255, 0, 0, -cos(hoek_z * 5.0), -sin(hoek_z * 5.0), 0);
  directionalLight(0, 255, 0, 0, -cos(hoek_z * 7.0), -sin(hoek_z * 7.0));
  directionalLight(0, 0, 255, -sin(hoek_z * 3.0), 0, -cos(hoek_z * 3.0));

  translate(width / 2, height / 2);
  rotateX(hoek_z * 0.2);
  rotateY(hoek_z * 0.3);
  rotateZ(hoek_z);

  /*
  translate(bal_x, bal_y);
  sphere(bal_r);
  translate(-bal_x, -bal_y);

  translate(player1_x, player1_y);
  sphere(player1_r);
  translate(-player1_x, -player1_y);

  translate(player2_x, player2_y);
  sphere(player2_r);
  translate(-player2_x, -player2_y);
  */
  player_1.move();
  player_2.move();
  bal.move();

  player_1.display();
  player_2.display();
  bal.display();
 
  bal.checkCollision(player_1);
  bal.checkCollision(player_2);

  
  //Draw surrounding
  for (float i = 0; i < 100.0; i += 1.0)
  {
    final float block_x = minx + ((i / 100.0) * (maxx - minx));
    final float block_y = miny ;
    translate(block_x, block_y);
    box(10);
    translate(-block_x, -block_y);
  }
  for (float i = 0; i < 100.0; i += 1.0)
  {
    final float block_x = minx + ((i / 100.0) * (maxx - minx));
    final float block_y = maxy;
    translate(block_x, block_y);
    box(10);
    translate(-block_x, -block_y);
  }
  for (float i = 0; i < 100.0; i += 1.0)
  {
    final float block_x = minx;
    final float block_y = miny + ((i / 100.0) * (maxy - miny));
    translate(block_x, block_y);
    box(10);
    translate(-block_x, -block_y);
  }
  for (float i = 0; i < 100.0; i += 1.0)
  {
    final float block_x = maxx;
    final float block_y = miny + ((i / 100.0) * (maxy - miny));
    translate(block_x, block_y);
    box(10);
    translate(-block_x, -block_y);
  }
  
  text(score1, 0, -10);
  text(score2, 0, +10);

  hoek_z += 0.001;
  
  /*
  player1_y += player1_dy;
  player2_y += player2_dy;
  
  bal_x += bal_dx;
  bal_y += bal_dy;

  if (player1_y < miny) { player1_y = miny; player1_dy = 0.0; }
  if (player1_y > maxy) { player1_y = maxy; player1_dy = 0.0; }
  if (player2_y < miny) { player2_y = miny; player2_dy = 0.0; }
  if (player2_y > maxy) { player2_y = maxy; player2_dy = 0.0; }

  if (bal_x < minx)
  {
    bal_dx = abs(bal_dx);
    ++score2;
  }
  if (bal_x > maxx)
  {
    bal_dx = -abs(bal_dx);
    ++score1;
  }
  if (bal_y < miny)
  {
    bal_dy = abs(bal_dy);
  }
  if (bal_y > maxy)
  {
    bal_dy = -abs(bal_dy);
  }
  if (get_distance(player1_x - bal_x, player1_y - bal_y) < bal_r + player1_r / 2)
  {
    bal_dx = abs(bal_dx);
  }
  if (get_distance(player2_x - bal_x, player2_y - bal_y) < bal_r + player2_r)
  {
    bal_dx = -abs(bal_dx);
  }
  */
}

float get_distance(float dx, float dy)
{
  return sqrt((dx * dx) + (dy * dy)); 
}

void keyPressed() {

  if (key == CODED) 
  {
    if (keyCode == UP) 
    {
      --player2_dy;
    } 
    if (keyCode == DOWN) 
    {
      ++player2_dy;
    } 
  }
  if (key == 'w') 
  {
    player_1.change_dy(-1);
    //--player1_dy;
  }
  if (key == 's') 
  {
    player_1.change_dy( 1);
    //++player1_dy;
  }
  
}



class Ball {
  PVector position;
  PVector velocity;

  float radius, m;

  Ball(float x, float y, float r_) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(3);
    radius = r_;
    m = radius*.1;
  }

  void set_y(float y) {
    position.y = y;
  }
  void change_dy(float change)
  {
    velocity.y += change;  
  }
  void move() 
  {
    position.add(velocity);

    if (position.x > maxx - radius) 
    {
      velocity.x = -abs(velocity.x);
    } 
    else if (position.x < minx + radius) 
    {
      velocity.x = abs(velocity.x);
    } 
    else if (position.y > maxy-radius) 
    {
      velocity.y = -abs(velocity.y);
    } 
    else if (position.y < miny + radius) 
    {
      velocity.y = abs(velocity.y);
    }
  }

  void checkCollision(Ball other) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = radius + other.radius;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }

  void display() {
    translate(position.x, position.y);
    sphere(radius);
    translate(-position.x, -position.y);
  }
}