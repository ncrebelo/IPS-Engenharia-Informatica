package Utils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class FileParser {

    public static int[][] importFile(Scanner reader) throws IOException {

        String filePath = "./tsp_testes/";
        String fileType = ".txt";
        BufferedReader b;
        while(true){
            String fileName = reader.next();
        try {
            b = new BufferedReader(new FileReader(filePath + fileName + fileType));
            return readDataFromFile(b);
        }catch(IOException e){
        System.out.println("Invalid filename");
    }
}
    }

    public static int[][] readDataFromFile(BufferedReader b) throws IOException{
        int [][] matrix = null;
        int index = -1;
        int numCities;
        int numColumns = 0;
        String lines;
        ArrayList<String> columns;

        while((lines = b.readLine()) != null){
            if(index == -1){
                numCities = Integer.parseInt(lines);
                matrix = new int[numCities][numCities];
                index++;
                continue;
            }
            columns = new ArrayList<>(Arrays.asList(lines.split(" ")));
            for(String e : columns){
                try{
                    matrix[index][numColumns] = Integer.parseInt(e);
                    numColumns++;
                } catch(NumberFormatException ignored){}
            }
            numColumns = 0;
            index++;
        }
        return matrix;
    }
}