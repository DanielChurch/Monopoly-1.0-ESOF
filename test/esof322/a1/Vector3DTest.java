package esof322.a1;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.*;

public class Vector3DTest {

    @Rule
    public final ExpectedException invalidArgumentException = ExpectedException.none();

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
    public void testAdd() throws Exception {}

    @Test
    public void testSubtract() throws Exception {}

    @Test
    public void testScale() throws Exception {}

    @Test
    public void testNegate() throws Exception {}

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
        assertTrue(new Vector3D(1,0,1).equals(new Vector3D(1,0,1)));
        assertTrue(vector010.equals(vector010));
        assertFalse(vector010.equals(vector541));

        assertTrue(new Vector3D(1,0,0).equals(new Vector3D(1,0,0)));
        assertFalse(new Vector3D(1,0,0).equals(new Vector3D(0,0,0)));

        assertTrue(new Vector3D(0,1,0).equals(new Vector3D(0,1,0)));
        assertFalse(new Vector3D(0,1,0).equals(new Vector3D(0,0,0)));

        assertTrue(new Vector3D(0,0,1).equals(new Vector3D(0,0,1)));
        assertFalse(new Vector3D(0,0,1).equals(new Vector3D(0,0,0)));

        invalidArgumentException.expect(IllegalArgumentException.class);
        invalidArgumentException.expectMessage("You can only compare a vector to another vector.");
        vector010.equals(0d);
    }
}