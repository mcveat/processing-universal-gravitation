// settings
int planetsNumber = 5;
int minRadius = 10;
int maxRadius = 50;
int minMass = 1;
int maxMass = 100;

// data
Planet[] planets;
int massRange = maxMass - minMass;

void setup() {
  size(600, 600);
  planets = generatePlanets();
  noLoop();
}

Planet[] generatePlanets() {
  Planet[] result = new Planet[planetsNumber];
  for (int i = 0; i < result.length; ++i) {
    result[i] = generatePlanetWithoutCollisionWith((Planet[]) subset(result, 0, i));
  }
  return result;
}

Planet generatePlanetWithoutCollisionWith(Planet[] existingPlanets) {
  Planet newPlanet = null;
  while (true) {
     newPlanet = new Planet(random(width), random(height), random(minMass, maxMass), random(minRadius, maxRadius));
     if (newPlanet.collidesWithAnyOf(existingPlanets)) continue;
     break;
  }
  return newPlanet;
}

void draw() {
  background(0);
  for (Planet p : planets) p.display();
}

class Planet {
  float x, y; // position
  float mass;
  float radius;
  
  Planet(float x, float y, float mass, float radius) {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.radius = radius;
  } 
  
  void display() {
    noStroke();
    fill(256 / massRange * mass, 256 / massRange * (massRange - mass), 0, 128);
    ellipse(x, y, radius * 2, radius * 2); 
  }
  
  boolean collidesWith(Planet other) {
    return (dist(x, y, other.x, other.y) - radius - other.radius) <= 0;
  }
  
  boolean collidesWithAnyOf(Planet[] planets) {
    for (Planet p : planets) if (collidesWith(p)) return true;
    return false;
  }
}
