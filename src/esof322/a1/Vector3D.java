package esof322.a1;

public final class Vector3D {

    private double x, y, z;

    public Vector3D (double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Vector3D add(Vector3D other) {return null;}
    /**
     * Subtracts the input vector from this vector
     * @param other the vector to subtract
     * @return the resulting vector of the subtraction
     */
    public Vector3D subtract(Vector3D other) {return new Vector3D(this.x - other.x, this.y - other.y, this.z - other.z);}

    public Vector3D scale(double scalar) {return null;}

    public Vector3D negate() {return null;}

    /**
     * Perform dot product with other vector
     * @param other vector to perform dot product with
     * @return the resulting scalar from dot product
     */
    public double dot(Vector3D other) {return this.x * other.x + this.y * other.y + this.z * other.z;}

    public double magnitude() {
        return Math.sqrt(dot(this));
    }

    @Override
    public String toString() {return "";}

    @Override
    public boolean equals(Object other) {
        if(other instanceof Vector3D) {
            Vector3D otherVector = (Vector3D) other;
            return subtract(otherVector).magnitude() <= 0.1d; // TODO: Consider refining tolerance
        } else {
            throw new IllegalArgumentException("You can only compare a vector to another vector.");
        }
    }

}