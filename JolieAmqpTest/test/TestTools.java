/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.MemoryHandler;

/**
 *
 * @author michael
 */
public class TestTools {
  public static Logger setUpLogger(String[] allowedMessages, String filename, String domain) throws IOException {
    // Filter - Only allow entries with specific messages
    ExclusiveMessagesFilter emf = new ExclusiveMessagesFilter(allowedMessages);

    // File handler - Save to time stamps to file
    FileHandler fh = new FileHandler(filename);
    fh.setFormatter(new BenchLogFormatter(allowedMessages[0], allowedMessages[allowedMessages.length - 1]));
    fh.setFilter(emf);

    // Memory buffer - Store in memory during benchmark
    MemoryHandler mh = new MemoryHandler(fh, 1000000, Level.OFF);

    // Logger - Configure logger with handlers, filter and level
    Logger logger = Logger.getLogger(domain);
    logger.setUseParentHandlers(false);
    logger.addHandler(mh);
    logger.setLevel(Level.FINE);

    return logger;
  }
    
  public static String readFile(String path, Charset encoding) throws IOException {
    byte[] encoded = Files.readAllBytes(Paths.get(path));
    return new String(encoded, encoding);
  }
}
