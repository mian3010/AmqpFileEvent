
import java.util.logging.Formatter;
import java.util.logging.LogRecord;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author niels
 */
public class BenchLogFormatter extends Formatter {
    private static final String LINE_SEPARATOR = System.getProperty("line.separator");
    private String lastMessage, firstMessage;
    private long firstTime;
    
    public BenchLogFormatter(String firstMessage, String lastMessage) {
      this.firstMessage = firstMessage;
      this.lastMessage = lastMessage;
    }
    
    @Override
    public String format(LogRecord lr) {
      String[] parts = lr.getMessage().split(":");
      String msg = parts[0];
      String[] preftime = parts[1].split("-");
      String prefix = preftime[0];
      String time = preftime[1];
      if(lastMessage.equals(msg)) {
        long lastTime = Long.parseLong(time);
        long diff = lastTime - firstTime;
        return time + " - " + (diff/1000000000.0) + "s"+LINE_SEPARATOR;
      } else if (firstMessage.equals(msg)) {
        firstTime = Long.parseLong(time);
        return prefix + ": " + time + ", ";
      } else {
        return time + ", ";
      }
    }
}
