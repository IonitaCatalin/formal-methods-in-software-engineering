package com.fmse;

import com.fmse.components.PriorityQueue;
import com.fmse.exceptions.PQueueExceededCapacityException;
import com.fmse.exceptions.PQueueInvalidCapacityException;

import java.util.ArrayList;
import java.util.List;

public class Main {

    public static void main(String[] args) {
        System.out.println("________FmSE Priority Queue Playground________");


        try {
            PriorityQueue<List<Integer>> testPQ =  new PriorityQueue<>(12);
            List<Integer> firstTestList = new ArrayList<>();
            firstTestList.add(2);
            firstTestList.add(3);
            List<Integer> secondTestList = new ArrayList<>();
            secondTestList.add(5);
            secondTestList.add(10);

            testPQ.insert(firstTestList);
            testPQ.insertWithPriority(secondTestList,100);

            System.out.println(testPQ);

            System.out.println("Is PQ empty?: " + testPQ.isEmpty());
            System.out.println("Element with highest priority:" + testPQ.pullHighestPriorityElement());
            System.out.println();


        } catch (PQueueInvalidCapacityException | PQueueExceededCapacityException e) {
            e.printStackTrace();
        }

        System.out.println("______________________________________________");



    }
}
