package com.appfoodiary.foodiary.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.appfoodiary.foodiary.constant.SessionConstant;
import com.appfoodiary.foodiary.entity.MemDto;
import com.appfoodiary.foodiary.repository.MemDao;
import com.appfoodiary.foodiary.service.EmailService;

@Controller
@RequestMapping("/mem")
public class MemController {
	
	@Autowired
	private MemDao memDao;
	
	@Autowired
	private EmailService emailService;
	
	@GetMapping("/join")
	public String join() {
		return "mem/join";
	}
	
	@PostMapping("/join")
	public String join(@ModelAttribute MemDto memDto) {
		int memNo = memDao.sequence();
		memDao.join(MemDto.builder()
				.memNo(memNo)
				.memEmail(memDto.getMemEmail())
				.memPw(memDto.getMemPw())
				.memNick(memDto.getMemNick())
				.memBirth(memDto.getMemBirth())
			.build());
		return "redirect:join_finish";
	}
	
	@RequestMapping("/join_finish")
	public String joinFinish() {
		return "mem/join-finish";
	}
	
	@GetMapping("/login")
	public String login() {
		return "mem/login";
	}
	
	@PostMapping("/login")
	public String login(
			@ModelAttribute MemDto inputDto,
			HttpSession session) {
				
		boolean judge = memDao.login(inputDto);
		MemDto findDto = memDao.findByEmail(inputDto.getMemEmail());
		
		if(judge){
			session.setAttribute(SessionConstant.NO, findDto.getMemNo());
			session.setAttribute(SessionConstant.NICK, findDto.getMemNick());
			
			return "redirect:/home";
		}
		else {
			return "redirect:login?error";
		}	
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		//세션에서 loginNo, loginNick 데이터 삭제
		session.removeAttribute(SessionConstant.NO);
		session.removeAttribute(SessionConstant.NICK);
		return "redirect:/home";
	}
	

}
