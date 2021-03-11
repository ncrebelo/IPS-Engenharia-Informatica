package com.pa.proj2020.logger;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.Date;

/**
 * Creates a new entry for certain actions in the file specified in LOGFILE
 */
public final class Logger {

    private static final String LOGFILE = ".\\src\\outputFiles\\" + "log.txt";
    private PrintStream printStream;
    private static final Logger instance = new Logger();

    private Logger() {
        connect();
    }

    public static Logger getInstance() {
        return instance;
    }

    public boolean connect() {
        if (printStream == null) {
            try {
                printStream = new PrintStream(new FileOutputStream(LOGFILE), true);
            } catch (FileNotFoundException ex) {
                printStream = null;
                return false;
            }
            return true;
        }
        return true;
    }

    /**
     * Writes to a log.txt file information regarding the date and a string
     *
     * @param str
     * @throws LoggerException
     */
    public void writeToLog(String str) throws LoggerException {
        if (printStream == null) {
            throw new LoggerException("Connection fail");
        }
        printStream.println(new Date().toString() + " > " + str);
    }
}