package com.appfoodiary.foodiary.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/home")
public class HomeController {
	
	@GetMapping("")
	public String home() {
		return "home/home";
	}
	
	@GetMapping("/area/interest")
	public String areaInterest(Model model) {
		return "home/area-interest";
	}
}