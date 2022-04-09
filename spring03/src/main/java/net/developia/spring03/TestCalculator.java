package net.developia.spring03;

import org.springframework.stereotype.Controller;

@Controller
public class TestCalculator {
	public int add(int a, int b) {
		return a + b;
	}
}
