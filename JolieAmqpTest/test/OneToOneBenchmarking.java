/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import org.junit.*;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;
import java.util.logging.MemoryHandler;

/**
 * Testing sending messages from one to one.
 * @author Michael Søby Andersen, msoa@itu.dk
 * @author Claus Lindquist Henriksen, clih@itu.dk
 */
public class OneToOneBenchmarking {

  private static String[] defaultArgs;
  private static String jpf;
  private Logger logger;

  @BeforeClass
  public static void setUpClass() {
    jpf = "jolie-programs/";
    defaultArgs = new String[]{
      "-l", "/opt/jolie_d/lib:/opt/jolie_d/javaServices/*:/opt/jolie_d/extensions/*",
      "-i", "/opt/jolie_d/include"
    };
  }

  @Before
  public void setUp() throws Exception {
    System.setSecurityManager(new NoExitSecurityManager());
    // Set up benchmark logging
    logger = TestTools.setUpLogger(
            new String[]{
      "Bench started",
      "Bench ended"
    }, "onetoonebench.log", "jolie.net.onetoonebench");
  }

  @After
  public void tearDown() {
    System.setSecurityManager(null);
  }
  
  @Test
  public void oneToOneAmqpSodep() throws Exception {
    oneToOne("onetoone/amqp/sodep/", "  AMQP SODEP");
  }
  
  @Test
  public void oneToOneSocketSodep() throws Exception {
    oneToOne("onetoone/socket/sodep/", "Socket SODEP");
  }
  
  public void oneToOne(String dir, String prefix) throws Exception {
    // Setup server.
    JolieSubProcess server = new JolieSubProcess(jpf + dir + "server.ol", defaultArgs);
    server.start();
    server.getOutputLine(); // Wait for server to start.
    
    // Setup client.
    JolieThread client = new JolieThread(jpf + dir + "client.ol", defaultArgs);
    
    // Run benchmark!
    logger.info(String.format("Bench started:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    client.start();
    client.join();
    logger.info(String.format("Bench ended:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    
    // Stop server
    server.stop();
    
    // Push memory log to file
    MemoryHandler mh = (MemoryHandler) logger.getHandlers()[0];
    mh.push();
  }
}
