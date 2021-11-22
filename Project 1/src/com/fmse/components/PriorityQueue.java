package com.fmse.components;

import com.fmse.util.Pair;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class PriorityQueue<E> implements Serializable {
    private final List <PriorityQueueElement<E>> elementsOfPQ;

    public PriorityQueue(List<Pair<E,Integer>> elementsToPQ) {
        elementsOfPQ = new ArrayList<PriorityQueueElement<E>>();

        for(Pair<E,Integer> element: elementsToPQ) {
            elementsOfPQ.add(new PriorityQueueElement<E>(element));
        }
    }

    public PriorityQueue() {
        elementsOfPQ = new ArrayList<PriorityQueueElement<E>>();
    }

    public boolean isEmpty() {
        return elementsOfPQ.isEmpty();
    }

    public void push(E elementToPQ) {

        elementsOfPQ.add(new PriorityQueueElement<>(new Pair<E,Integer>(elementToPQ,this.getHighestPriority() + 1)));
    }

    public E pop() {

        

        return null;
    }

    public void addWithPriority(E elementToPQ, Integer priority) {

    }

    public Integer getHighestPriority() {
        Integer highestPriority = 0 ;

        for(PriorityQueueElement<E> element: elementsOfPQ) {
            if(element.getPQEPriority() > highestPriority) {
                highestPriority = element.getPQEPriority();
            }
        }

        if(elementsOfPQ.isEmpty())
        {
            return -1;
        } else {
            return highestPriority;
        }

    }

    public List<PriorityQueueElement<E>> getElements() {
        return elementsOfPQ;
    }

    @Override
    public String toString() {
        return "PQ {" + elementsOfPQ.toString() + '}';
    }
}
