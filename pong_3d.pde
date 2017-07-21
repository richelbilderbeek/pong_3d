// Arena is 500 x 500 x 500
// Center of the arena is (0, 0, 0)

final float player1_r = 50;
final float player2_r = 50;
final float bal_r = 50.0;
final float minx = -500.0;
final float maxx =  500.0;
final float miny = -250.0;
final float maxy =  250.0;


float bal_x = 0.0;
float bal_y = 0.0;
float bal_dx = 5.0;
float bal_dy = 3.0;
float player1_x = minx + (1.0 * player1_r);
float player1_y = 0.0;
float player1_dy = 0.0;
float player2_x = maxx - (1.0 * player2_r);
float player2_y = 0.0;
float player2_dy = 0.0;
float hoek_z = 0.0;
int score1 = 0;
int score2 = 0;

void setup()
{
  size(1000, 1000, P3D);  
}

void draw()
{
  background(0);
  noStroke();
  directionalLight(255, 0, 0, -cos(hoek_z * 5.0), -sin(hoek_z * 5.0), 0);
  directionalLight(0, 255, 0, 0, -cos(hoek_z * 7.0), -sin(hoek_z * 7.0));
  directionalLight(0, 0, 255, -sin(hoek_z * 3.0), 0, -cos(hoek_z * 3.0));

  translate(width / 2, height / 2);
  rotateX(hoek_z * 0.2);
  rotateY(hoek_z * 0.3);
  rotateZ(hoek_z);

  translate(bal_x, bal_y);
  sphere(bal_r);
  translate(-bal_x, -bal_y);

  translate(player1_x, player1_y);
  sphere(player1_r);
  translate(-player1_x, -player1_y);

  translate(player2_x, player2_y);
  sphere(player2_r);
  translate(-player2_x, -player2_y);

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
    --player1_dy;
  }
  if (key == 's') 
  {
    ++player1_dy;
  }
  
}