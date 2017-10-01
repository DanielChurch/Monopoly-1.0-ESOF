package esof322.a1;

public final class Vector3D {

    private double x, y, z;

    public Vector3D (double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Vector3D add(Vector3D other) {return null;}

    public Vector3D subtract(Vector3D other) {return null;}

    public Vector3D scale(double scalar) {return null;}

    public Vector3D negate() {return null;}

    public double dot(Vector3D other) {return 0d;}

    public double magnitude() {return 0d;}

    @Override
    public String toString() {return "";}

    @Override
    public boolean equals(Object other) {return false;}

}