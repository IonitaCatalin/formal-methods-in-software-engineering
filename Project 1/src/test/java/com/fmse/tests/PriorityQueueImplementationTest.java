package com.fmse.tests;

import com.fmse.components.PriorityQueue;
import com.fmse.components.PriorityQueueElement;
import com.fmse.exceptions.PQueueExceededCapacityException;
import com.fmse.exceptions.PQueueInvalidCapacityException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

public class PriorityQueueImplementationTest {

    private PriorityQueue<Integer> queue;
    private final Integer capacity = 20;


    @BeforeEach
    void setUp() {
        try {
            queue = new PriorityQueue<>(capacity);
        } catch (PQueueInvalidCapacityException e) {
            e.printStackTrace();
        }
    }

    @Test
    @DisplayName("PriorityQueue should be empty on initialization")
    void testEmptyPQueueInit() {
        assert(queue.getElements().size() == 0);
    }

    @Test
    @DisplayName("PriorityQueue initialization with zero capacity should throw and error!")
    void testZeroCapacityPQueueInit() {
        Throwable e = null;
        try {
            PriorityQueue<Integer> testPQ = new PriorityQueue<>(0);
        } catch (Throwable exception) {
            e = exception;
        }
        assert(e instanceof PQueueInvalidCapacityException);
    }

    @Test
    @DisplayName("PriorityQueue initialization with negative capacity should throw an error!")
    void testNegativeCapacityPQueueInit() {
        Throwable e = null;
        try {
            PriorityQueue<Integer> testPQ = new PriorityQueue<>(-2);
        } catch (Throwable exception) {
            e = exception;
        }
        assert(e instanceof PQueueInvalidCapacityException);
    }

    @Test
    @DisplayName("PriorityQueue.isEmpty() should return true for empty PriorityQueue!")
    void testIsEmptyMethodForEmptyPQueue() {
        assert(queue.isEmpty());
    }


    @Test
    @DisplayName("PriorityQueue.isEmpty() should return false for empty PriorityQueue!")
    void testIsEmptyMethodForFilledPQueue() {
        try {

            queue.insert(2);
            assert(!queue.isEmpty());

        } catch (PQueueExceededCapacityException e) {
            e.printStackTrace();
        }
    }

    @Test
    @DisplayName("PriorityQueue.getCapacity() should return current capacity!")
    void testGetCapacityMethod() {
        assert(queue.getCapacity() == capacity);
    }

    @Test
    @DisplayName("PriorityQueue.insert() should insert element with highest priority in queue!")
    void testInsertMethod() {
        try {
            Integer sizeBefore = queue.getSize();
            queue.insert(2);
            assert(queue.getHighestPriority() == 0);
            queue.insert(3);
            Integer sizeAfter = queue.getSize();

            assert(queue.getHighestPriority() == 1);
            assert(sizeBefore < sizeAfter);

        } catch (PQueueExceededCapacityException e) {
            e.printStackTrace();
        }
    }

    @Test
    @DisplayName("PriorityQueue.insertWithPriority() should insert element with a certain priority!")
    void testInsertWithPriorityMethod() {
        try {

            Integer size = queue.getSize();
            queue.insertWithPriority(15,9999);
            assert(queue.getHighestPriority() == 9999);
            assert(queue.getSize() == size + 1);

        } catch(PQueueExceededCapacityException e) {
            e.printStackTrace();
        }
    }

    @Test
    @DisplayName("PriorityQueue.getHighestPriority() should return the highest priority currently in the queue!")
    void testHighestPriority() {
        try {
            queue.insert(15);
            assert(queue.getHighestPriority() == 0);

        } catch (PQueueExceededCapacityException e) {
            e.printStackTrace();
        }

    }

    @Test
    @DisplayName("PriorityQueue.pullHighestElement() should return null for empty queue!")
    void testPullHighestPriority() {
        assert(queue.pullHighestPriorityElement() == null);
    }

    @Test
    @DisplayName("PriorityQueue.insert() should throw error when capacity is exceeded!")
    void testInsertThrowsCapacityException() {
        Throwable e = null;
        try {
            PriorityQueue<Integer> testPQ = new PriorityQueue<>(0);
            testPQ.insert(2);
        } catch (Throwable exception) {
            e = exception;
        }
        assert(e instanceof PQueueInvalidCapacityException);
    }

    @Test
    @DisplayName("PriorityQueue.insertWithPriority() should throw error when capacity is exceeded!")
    void testInsertWithPriorityThrowsCapacityException() {
        Throwable e = null;
        try {
            PriorityQueue<Integer> testPQ = new PriorityQueue<>(0);
            testPQ.insertWithPriority(2,12);
        } catch (Throwable exception) {
            e = exception;
        }
        assert(e instanceof PQueueInvalidCapacityException);
    }







}
