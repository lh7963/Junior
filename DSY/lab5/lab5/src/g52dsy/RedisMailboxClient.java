package g52dsy;
import java.util.List;
import java.util.Set;
import java.util.HashMap;
import java.util.Map;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisMailboxClient {
	// useful constants
	protected static String MESSAGE = "message:";
	protected static String SUBJECT = "subject";
	protected static String BODY = "body";
	
	// instance state
	protected String mailbox;
	protected JedisPool jedisPool;
	
	public static void main(String args[]) {
		new RedisMailboxClient().go(args);
	}
	// instance method
	protected void go(String args[]) {
		mailbox = (args.length>0) ? args[0] : "mb1";
		try {
			System.out.println("Connecting to redis (on localhost), using mailbox "+mailbox);
			// a pool of Redis connections
			jedisPool = new JedisPool("localhost");
			// run the "UI"
			client();
		} catch (Exception e) {
			System.err.println("Error: "+e);
			e.printStackTrace(System.err);
		}

	}
	protected void client() throws Exception {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		// get Redis connection for synchronous UI requests
		Jedis jedis = jedisPool.getResource();
		while (true) {
			System.out.println("list, get, post or quit?");
			String cmd = br.readLine().trim();
			if ("list".equals(cmd)) {
				// list messages - stored with keys like message:MAILBOX:ID
				Set<String> messageKeys = jedis.keys(MESSAGE+mailbox+":*");
				System.out.println("Messages:");
				for (String key : messageKeys) {
					// get subject for this message
					String subject = jedis.hget(key, SUBJECT);
					System.out.println("  "+key+" "+subject);
				}				
			} else if ("get".equals(cmd)) {
				System.out.println("Get which message id?");
				String key = br.readLine().trim();
				// get message's subject and key values
				List<String> fields = jedis.hmget(key, SUBJECT, BODY);
				System.out.println("Message "+key+": "+fields.get(0)+" - "+fields.get(1));
			} else if ("post".equals(cmd)) {
				System.out.println("Subject?");
				String subject = br.readLine().trim();
				System.out.println("Message?");
				String body = br.readLine().trim();
				// new numeric id for message from redis server (like SQL autoincrement primary key)
				Long nid = jedis.incr("message_next_id");
				String key = MESSAGE+mailbox+":"+nid;
				Map<String,String> fields = new HashMap<String,String>();
				fields.put(SUBJECT, subject);
				fields.put(BODY, body);
				// create/store message
				jedis.hmset(key, fields);
				// chance to notify... (instance method - overridden in Client2)
				newMessage(key);
			} else if ("quit".equals(cmd)) {
				System.out.println("Quit");
				System.exit(0);
			} else {
				System.out.println("Error: unknown command "+cmd);
			}
		}		
	}
	// overridable
	protected void newMessage(String key) {
		// place-holder for Client2
		System.out.println("Added message "+key);
	}
}