package com.example;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculatorTest {

    @Test
    void shouldAddTwoNumbers() {

        Calculator calculator = new Calculator();

        int result = calculator.add(2, 3);

        assertEquals(5, result);
    }

    @Test
    void shouldSubtractTwoNumbers() {

        Calculator calculator = new Calculator();

        int result = calculator.subtract(10, 4);

        assertEquals(6, result);
    }
}
