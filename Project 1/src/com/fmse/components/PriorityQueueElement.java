package com.fmse.components;


import java.io.Serializable;
import java.util.Objects;

public class PriorityQueueElement<E> implements Serializable {
    private final E element;
    private final Integer priority;

    public PriorityQueueElement(E element, Integer priority) {
        this.element = element;
        this.priority = priority;
    }

    public E getPQEValue() {
        return element;
    }

    public Integer getPQEPriority() {
        return priority;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PriorityQueueElement<?> that = (PriorityQueueElement<?>) o;
        return Objects.equals(element, that.element);
    }

    @Override
    public int hashCode() {
        return Objects.hash(element);
    }

    @Override
    public String toString() {
        return "element:" + element + ", priority:"+ priority ;
    }
}
