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

    public Vector3D scale(double scalar) {
        return new Vector3D(x * scalar, y * scalar, z * scalar);
    }

    public Vector3D negate() {return null;}

    /**
     * Perform dot product with other vector
     * @param other vector to perform dot product with
     * @return the resulting scalar from dot product
     */
    public double dot(Vector3D other) {return this.x * other.x + this.y * other.y + this.z * other.z;}

    /**
     * Calculates and returns the magnitude (length) of the [Vector3D].
     * @return the magnitude (length) of the [Vector3D]
     */
    public double magnitude() {
        return Math.sqrt(dot(this));
    }

    @Override
    public String toString() {
        return "[X: " + x + ", Y: " +  y + ", Z: " + z + "]";
    }

    /**
     * Compares two [Vector3D]s and returns true if they match, or false if they don't.
     * If an Object other than another [Vector3D] is passed in, throws an [IllegalArgumentException].
     * @param other The other [Vector3D] to compare
     * @return True if the two [Vector3D]s match, False if they don't
     */
    @Override
    public boolean equals(Object other) {
        // Only compare if both objects are [Vector3D]
        if(other instanceof Vector3D) {
            Vector3D otherVector = (Vector3D) other;
            // Compare the length of the difference of the two [Vector3D]s to check equality
            return subtract(otherVector).magnitude() <= 0.00001d;
        } else {
            // Throw an error if they aren't both [Vector3D]
            throw new IllegalArgumentException("You can only compare a vector to another vector.");
        }
    }

}