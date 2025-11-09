package com.aditya.cicd2;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController("/")
public class Cicd2Controller {
  @GetMapping("/")
  public String hello() {
    return "Hello, CI/CD Pipeline!";
  }
}
