// settings
int planetsNumber = 3;
int minRadius = 10;
int maxRadius = 50;
int minMass = 1;
int maxMass = 100;
float g = 0.0001;

// data
Planet[] planets;
int massRange = maxMass - minMass;

void setup() {
  size(600, 600);
  planets = generatePlanets();
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
     newPlanet = new Planet();
     if (newPlanet.collidesWithAnyOf(existingPlanets)) continue;
     break;
  }
  return newPlanet;
}

void draw() {
  background(0);
  for (int i = 0; i < planetsNumber; ++i) {
    Planet p = planets[i]; 
    Planet[] others = (Planet[]) concat(subset(planets, 0, i), subset(planets, i + 1));
    p.update(others).display();
  }
}

class Planet {
  PVector position; // position
  float mass, radius;
  PVector speed, velocity;
  
  Planet() {
    this(
      new PVector(random(width), random(height)), // position
      random(minMass, maxMass), // mass
      random(minRadius, maxRadius), // radius
      new PVector(0,0), new PVector(0,0) // speed and velocity
    );
  }
  
  Planet(PVector position, float mass, float radius, PVector speed, PVector velocity) {
    this.position = position;
    this.mass = mass;
    this.radius = radius;
    this.speed = speed;
    this.velocity = velocity;
  } 
  
  Planet update(Planet[] others) {
    PVector force = combinedForceOfOtherPlanets(others);
    velocity.add(force);
    speed.add(velocity);
    position.add(speed);
    return this;
  }
  
  PVector combinedForceOfOtherPlanets(Planet[] others) {
    PVector force = new PVector(0, 0);
    for (Planet p : others) force.add(forceFromPlanet(p));
    force.div(mass);
    return force;
  }
  
  PVector forceFromPlanet(Planet p) {
    PVector f = p.position.get();
    f.sub(position);
    f.normalize();
    f.mult(g * mass * p.mass / pow(p.position.dist(position), 2));
    return f;
  }
  
  void display() {
    noStroke();
    float colorStep = 256 / massRange;
    fill(colorStep * mass, colorStep * (massRange - mass), 0, 128);
    ellipse(position.x, position.y, radius * 2, radius * 2); 
  }
  
  boolean collidesWith(Planet other) {
    return (position.dist(other.position) - radius - other.radius) <= 0;
  }
  
  boolean collidesWithAnyOf(Planet[] planets) {
    for (Planet p : planets) if (collidesWith(p)) return true;
    return false;
  }
}
