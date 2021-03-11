
import Population.Genome;
import Population.PopulationManagement;
import Utils.ResultPrinter;


import java.io.IOException;
import java.util.*;

public class AppTester {

    public static void main(String[] args) throws IOException {
/**
        int a =0;
        Scanner reader = new Scanner(System.in);
        while (a!=4){
            printCommandsMenu();
            a = reader.nextInt();
            if(a==1){
                System.out.println("genetic_AJE");
            }
            else if(a==2){
                System.out.println("base_AJE");
            }
            else if(a==3){
                System.out.println("advanced_AJE");
            }
            //System.out.println(a);
        }
*/
//ALGORTIHM AND PMX SECTION****************************************************************

         int[] x = {9,8,4,5,6,7,1,2,3,10};
         int[] y = {8,7,1,2,3,10,9,5,4,6};
         int n = 10;
         Genome g1 = new Genome(10);
         Genome g2 = new Genome(10);
         g1.setPath(x);
         g2.setPath(y);
         Genome g3 = new Genome(n);
         Genome g4 = new Genome(n);

         pmxCrossover(g1, g2, g3, g4);
         System.out.println(g3.toString());
         System.out.println();
         System.out.println(g4.toString());



//GENOME AND POPULATION MANAGEMENT SECTION*************************************************
/**
    int[][] m = {{2,2,2,3}, {7,4,9,3}, {1,3,2,3}, {5,8,9,1}};
    int[] a = {4,1,3,2};
    Genome g1 = new Genome(a, m);
    Genome g2 = new Genome(a, m);
    Genome g3 = new Genome(a, m);
    PopulationManagement p = new PopulationManagement(3);
    PopulationManagement p1 = new PopulationManagement(3);

    p.add(g1);
    p.add(g2);
    p.add(g3);

    System.out.println("G1");
    g1.calculateDistances(m);
    g1.swapPath(a);
    System.out.println("NEW PATH:");
    for(int i = 0; i < a.length; i++){
    System.out.print(a[i]);
    }

    System.out.println("\nG2");
    g2.calculateDistances(m);
    g2.swapPath(a);
    System.out.println("NEW PATH:");
    for(int i = 0; i < a.length; i++){
    System.out.print(a[i]);
    }

    System.out.println("\nG3\n");
    g3.calculateDistances(m);

    System.out.println("DIST 1 = " + g1.getDistance());
    System.out.println("DIST 2 = " + g2.getDistance());
    System.out.println("DIST 3 = " + g3.getDistance());

    System.out.println("POP SIZE " + p.getSize());
    System.out.println("ALL " +  p.getGenomes());
    System.out.println("BEST = " + p.getBestResult());
    System.out.println("WORST = " + p.getWorstResult());



    System.out.println("COMPARE (g1 & g2) = " + g1.compareTo(g2));

 */
    }

    private static void printMatrix(int[][] matrix){
        for (int[] row : matrix)
            System.out.println(Arrays.toString(row));
    }

    public static void pmxCrossover(Genome genome1, Genome genome2, Genome genomeChild1,
                                    Genome genomeChild2) {

        Random rand = new Random();
        int n = genome1.getPathSize();
        int[] parent1;
        parent1 = genome1.copyPath();
        int[] parent2;
        parent2 = genome2.copyPath();
        int[] offSpring1 = new int[n];
        int[] offSpring2 = new int[n];

        int[] replacement1 = new int[n+1];
        int[] replacement2 = new int[n+1];
        int i, n1, m1, n2, m2;
        int swap;



        for (i=0; i< n; i++)
            System.out.printf("%2d ",parent1[i]);
        System.out.println();
        for (i=0; i< n; i++)
            System.out.printf("%2d ",parent2[i]);
        System.out.println();

        int cuttingPoint1 = rand.nextInt(n);
        int cuttingPoint2 = rand.nextInt(n);

        while (cuttingPoint1 == cuttingPoint2) {
            cuttingPoint2 = rand.nextInt(n);
        }

        if (cuttingPoint1 > cuttingPoint2) {
            swap = cuttingPoint1;
            cuttingPoint1 = cuttingPoint2;
            cuttingPoint2 = swap;
        }

        for (i=0; i < n+1; i++) {
            replacement1[i] = -1;
            replacement2[i] = -1;
        }

        for (i=cuttingPoint1; i <= cuttingPoint2; i++) {
            offSpring1[i] = parent2[i];
            offSpring2[i] = parent1[i];
            replacement1[parent2[i]] = parent1[i];
            replacement2[parent1[i]] = parent2[i];
        }

        System.out.printf("cp1 = %d cp2 = %d\n",cuttingPoint1,cuttingPoint2);

        for (i=0; i < n+1; i++) {
            replacement1[i] = -1;
            replacement2[i] = -1;
        }

        for (i=cuttingPoint1; i <= cuttingPoint2; i++) {
            offSpring1[i] = parent2[i];
            offSpring2[i] = parent1[i];
            replacement1[parent2[i]] = parent1[i];
            replacement2[parent1[i]] = parent2[i];
        }

        for (i=0; i< n+1; i++)
            System.out.printf("%2d ",replacement1[i]);
        System.out.println();

        for (i=0; i< n+1; i++)
            System.out.printf("%2d ",replacement2[i]);
        System.out.println();

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

                genomeChild1.preventNulls(offSpring1);
                genomeChild2.preventNulls(offSpring2);

/**
                List<Integer> li = new ArrayList<>();
                for (i = 0; i < offSpring1.length; i++) {
                    li.add(offSpring1[i]);
                }
                for(Integer j: li)
                    Collections.replaceAll(li, 0, rand.nextInt(n));
                int[] tempArray = new int[li.size()];
                for(int j = 0; j < li.size(); j++){
                    tempArray[j] = li.get(j);
                }
                for(int k = 0; k < li.size(); k++) {
                    offSpring1[k] = tempArray[k];
                }
 */

                for (i = 0; i < offSpring1.length; i++)
                    System.out.printf("%2d ", offSpring1[i]);
                    System.out.println();

                for (i = 0; i < offSpring2.length; i++)
                    System.out.printf("%2d ", offSpring2[i]);
                System.out.println();
            }
        }
        genomeChild1.setPath(offSpring1);
        genomeChild2.setPath(offSpring2);
    }

    private static void printCommandsMenu(){
        System.out.println("===================================================================================");
        System.out.println("                            PROJECT: TSP                                           ");
        System.out.println("===================================================================================");
        System.out.println("1. genetic_AJE.");
        System.out.println("2. base_AJE.");
        System.out.println("3. advanced_AJE");
        System.out.println("4. Exit");
        System.out.print("COMMAND>");

    }

}