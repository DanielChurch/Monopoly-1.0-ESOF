package esof322.a1;

import org.junit.Before;
import org.junit.Ignore;
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

    @Before
    public void setUp() throws Exception {
        vector101 = new Vector3D(1, 0, 1);
        vector010 = new Vector3D(0, 1, 0);

        vector541 = new Vector3D(5,4,1);
        vector236 = new Vector3D(2,3,6);
    }

    @Test
    public void testAdd() throws Exception {
        assertEquals(vector010.add(vector101), new Vector3D(1,1,1));
        assertEquals(vector236.add(vector541), new Vector3D(7,7,7));
    }

    @Test
    public void testSubtract() throws Exception {}

    @Test
    public void testScale() throws Exception {}

    @Test
    public void testNegate() throws Exception {
        assertEquals(vector010.negate(), new Vector3D(0,-1,0));
        assertEquals(vector101.negate(), new Vector3D(-1,0,-1));
        assertEquals(vector236.negate(), new Vector3D(-2,-3,-6));
        assertEquals(vector541.negate(), new Vector3D(-5,-4,-1));
    }

    @Test
    public void testDot() throws Exception {}

    @Test
    public void testMagnitude() throws Exception {
        assertEquals(1d, vector010.magnitude(), 0d);
        assertEquals(1.414d, vector101.magnitude(), 0.001d);
        assertEquals(6.48d, vector541.magnitude(), 0.01d);
        assertEquals(7d, vector236.magnitude(), 0d);
    }

    @Test
    public void testToString() throws Exception {}

    @Test
    public void testEquals() throws Exception {
        // Verify .equals() works on a few basic cases
        assertTrue(new Vector3D(1,0,1).equals(new Vector3D(1,0,1)));
        assertTrue(vector010.equals(vector010));
        assertFalse(vector010.equals(vector541));

        // Verify .equals() has a tolerance
        assertTrue(new Vector3D(0.33333d, 0, 0).equals(new Vector3D(1/3d, 0, 0)));
        assertFalse(new Vector3D(0.333d, 0, 0).equals(new Vector3D(1/3d, 0, 0)));

        // Check for each axis - x, y, z
        // X
        assertTrue(new Vector3D(1,0,0).equals(new Vector3D(1,0,0)));
        assertFalse(new Vector3D(1,0,0).equals(new Vector3D(0,0,0)));

        // Y
        assertTrue(new Vector3D(0,1,0).equals(new Vector3D(0,1,0)));
        assertFalse(new Vector3D(0,1,0).equals(new Vector3D(0,0,0)));

        // Z
        assertTrue(new Vector3D(0,0,1).equals(new Vector3D(0,0,1)));
        assertFalse(new Vector3D(0,0,1).equals(new Vector3D(0,0,0)));

        // Try with an object that isn't a [Vector3D] and verify it throws an error
        expectedException.expect(IllegalArgumentException.class);
        expectedException.expectMessage("You can only compare a vector to another vector.");
        assertNull("You can only compare a vector to another vector.", vector010.equals(0d));
    }
}