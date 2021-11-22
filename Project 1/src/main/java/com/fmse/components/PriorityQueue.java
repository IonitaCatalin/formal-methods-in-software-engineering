package com.fmse.components;

import com.fmse.exceptions.PQueueExceededCapacityException;
import com.fmse.exceptions.PQueueInvalidCapacityException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class PriorityQueue<E> implements Serializable {

    private final List <PriorityQueueElement<E>> contents;
    private final Integer capacity;

    public PriorityQueue(Integer capacity) throws PQueueInvalidCapacityException {
        this.contents = new ArrayList<>();

        if(capacity > 0) {
            this.capacity = capacity;
        } else {
            throw new PQueueInvalidCapacityException("Invalid capacity:" + capacity);
        }

    }

    public boolean isEmpty() {
        return contents.isEmpty();
    }

    public void insert(E element) throws PQueueExceededCapacityException {
        if(contents.size() + 1 <= capacity) {
            contents.add(new PriorityQueueElement<>(element,this.getHighestPriority() + 1));
        } else {
            throw new PQueueExceededCapacityException("Exceeded queue capacity!");
        }

    }

    public E pullHighestPriorityElement() {

        PriorityQueueElement<E> found = null;
        Integer highestPriority = this.getHighestPriority();

        for(PriorityQueueElement<E> element: contents) {
            if(element.getPQEPriority().equals(highestPriority)){
                found = element;
                return found.getPQEValue();
            }
         }

        return null;
    }


    public void insertWithPriority(E element, Integer priority) throws PQueueExceededCapacityException {
        if(contents.size() + 1 <= capacity) {
            contents.add(new PriorityQueueElement<>(element,priority));
        } else {
            throw new PQueueExceededCapacityException("Exceeded queue capacity!");
        }
    }


    public Integer getHighestPriority() {

        Integer highestPriority = 0 ;

        for(PriorityQueueElement<E> element: contents) {
            if(element.getPQEPriority() > highestPriority) {
                highestPriority = element.getPQEPriority();
            }
        }

        return contents.isEmpty() ? -1 : highestPriority;

    }

    public Integer getCapacity() {
        return capacity;
    }

    public List<PriorityQueueElement<E>> getElements() {
        return contents;
    }

    public Integer getSize() {
        return contents.size();
    }


    @Override
    public String toString() {
        return "PQ {" + contents.toString() + '}';
    }
}
