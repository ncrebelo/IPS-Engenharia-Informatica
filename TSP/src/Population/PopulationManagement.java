package Population;


import java.nio.BufferOverflowException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

/**
 * Class that handles a collection of Genomes with supporting algorithms to determine
 * certain results
 */
public class PopulationManagement implements Iterable<Genome> {

    private ArrayList<Genome> genomes;
    private int maxSize;

    /**
     * constructs an ArrayList of Genomes with a maxSize
     * @param maxSize
     */
    public PopulationManagement(int maxSize){
        this.maxSize = maxSize;
        genomes = new ArrayList<>();
    }

    public boolean isEmpty(){
        return genomes.isEmpty();
    }

    /**
     * adds a Genome object to the collection
     * @param genome
     */
    public void add(Genome genome) {
        if (genomes.size() == maxSize) {
            throw new BufferOverflowException();
        }
        genomes.add(genome);
    }

    public void clear(){
        genomes.clear();
    }

    /**
     * adds multiples genomes to the population
     * @param cities
     * @param matrix
     */
    public void generatePopulations(int[] cities, int[][]matrix){
        while(getSize() < maxSize){
            Genome g = new Genome(cities, matrix);
            add(g);
        }
    }

    /**
     * sorts the List and returns the best
     * @return the best result in the collection, ergo, position 0 of the list
     */
    public Genome getBestResult(){
        Genome bestResult;
        Collections.sort(genomes);
        bestResult = genomes.get(0);

        return bestResult;
    }

    /**
     * sorts the List and returns the second best
     * @return
     */
    public Genome getSecondBestResult(){
        Genome secondBestResult;
        Collections.sort(genomes);
        secondBestResult = genomes.get(1);

        return secondBestResult;
    }


    /**
     * removes the worst possible result
     */
    public void removeWorstResult(){
        genomes.remove(getWorstResult());
    }

    /**
     * if list size is greater than 2, then, it will remove the last 2 results
     */
    public void removeWorstResults(){
        if(genomes.size() <= 2);

        if(genomes.size() > 2){
            genomes.remove(getWorstResult());
            genomes.remove(getWorstResult());
        }
    }

    /**
     * @return the worst result in the collection
     */
    public Genome getWorstResult(){
        Genome worstResult;
        Collections.sort(genomes);
        worstResult = genomes.get(getSize() - 1);

        return worstResult;
    }


    public int getSize(){
        return genomes.size();
    }

    @Override
    public Iterator<Genome> iterator() {
        return genomes.iterator();
    }

    @Override
    public String toString () {
        StringBuilder sb = new StringBuilder();

        for (Genome genome : genomes) {
            sb.append("\n");
            sb.append(genome);
        }
        return new String(sb);
    }
}
