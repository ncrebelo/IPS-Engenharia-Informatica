package Utils;

import java.util.Scanner;

public class UserInput {

    public static int input(Scanner reader){
        String userSelection;
        while(true){
            userSelection = reader.next();
            try{
                return Integer.parseInt(userSelection);
            }catch(NumberFormatException e){
                System.out.println("Insert a valid number (value)");
            }
        }
    }
}
