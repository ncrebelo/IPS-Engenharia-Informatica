package com.pa.proj2020.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * @authors Frederico Alcaria, Patrick Forsthofer, Daniel Lachkeev & Nuno Rebelo
 */
public class FileParser {

    /**
     *
     * @param fileName Full file name with extension
     * @param filePath Path from where the executable is running on
     * @return a List of the lines read from a file
     * @throws IOException for bad reading
     */
    public static List<String> getLines(String fileName, String filePath) throws IOException{
        List<String> lines = new ArrayList<>();

        BufferedReader b = null;
        try {
            String readLine;
            File file = new File(filePath + fileName);
            b = new BufferedReader(new FileReader(file));
            while ((readLine = b.readLine()) != null) {
                lines.add(readLine);
            }
        } catch (IOException e) {
            System.out.println(e + "WRONG FILE NAME OR FILE NOT FOUND");
        } finally {
            b.close();
        }
        return lines;
    }

}
