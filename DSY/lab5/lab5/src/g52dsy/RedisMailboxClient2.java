package g52dsy;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class RedisMailboxClient2 extends RedisMailboxClient {
	
	public static void main(String args[]) {
		new RedisMailboxClient2().go(args);
	}
	// override...
	protected void client() throws Exception {
		// dedicated Jedis connection for subscriber
		final Jedis jedis = jedisPool.getResource();
		// in a thread because it will block...
		new Thread() {
			public void run() {
				// start subscriber
				new MailboxSubscriber(jedis);				
			}
		}.start();

		super.client();
	}
	// overridable - called after a message is posted
	protected void newMessage(String key) {
		System.out.println("Publish message "+key+" to "+MESSAGE+mailbox);
		// new redis connection to send event (could use the same as client)
		Jedis jedis = jedisPool.getResource();
		// inform all subscribers of new message (key)
		jedis.publish(MESSAGE+mailbox, key);
		// done with that redis connection
		jedisPool.returnResource(jedis);
	}
	protected class MailboxSubscriber extends JedisPubSub {
		MailboxSubscriber(Jedis jedisSub) {
			System.out.println("Subscribe to "+MESSAGE+mailbox);
			// subscribe for new message notifications
			jedisSub.subscribe(this, MESSAGE+mailbox);
		}
		public void onMessage(String channel, String message) {
			// got a message...
			System.out.println("Redis message: "+channel+" - "+message);
			// new redis connection to get more information...
			Jedis jedis = jedisPool.getResource();
			String key = message;
			// get subject for new message
			String subject = jedis.hget(key, "subject");
			System.out.println("New message: "+key+" - "+subject);
			// return that connection to the pool for re-use
			jedisPool.returnResource(jedis);
		}
		public void onSubscribe(String channel, int subscribedChannels) {
			System.out.println("Subscribed to "+channel);
		}
	}
}