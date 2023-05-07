import processing.svg.*;

PShape[] truchetTiles;
int[] colorArray;
int numTiles = 2;
int gridRows = 10;
int gridCols = 10;
int gridSize = 1500;
int tileSize = 150;
color bg = color(#404040);

PGraphics baseLayer;
PGraphics overlayLayer;

void settings() {
  size(gridSize, gridSize);
}

void setup() {
  truchetTiles = new PShape[numTiles];

  for (int i = 0; i < numTiles; i++) {
    truchetTiles[i] = loadShape("tile" + i + ".svg");
  }

  colorArray = new int[10];
  for (int i = 0; i < 10; i++) {
    colorArray[i] = color(random(255), random(255), random(255));
    println("Generated color " + (i + 1) + ": " + "#"+ hex(colorArray[i], 6));
  }
  
  baseLayer = createGraphics(gridSize, gridSize);
  overlayLayer = createGraphics(gridSize, gridSize);
}

void draw() {
  background(bg);

  drawLayer(baseLayer);
  drawLayer(overlayLayer);

  image(baseLayer, 0, 0);
  blendMode(SCREEN);// Set the blending mode to MULTIPLY or any other mode that you prefer
  //image(overlayLayer, 0, 0);
  image(overlayLayer, tileSize / 2, tileSize / 2);
  
  blendMode(BLEND);// Reset the blending mode back to default 
  noLoop();
}

void drawLayer(PGraphics layer) {
  layer.beginDraw();
  layer.clear();
  
  for (int row = 0; row < gridRows; row++) {
    for (int col = 0; col < gridCols; col++) {
      int tileIndex = (int) random(numTiles);
      PShape selectedTile = truchetTiles[tileIndex];

      selectedTile.disableStyle();
      int randomColor = colorArray[(int) random(colorArray.length)];
      layer.fill(randomColor);

      layer.pushMatrix();
      layer.translate(col * tileSize + tileSize * 0.5, row * tileSize + tileSize * 0.5);
      int scaleFactor = 75 * (int) random(1, 5); // Random scaling factor with intervals of 50, up to 200
      layer.scale(scaleFactor / (float) selectedTile.width);

      int rotationAngle = (int) random(4) * 90;
      layer.rotate(radians(rotationAngle));

      layer.shape(selectedTile, -selectedTile.width / 2, -selectedTile.height / 2);
      layer.popMatrix();
    }
  }

  layer.endDraw();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    loop();
  } else if (key == 's' || key == 'S') {
    saveImageWithTimestamp();
  }
}

void saveImageWithTimestamp() {
  String timestamp = year() + "_" + nf(month(), 2) + "_" + nf(day(), 2) + "_" + nf(hour(), 2) + "_" + nf(minute(), 2) + "_" + nf(second(), 2);
  String fileName = "outputs/truchet_pattern_" + timestamp + ".png";
  save(fileName);
  println("Image saved: " + fileName);
}
