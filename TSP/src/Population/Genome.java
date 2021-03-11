package Population;

import java.util.*;

/**
 * class that handles the creation of an path or in this case a Genome
 */
public class Genome implements Comparable<Genome>{

    private int[] path;
    private int distance;

    /**
     * constructs a Genome object by initializing an array
     * @param numberOfCities
     */
    public Genome(int numberOfCities){
        this.path = new int[numberOfCities];
    }

    /**
     * constructs a Genome object by initializing an array equal to the one that is passed
     * @param cities array
     * @param matrix 2d array
     */
    public Genome(int[] cities, int [][] matrix){
        this.path = cities.clone();
        swapPath(this.path);
        calculateDistances(matrix);
    }

    /**
     * performs a swap of values
     * @param path
     */
    public void swapPath(int[] path){
        Random rand = new Random();
        for (int i = 0; i < path.length; i++){
            int randomIndexToSwap = rand.nextInt(path.length);
            int temp = path[randomIndexToSwap];
            path[randomIndexToSwap] = path[i];
            path[i] = temp;
        }
    }

    /**
     * calculates the distance. Based on the AJPE algorithm
     * @param matrix of cities
     * @return the distance
     */
    public int calculateDistances(int[][] matrix){
        distance = 0;
        for (int i = 0; i < path.length - 1; i++) {
            int curr = path[i] - 1;
            int next = path[i + 1] - 1;
            distance += matrix[curr][next];
        }
        int last = path[path.length - 1] - 1;
        int first = path[0] - 1;
        distance += matrix[last][first];

        return distance;
    }

    /**
     * Copies the values in the path to a new array
     * @return new path
     */
    public int[] copyPath(){
        int[] temp;
        temp = getCities(path);
        return temp;
    }

    /**
     * aux method for copyPath()
     * @param path
     * @return
     */
    public int[] getCities(int[] path){
        int[] temp = new int[path.length];
        for(int i = 0 ; i < path.length ; i++){
            temp[i] = path[i];
        }
        return temp;
    }

    /**
     * for all positions equal to 0, randomize to a new int
     *
     * @implNote  Seemed necessary, as PMX method was stalling the threads. Currently not in use!
     *
     * @param path
     * @return without null or values = 0 in path to be calculated.
     */
    public int[] preventNulls(int[] path){
        Random rand = new Random();
        int n = path.length;
        List<Integer> li = new ArrayList<>();
        for (int i = 0; i < path.length; i++) {
            li.add(path[i]);
        }
        for(Integer i: li)
            Collections.replaceAll(li, 0, rand.nextInt(n));
        int[] tempArray = new int[li.size()];
        for(int j = 0; j < li.size(); j++){
            tempArray[j] = li.get(j);
        }
        for(int k = 0; k < li.size(); k++) {
            path[k] = tempArray[k];
        }
        return path;
    }

    /**
     * sets the path of an array to a Genome Object
     * @param path
     */
    public void setPath(int[] path) {
        for (int i = 0; i < path.length; i++) {
            for (int j = 0; j < path.length; j++) {
            }
        }
        this.path = path.clone();
    }


    /**
     * returns the index of an array
     * @param pos
     * @return
     */
    public int getPosition(int pos){
        return path[pos];
    }

    /**
     * sets a new index position in the array
     * @param pos
     * @param city
     */
    public void setPosition(int pos, int city){
        path[pos] = city;
    }

    /**
     * @return the calculated distance
     */
    public int getDistance(){
        return distance;
    }

    /**
     *
     * @return the size of an array
     */
    public int getPathSize(){
        return path.length;
    }

    /**
     * Compares 2 genomes's calculated distance
     * @param g
     * @return difference of distances between 2 genomes
     */
    @Override
    public int compareTo(Genome g) {
        int comp = getDistance() - g.getDistance();
        return comp;
    }

    public String getPath() {
        StringBuilder sb;

        sb = new StringBuilder();
        for (int item : path)
            sb.append(item).append("-");
        sb.append("\b");
        return new String(sb);
    }

    @Override
    public String toString () {
        StringBuilder sb;

        sb = new StringBuilder("\t\tPath: ");
        for (int item : path)
            sb.append(item).append("-");
        sb.append("\b");
        sb.append("\n\t\tDistance: ").append(distance);
        return new String(sb);
    }

}
