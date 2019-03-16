package g52dsy;
import redis.clients.jedis.Jedis;
public class RedisTest1 {
	public static void main(String args[]) {
		try {
			Jedis jedis = new Jedis("localhost");
			jedis.set("foo", "bar");
			String value = jedis.get("foo");
			System.out.println("foo = "+value);
		} catch (Exception e) {
			System.err.println("Error: "+e);
			e.printStackTrace(System.err);
		}
	}
}

