package esof322.a1;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.*;

public class Vector3DTest {

    @Rule
    public final ExpectedException expectedException = ExpectedException.none();

    Vector3D vector101;
    Vector3D vector010;

    Vector3D vector541;
    Vector3D vector236;

    Vector3D vectorOneThird;

    @Before
    public void setUp() throws Exception {
        vector101 = new Vector3D(1, 0, 1);
        vector010 = new Vector3D(0, 1, 0);

        vector541 = new Vector3D(5, 4, 1);
        vector236 = new Vector3D(2, 3, 6);

        vectorOneThird = new Vector3D(1/3d, 1/3d, 1/3d);
    }

    @Test
    public void testAdd() throws Exception {
        assertEquals(new Vector3D(1, 1, 1), vector010.add(vector101));
        assertEquals(new Vector3D(7, 7, 7), vector236.add(vector541));
        assertEquals(new Vector3D(2/3d, 2/3d, 2/3d), vectorOneThird.add(vectorOneThird));
    }

    @Test
    public void testSubtract() throws Exception {
    	assertEquals(new Vector3D(0, 0, 0), vector101.subtract(vector101));
    	assertEquals(new Vector3D(1, -1, 1), vector101.subtract(vector010));
    	assertEquals(new Vector3D(-1, 1, -1), vector010.subtract(vector101));
    	
    	assertEquals(new Vector3D(3, 1, -5), vector541.subtract(vector236));
    
    	assertNotEquals(new Vector3D(0, 0, 0), new Vector3D(0, 0, 1).subtract(new Vector3D(0, 0, 0)));
    	assertNotEquals(new Vector3D(0, 0, 0), new Vector3D(0, 1, 0).subtract(new Vector3D(0, 0, 0)));
    	assertNotEquals(new Vector3D(0, 0, 0), new Vector3D(1, 0, 0).subtract(new Vector3D(0, 0, 0)));
    }

    @Test
    public void testScale() throws Exception {
        assertEquals(new Vector3D(0, 2, 0), vector010.scale(2));
        assertEquals(new Vector3D(10, 0, 10), vector101.scale(10));
        assertEquals(new Vector3D(0, 0, 0), vector541.scale(0));
        assertEquals(new Vector3D(22, 33, 66), vector236.scale(11));
        assertEquals(new Vector3D(5, 4, 1), vector541.scale(1));
        assertEquals(new Vector3D(2/3d, 2/3d, 2/3d), vectorOneThird.scale(2));
    }

    @Test
    public void testNegate() throws Exception {
        assertEquals(new Vector3D(0, -1, 0), vector010.negate());
        assertEquals(new Vector3D(-1, 0, -1), vector101.negate());
        assertEquals(new Vector3D(-2, -3, -6), vector236.negate());
        assertEquals(new Vector3D(-5, -4, -1), vector541.negate());
        assertEquals(new Vector3D(-1/3d, -1/3d, -1/3d), vectorOneThird.negate());
    }

    @Test
    public void testDot() throws Exception {
    	assertEquals(0, vector010.dot(vector101), 0);
    	assertEquals(32, new Vector3D(1, 2, 3).dot(new Vector3D(4, 5, 6)), 0);
    	assertEquals(11/12d, new Vector3D(1d, 1/2d, 1/3d).dot(new Vector3D(1/3d, 1/2d, 1d)), 0.000000000001d);
    }

    @Test
    public void testMagnitude() throws Exception {
        assertEquals(1d, vector010.magnitude(), 0d);
        assertEquals(1.414d, vector101.magnitude(), 0.001d);
        assertEquals(6.48d, vector541.magnitude(), 0.01d);
        assertEquals(7d, vector236.magnitude(), 0d);
    }

    @Test
    public void testToString() throws Exception {
        assertEquals("[X: 0.0, Y: 1.0, Z: 0.0]", vector010.toString());
        assertEquals("[X: 1.0, Y: 0.0, Z: 1.0]", vector101.toString());
        assertEquals("[X: 5.0, Y: 4.0, Z: 1.0]", vector541.toString());
        assertEquals("[X: 2.0, Y: 3.0, Z: 6.0]", vector236.toString());
        assertEquals("[X: " + 1/3d + ", Y: " + 1/3d + ", Z: " + 1/3d + "]", vectorOneThird.toString());
    }


    @Test
    public void testEquals() throws Exception {
        // Verify .equals() works on a few basic cases
        assertEquals(new Vector3D(1, 0, 1), new Vector3D(1, 0, 1));
        assertEquals(vector010, vector010);
        assertNotEquals(vector010, vector541);

        // Verify .equals() has a tolerance
        assertEquals(   new Vector3D(0.333333333333d, 0, 0), new Vector3D(1/3d, 0, 0));
        assertNotEquals(new Vector3D(0.33333333333d, 0, 0), new Vector3D(1/3d, 0, 0));

        // Check for each axis - x, y, z
        // X
        assertEquals(new Vector3D(1, 0, 0), new Vector3D(1, 0, 0));
        assertNotEquals(new Vector3D(1, 0, 0), new Vector3D(0, 0, 0));

        // Y
        assertEquals(new Vector3D(0, 1, 0), new Vector3D(0, 1, 0));
        assertNotEquals(new Vector3D(0, 1, 0), new Vector3D(0, 0, 0));

        // Z
        assertEquals(new Vector3D(0, 0, 1), new Vector3D(0, 0, 1));
        assertNotEquals(new Vector3D(0, 0, 1), new Vector3D(0, 0, 0));

        // Try with an object that isn't a [Vector3D] and verify it throws an error
        expectedException.expect(IllegalArgumentException.class);
        expectedException.expectMessage("You can only compare a vector to another vector.");
        assertNull("You can only compare a vector to another vector.", vector010.equals(0d));
    }
}