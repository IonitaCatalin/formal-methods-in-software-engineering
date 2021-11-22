package com.fmse.exceptions;

public class PQueueExceededCapacityException extends Exception{
    public PQueueExceededCapacityException(String errorMessage) {
        super(errorMessage);
    }
}
