package com.fmse.components;

import com.fmse.util.Pair;

import java.io.Serializable;
import java.util.Objects;

public class PriorityQueueElement<E> implements Serializable {
    private final Pair<E,Integer> element;

    public PriorityQueueElement(Pair<E, Integer> element) {
        this.element = element;
    }

    public E getPQEValue() {
        return element.getElement0();
    }

    public Integer getPQEPriority() {
        return element.getElement1();
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
        return "element:" + element.getElement0() + ", priority:"+element.getElement1() ;
    }
}
