package Algorithm;

import Population.*;
import Semaphore.GeneticSemaphore;
import Utils.ResultPrinter;

import java.util.Random;

public class GeneticAlgorithm {

    private final PopulationManagement population;
    private final PopulationManagement bestPopulation;
    private final PopulationManagement threadPopulation;
    private final PopulationManagement bestThreadPopulation;
    private final GeneticSemaphore sem1;
    private final GeneticSemaphore sem2;
    private final GeneticSemaphore sem3;
    private final Random random;

    private final Thread[] threads;

    private final int populationSize;
    private final int numOfThreads;
    private final int maxTime;
    private final int[][] matrix;
    private final int mutationProbability;
    private int numOfIterations;
    private double timeElapsed ;
    private long multiple;
    private int popSize;
    private long startTime;
    private long endTime;

    public GeneticAlgorithm(int populationSize, int numOfThreads, int maxTime,
                            int[][] matrix, int mutationProbability){
        this.populationSize = populationSize;
        this.numOfThreads = numOfThreads;
        this.maxTime = maxTime;
        this.matrix = matrix;
        this.mutationProbability = mutationProbability;
        numOfIterations = 0;
        timeElapsed  = 0;
        popSize = populationSize * numOfThreads;
        this.population = new PopulationManagement(numOfThreads);
        this.bestPopulation = new PopulationManagement(populationSize);
        threadPopulation = new PopulationManagement(popSize);
        bestThreadPopulation = new PopulationManagement(populationSize);
        random = new Random();
        sem1 = new GeneticSemaphore(1);
        sem2 = new GeneticSemaphore(1);
        sem3 = new GeneticSemaphore(1);
        threads = new Thread[numOfThreads];
        multiple = 10;
    }

    public void run(int choice) throws InterruptedException {
        startTime = System.nanoTime();
        long endTime = startTime + (maxTime * 1000);
        if(choice!=0) {
            for (int i = 0; i < numOfThreads; i++) {
                threads[i] = new Thread("Thread");
                System.out.println(threads[i].getName() + ": " + i + " Initialising....");
                if (choice == 1)
                    executeBaseGeneticAlgorithm(startTime, endTime);
                if (choice == 2)
                    executeAdvancedGeneticAlgorithm(startTime, endTime, multiple);
                threads[i].start();
                Thread.sleep(500);
            }
            for (int j = 0; j < numOfThreads; j++) {
                try {
                    threads[j].join();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
        else{
            executeGeneticAlgorithm(startTime, endTime);
        }
        long runningTime = System.nanoTime();
        timeElapsed = (runningTime - startTime)/1000000000d;
        printResults();
    }


    /**
     * Genetic Algorithm execution
     * @param startTime
     * @param endTime
     * @throws InterruptedException
     */
    public void executeGeneticAlgorithm(long startTime, long endTime) throws InterruptedException {
        Genome genome1, genome2, genomeChild1, genomeChild2;
        PopulationManagement population = new PopulationManagement(populationSize);

        int[] cities = generateCities();
        population.generatePopulations(cities, matrix);

        int iterationCount = 0;

        while(iterationCount < numOfThreads && startTime < endTime) {
            genome1 = population.getBestResult();
            genome2 = population.getSecondBestResult();

            genomeChild1 = new Genome(matrix.length);
            genomeChild2 = new Genome(matrix.length);

            pmxCrossover(genome1, genome2, genomeChild1, genomeChild2);

            genomeChild1.calculateDistances(matrix);
            genomeChild2.calculateDistances(matrix);

            exchangeMutation(genomeChild1, genomeChild2, mutationProbability,matrix.length);

            population.removeWorstResults();
            population.add(genomeChild1);
            population.add(genomeChild2);

            iterationCount++;
        }
        bestPopulation.add(population.getBestResult());
        numOfIterations = iterationCount;
    }

    /**
     * Genetic Algorithm execution - Base Version
     * @param startTime
     * @param endTime
     * @throws InterruptedException
     */
    public void executeBaseGeneticAlgorithm(long startTime, long endTime) throws InterruptedException {
        Genome genome1, genome2, genomeChild1, genomeChild2;
        PopulationManagement population = new PopulationManagement(populationSize);

        int[] cities = generateCities();
        population.generatePopulations(cities, matrix);

        int iterationCount = 0;

        while(iterationCount < numOfThreads && startTime < endTime) {

            genome1 = population.getBestResult();
            genome2 = population.getSecondBestResult();

            genomeChild1 = new Genome(matrix.length);
            genomeChild2 = new Genome(matrix.length);

            pmxCrossover(genome1, genome2, genomeChild1, genomeChild2);

            genomeChild1.calculateDistances(matrix);
            genomeChild2.calculateDistances(matrix);

            exchangeMutation(genomeChild1, genomeChild2, mutationProbability,matrix.length);

            population.removeWorstResults();
            population.add(genomeChild1);
            population.add(genomeChild2);

            iterationCount++;
        }
        sem1.acquire();
        compareBestResult(population);
        sem1.release();
        numOfIterations = iterationCount;
    }

    /**
     * Genetic Algorithm execution - Advanced Version
     * @param startTime
     * @param endTime
     * @param multiple
     * @throws InterruptedException
     */
    public void executeAdvancedGeneticAlgorithm(long startTime, long endTime, double multiple)
                                                                    throws InterruptedException {
        Genome genome1, genome2, genomeChild1, genomeChild2;
        PopulationManagement population = new PopulationManagement(populationSize);

        int[] cities = generateCities();
        population.generatePopulations(cities, matrix);

        int iterationCount = 0;

        while (iterationCount < numOfThreads && startTime < endTime) {
            genome1 = population.getBestResult();
            genome2 = population.getSecondBestResult();

            genomeChild1 = new Genome(matrix.length);
            genomeChild2 = new Genome(matrix.length);

            pmxCrossover(genome1, genome2, genomeChild1, genomeChild2);

            genomeChild1.calculateDistances(matrix);
            genomeChild2.calculateDistances(matrix);

            exchangeMutation(genomeChild1, genomeChild2, mutationProbability, matrix.length);

            iterationCount++;
        }
        //copies Population to threadPopulation without criteria
        sem1.acquire();
        copyPopulations(population);
        sem1.release();

        //adds to bestThreadPopulation the best result in each iteration of threadPopulation and clears it
        sem2.acquire();
        bestThreadPopulation.add(threadPopulation.getBestResult());
        population.clear();
        threadPopulation.clear();
        sem2.release();

        //compares the results in bestThreadPopulation and returns the best one
        sem3.acquire();
        compareBestResult(bestThreadPopulation);
        sem3.release();

        numOfIterations = iterationCount;
    }

    /**
     * compares the result in the population against the new possible best result
     * @param population
     */
    private void compareBestResult(PopulationManagement population){
        int comp;

        if(bestPopulation.isEmpty())
            comp = -1;
        else
            comp = population.getBestResult().compareTo(bestPopulation.getBestResult());

        if(comp <= -1 && bestPopulation.isEmpty()){
            bestPopulation.add(population.getBestResult());
            System.out.println("Updated with values: " + bestPopulation);
        }
        else if(bestPopulation.getBestResult().getDistance() > population.getBestResult().getDistance()){
            bestPopulation.removeWorstResult();
            bestPopulation.add(population.getBestResult());
            System.out.println("Removed old value & updated with a new values: " + bestPopulation);
        }
        else{
            System.out.println("No update was needed!");
        }
    }

    /**
     * copies population to a new population
     * @param population
     */
    private void copyPopulations(PopulationManagement population) {
        for(Genome g : population){
            threadPopulation.add(g);
        }
    }

    /**
     * for use in executeAdvancedGeneticAlgorithm
     * @param multiple
     * @return
     */
    private double getTimeElapsedPercentage(double multiple){
        double division = timeElapsed / multiple;
        return division * multiple;
    }


    /**
     * determines the probability of occurring the exchange mutation
     * @param child1
     * @param child2
     * @param mutationProbability
     */
    private void exchangeMutation(Genome child1, Genome child2,
                                  int mutationProbability, int size){
        int exchangeProbability = random.nextInt(100+1);
        if(exchangeProbability < mutationProbability){
            swapPaths(child1, child2, size);
        }
    }

    /**
     * swaps paths between 2 genomes
     * @param genome1
     * @param genome2
     * @param size
     */
    private void swapPaths(Genome genome1, Genome genome2, int size){
        int r1, r2 = 0, temp;
        r1 = random.nextInt(size);
        while(r1 == r2){
            r2 = random.nextInt(size); //keeps randomizing if r1 = r2
        }
        temp = genome1.getPosition(r1); //temp is now the pos from random
        genome1.setPosition(r1, genome1.getPosition(r2)); //new position for genome1
        genome2.setPosition(r2, temp);//new position for genome2
    }

    /**
     * generates the cities of a Genome
     * @return
     */
    private int[] generateCities(){
        int size = matrix.length;
        int[] cities = new int[size];
        for(int i = 0 ; i < size ; i++)
            cities[i] = i + 1;
        return cities;
    }


    private static void pmxCrossover(Genome genome1, Genome genome2, Genome genomeChild1,
                                   Genome genomeChild2) {

        int n = genome1.getPathSize();
        Random rand = new Random();
        int cuttingPoint1, cuttingPoint2;
        int[] parent1 = genome1.copyPath();
        int[] parent2 = genome2.copyPath();
        int[] offSpring1 = new int[n];
        int[] offSpring2 = new int[n];

        int[] replacement1 = new int[n + 1];
        int[] replacement2 = new int[n + 1];
        int i, n1, m1, n2, m2;
        int swap;

        /**for (i=0; i< n; i++)
         System.out.printf("%2d ",parent1[i]);
         System.out.println();
         for (i=0; i< n; i++)
         System.out.printf("%2d ",parent2[i]);
         System.out.println();*/

        cuttingPoint1 = rand.nextInt(n);
        cuttingPoint2 = rand.nextInt(n);
        while (cuttingPoint1 == cuttingPoint2) {
            cuttingPoint2 = rand.nextInt(n);
        }


        if (cuttingPoint1 > cuttingPoint2) {
            swap = cuttingPoint1;
            cuttingPoint1 = cuttingPoint2;
            cuttingPoint2 = swap;
        }

        for (i = 0; i < n + 1; i++) {
            replacement1[i] = -1;
            replacement2[i] = -1;
        }

        for (i = cuttingPoint1; i <= cuttingPoint2; i++) {
            offSpring1[i] = parent2[i];
            offSpring2[i] = parent1[i];
            replacement1[parent2[i]] = parent1[i];
            replacement2[parent1[i]] = parent2[i];
        }

        //System.out.printf("cp1 = %d cp2 = %d\n",cuttingPoint1,cuttingPoint2);

        for (i = 0; i < n + 1; i++) {
            replacement1[i] = -1;
            replacement2[i] = -1;
        }

        for (i = cuttingPoint1; i <= cuttingPoint2; i++) {
            offSpring1[i] = parent2[i];
            offSpring2[i] = parent1[i];
            replacement1[parent2[i]] = parent1[i];
            replacement2[parent1[i]] = parent2[i];
        }

        /**for (i=0; i< n+1; i++)
         System.out.printf("%2d ",replacement1[i]);
         System.out.println();

         for (i=0; i< n+1; i++)
         System.out.printf("%2d ",replacement2[i]);
         System.out.println();*/

        // fill in remaining slots with replacements
        for (i = 0; i < n; i++) {
            if ((i < cuttingPoint1) || (i > cuttingPoint2)) {
                n1 = parent1[i];
                m1 = replacement1[n1];
                n2 = parent2[i];
                m2 = replacement2[n2];
                while (m1 != -1) {
                    n1 = m1;
                    m1 = replacement1[m1];
                }
                while (m2 != -1) {
                    n2 = m2;
                    m2 = replacement2[m2];
                }
                offSpring1[i] = n1;
                offSpring2[i] = n2;

            }
        }
        genomeChild1.setPath(offSpring1);
        genomeChild2.setPath(offSpring2);
    }

    /**
     * prints in table format the results
     */
    private void printResults(){
        ResultPrinter rp = new ResultPrinter();
        rp.addColumn("Population Size");
        rp.addEntry(0, String.valueOf(matrix.length));
        rp.addColumn("Total Execution Time");
        rp.addEntry(1, String.valueOf(timeElapsed));
        rp.addColumn("Total number of Threads");
        rp.addEntry(2,String.valueOf(numOfThreads));
        rp.addColumn("Best Result");
        rp.addEntry(3,String.valueOf(bestPopulation.getBestResult().getDistance()));
        rp.addColumn("Total number of Iterations performed");
        rp.addEntry(4,String.valueOf(numOfIterations));
        rp.addColumn("Best Path Found");
        rp.addEntry(5,bestPopulation.getBestResult().getPath());
        System.out.println(rp.render());
    }
}
