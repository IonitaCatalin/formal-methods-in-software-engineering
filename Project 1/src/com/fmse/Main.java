package com.fmse;

import com.fmse.components.PriorityQueue;

public class Main {

    public static void main(String[] args) {
	    System.out.println("________FmSE Priority Queue Playground________");

        PriorityQueue<Integer> testPQ = new PriorityQueue<>();

        testPQ.push(2);
        testPQ.push(25);

        System.out.println(testPQ.toString());

        System.out.println("______________________________________________");

    }
}
