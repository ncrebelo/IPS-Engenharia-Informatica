package com.pa.proj2020.Memento;

import java.util.Stack;

public class CareTaker {
    private Originator originator;
    private Stack<Memento> mementoStack;

    public CareTaker(Originator originator){
        this.originator = originator;
        mementoStack = new Stack<>();
    }

    /**
     * saves the state into a stack
     */
    public void saveState(){
        this.mementoStack.push(originator.createMemento());
    }
}
