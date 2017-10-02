package esof322.a1;

public final class Vector3D {

    private double x, y, z;

    public Vector3D (double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * Returns the added x,y,z values of two Vector3D's
     * @param other
     * @return
     */
    public Vector3D add(Vector3D other) {
        return new Vector3D(x + other.x, y + other.y, z + other.z);
    }

    public Vector3D subtract(Vector3D other) {return new Vector3D(x - other.x, y - other.y, z - other.z);}

    public Vector3D scale(double scalar) {return null;}

    /**
     * Returns the vectors x,y,z values multiplied by the common factor -1
     * @return
     */
    public Vector3D negate() {
        return scale(-1);
    }

    public double dot(Vector3D other) {return 0d;}

    /**
     * Returns the magnitude (length) of the vector.
     * @return
     */
    public double magnitude() {
        return Math.sqrt(dot(this));
    }

    @Override
    public String toString() {return "";}

    /**
     * Compares two [Vector3D]s and returns true if they match, or false if they don't.
     * If an Object other than another [Vector3D] is passed in, throws an [IllegalArgumentException].
     * @param other The other [Vector3D] to compare
     * @return True if the two [Vector3D]s match, False if they don't.
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