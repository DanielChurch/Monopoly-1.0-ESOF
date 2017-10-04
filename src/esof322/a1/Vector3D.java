package esof322.a1;

public final class Vector3D {

    private double x, y, z;

    public Vector3D(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * Calculates the sum of two [Vector3D]s
     * @param other The [Vector3D] that will be added to this [Vector3D]
     * @return The sum of the two [Vector3D]s
     **/
    public Vector3D add(Vector3D other) {
        return new Vector3D(x + other.x, y + other.y, z + other.z);
    }
    
    /**
     * Subtracts the input [Vector3D] from this [Vector3D]
     * @param other The [Vector3D] to subtract
     * @return The resulting [Vector3D] of the subtraction
     */
    public Vector3D subtract(Vector3D other) {
    	return new Vector3D(x - other.x, y - other.y, z - other.z);
    }

    /**
     * Calculates and returns a scalar multiple of the [Vector3D]
     * @param scalar The scalar to multiply the [Vector3D] by
     * @return The scaled [Vector3D]
     */
    public Vector3D scale(double scalar) {
        return new Vector3D(x * scalar, y * scalar, z * scalar);
    }

    /**
     * Calculates the negation (Components multiplied by -1) of the given [Vector3D]
     * @return The negation of the [Vector3D]
     */
    public Vector3D negate() {
        return scale(-1);
    }

    /**
     * Calculates the dot product of two [Vector3D]s
     * @param other The [Vector3D] to perform dot product with
     * @return The resulting scalar from dot product
     */
    public double dot(Vector3D other) {
    	return x * other.x + y * other.y + z * other.z;
    }

    /**
     * Calculates and returns the magnitude (length) of the [Vector3D].
     * @return The magnitude (length) of the [Vector3D]
     */
    public double magnitude() {
        return Math.sqrt(dot(this));
    }

    /**
     * Creates a [String] representation of the [Vector3D]
     * @return The [String] representation of the [Vector3D]
     */
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
            return subtract(otherVector).magnitude() <= 0.000000000001d;
        } else {
            // Throw an error if they aren't both [Vector3D]
            throw new IllegalArgumentException("You can only compare a vector to another vector.");
        }
    }

}