package Semaphore;

import java.util.concurrent.Semaphore;

public class GeneticSemaphore {

    private Semaphore semaphore;

    public GeneticSemaphore(int value){
        semaphore = new Semaphore(value);
    }

    public void acquire() throws InterruptedException {
        try {
            semaphore.acquire();
        }
        catch (InterruptedException e){ }
    }


    public void acquire(int value) throws InterruptedException {
        try {
            semaphore.acquire(value);
        }
        catch (InterruptedException e){ }
    }

    public void release(){
        semaphore.release();
    }

    public void release(int value){
        semaphore.release(value);
    }

    public int availablePermits(){
        return semaphore.availablePermits();
    }

    public boolean tryAcquire() {
        return semaphore.tryAcquire();
    }
}
