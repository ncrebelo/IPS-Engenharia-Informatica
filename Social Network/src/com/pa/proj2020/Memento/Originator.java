package com.pa.proj2020.Memento;

public interface Originator {
    Memento createMemento();

    void setMemento(Memento savedState);
}
