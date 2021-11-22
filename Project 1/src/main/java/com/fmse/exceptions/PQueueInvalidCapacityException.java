package com.fmse.exceptions;

public class PQueueInvalidCapacityException extends Exception{
    public PQueueInvalidCapacityException(String errorMessage) {
        super(errorMessage);
    }
}
