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
 * Testing sending messages from one to many.
 * @author Michael Søby Andersen, msoa@itu.dk
 * @author Claus Lindquist Henriksen, clih@itu.dk
 */
public class OneToManyBenchmarking {

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
    }, "onetomanybench.log", "jolie.net.onetomanybench");
  }

  @After
  public void tearDown() {
    System.setSecurityManager(null);
  }
  
  @Test
  public void oneToManyAmqpSoap() throws Exception {
    oneToManyAmqp("onetomany/amqp/soap/", "  AMQP  SOAP");
  }
  
  @Test
  public void oneToManyAmqpSodep() throws Exception {
    oneToManyAmqp("onetomany/amqp/sodep/", "  AMQP SODEP");
  }
  
  @Test
  public void oneToManyAmqpSvdep() throws Exception {
    oneToManyAmqp("onetomany/amqp/svdep/", "  AMQP SVDEP");
  }
  
  public void oneToManyAmqp(String dir, String prefix) throws Exception {
    // Setup subscribers.
    JolieSubProcess[] subscribers = new JolieSubProcess[10];
    for (int i = 0; i < subscribers.length; i++) {
      subscribers[i] = new JolieSubProcess(jpf + dir + "subscriber.ol", defaultArgs);
      subscribers[i].start();
      String firstLine = subscribers[i].getOutputLine();
    }
    
    // Setup publisher.
    JolieThread publisher = new JolieThread(jpf + dir + "publisher.ol", defaultArgs);
    
    // Publish!
    logger.info(String.format("Bench started:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    publisher.start();
    publisher.join();
    logger.info(String.format("Bench ended:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    
    // Stop subscribers.
    for (int i = 0; i < subscribers.length; i++) {
      subscribers[i].stop();
    }
    
    // Push memory log to file
    MemoryHandler mh = (MemoryHandler) logger.getHandlers()[0];
    mh.push();
  }
  
    
  @Test
  public void oneToManySocketSoap() throws Exception {
    oneToManySocket("onetomany/socket/soap/", "Socket  SOAP");
  }
    
  @Test
  public void oneToManySocketSodep() throws Exception {
    oneToManySocket("onetomany/socket/sodep/", "Socket SODEP");
  }
  
  public void oneToManySocket(String dir, String prefix) throws Exception {
    // Port definition.
    String port = TestTools.readFile(jpf + dir + "publisher_port.ol", StandardCharsets.UTF_8);
    // Send cmd.
    String sendCmd = TestTools.readFile(jpf + dir + "publisher_sendCmd.ol", StandardCharsets.UTF_8);
    // For containing end result for ports.
    String ports = "";
    // For containing end result for cmds.
    String sendCmds = "";
    
    // Setup subscribers.
    JolieSubProcess[] subscribers = new JolieSubProcess[10];
    for (int i = 0; i < subscribers.length; i++) {
      try (PrintWriter writer = new PrintWriter(jpf + dir + "subscriber_"+(i+1)+".ol", "UTF-8")) {
        String contents = TestTools.readFile(jpf + dir + "subscriber_x.ol", StandardCharsets.UTF_8);
        
        // Setup for writing publisher.
        ports += port.replaceAll("\\{portnum\\}", ""+(i+65000)).replaceAll("\\{num\\}", ""+i) + "\n";
        sendCmds += sendCmd.replaceAll("\\{num\\}", ""+i);
        if (i+1 != subscribers.length) sendCmds += ";\n";
        else sendCmds += "\n";
        
        String replaced = contents.replaceAll("\\{portnum\\}", ""+(i+65000)).replaceAll("\\{num\\}", ""+i);
        writer.print(replaced);
      }
      
      subscribers[i] = new JolieSubProcess(jpf + dir + "subscriber_"+(i+1)+".ol", defaultArgs);
      subscribers[i].start();
      String firstLine = subscribers[i].getOutputLine();
    }
    
    // Generate publisher.
    try (PrintWriter writer = new PrintWriter(jpf + dir + "publisher_1.ol", "UTF-8")) {
      String contents = TestTools.readFile(jpf + dir + "publisher_x.ol", StandardCharsets.UTF_8);
      String replaced = contents.replaceAll("\\{ports\\}", ports);
      String replaced2 = replaced.replaceAll("\\{sendCmds\\}", sendCmds);
      writer.print(replaced2);
    }
    
    // Setup publisher.
    JolieThread publisher = new JolieThread(jpf + dir + "publisher_1.ol", defaultArgs);
    
    // Publish!
    logger.info(String.format("Bench started:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    publisher.start();
    publisher.join();
    logger.info(String.format("Bench ended:" + prefix + "-%s", System.nanoTime())); // For benchmarking.
    
    // Delete publisher generated.
    File file_p = new File(jpf + dir + "publisher_1.ol");
    file_p.delete();
      
    // Stop subscribers.
    for (int i = 0; i < subscribers.length; i++) {
      subscribers[i].stop();
      
      // Delete generated Jolie file.
      File file = new File(jpf + dir + "subscriber_"+(i+1)+".ol");
      file.delete();
    }
    
    // Push memory log to file
    MemoryHandler mh = (MemoryHandler) logger.getHandlers()[0];
    mh.push();
  }
}
