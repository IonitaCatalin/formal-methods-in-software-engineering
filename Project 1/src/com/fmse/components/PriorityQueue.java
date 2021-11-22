package com.fmse.components;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class PriorityQueue<E> implements Serializable {
    private final List <PriorityQueueElement<E>> elementsOfPQ;

    public PriorityQueue() {
        elementsOfPQ = new ArrayList<>();
    }

    public boolean isEmpty() {
        return elementsOfPQ.isEmpty();
    }

    public void insert(E elementToPQ) {

        elementsOfPQ.add(new PriorityQueueElement<>(elementToPQ,this.getHighestPriority() + 1));
    }

    public E pullHighestPriorityElement() {

        PriorityQueueElement<E> found = null;
        Integer highestPriority = this.getHighestPriority();

        for(PriorityQueueElement<E> element: elementsOfPQ) {
            if(element.getPQEPriority().equals(highestPriority)){
                found = element;
                return found.getPQEValue();
            }
         }

        return null;
    }

    public void insertWithPriority(E elementToPQ, Integer priority) {
        elementsOfPQ.add(new PriorityQueueElement<>(elementToPQ,priority));
    }


    public Integer getHighestPriority() {

        Integer highestPriority = 0 ;

        for(PriorityQueueElement<E> element: elementsOfPQ) {
            if(element.getPQEPriority() > highestPriority) {
                highestPriority = element.getPQEPriority();
            }
        }

        return elementsOfPQ.isEmpty() ? -1 : highestPriority;

    }


    public List<PriorityQueueElement<E>> getElements() {
        return elementsOfPQ;
    }

    @Override
    public String toString() {
        return "PQ {" + elementsOfPQ.toString() + '}';
    }
}
