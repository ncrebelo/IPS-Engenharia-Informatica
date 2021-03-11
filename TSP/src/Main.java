

import Algorithm.GeneticAlgorithm;
import Utils.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.Scanner;


public class Main {

    public static void main(String[] args) throws IOException {
        run();
    }

    public static void run() throws IOException {

        try{
            int populationSize, numOfThreads, maxTime, mutationProbability;
            Scanner reader = new Scanner(System.in);
            int[][] matrix;

            System.out.println("Filename?");
            matrix = FileParser.importFile(reader);

            System.out.println("Population size?");
            populationSize = UserInput.input(reader);

            System.out.println("Total Number of Threads?");
            numOfThreads = UserInput.input(reader);

            System.out.println("Maximum Run Time (seconds)?");
            maxTime = UserInput.input(reader);

            System.out.println("Mutation Probability?");
            mutationProbability = UserInput.input(reader);


            GeneticAlgorithm geneticAlgorithm = new GeneticAlgorithm(populationSize, numOfThreads,
                    maxTime,matrix, mutationProbability);

            int a = 0;
            boolean terminate = false;
            while (!terminate) {
                printCommandsMenu();
                a = reader.nextInt();
                if (a == 1) {
                    System.out.println("genetic_AJE");
                    geneticAlgorithm.run(0);
                    terminate = true;
                } else if (a == 2) {
                    System.out.println("base_AJE");
                    geneticAlgorithm.run(1);
                    terminate = true;
                } else if (a == 3) {
                    System.out.println("advanced_AJE");
                    geneticAlgorithm.run(2);
                    terminate = true;
                } else if (a == 4) {
                    terminate = true;
                } else {
                    System.out.println("Comando não encontrado!");
                }
            }

            //printMatrix(matrix);

        } catch (IOException | InterruptedException ex) {
            System.err.println("Uncaught exception - " + ex.getMessage());
            ex.printStackTrace(System.err);
        }
    }

    private static void printCommandsMenu(){
        System.out.println("============================================================================");
        System.out.println("                            PROJECT: TSP                                    ");
        System.out.println("============================================================================");
        System.out.println("1. genetic_AJE.");
        System.out.println("2. base_AJE.");
        System.out.println("3. advanced_AJE");
        System.out.println("4. Exit");
        System.out.print("COMMAND>");

    }

    //Testing purposes only
/**
    private static void printMatrix(int[][] matrix){
        for (int[] row : matrix)
            System.out.println(Arrays.toString(row));
        System.out.println("LENGTH = " + matrix.length);
    }*/

}

