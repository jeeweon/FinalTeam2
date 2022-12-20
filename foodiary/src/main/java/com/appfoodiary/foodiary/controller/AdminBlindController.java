package com.appfoodiary.foodiary.controller;

import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.appfoodiary.foodiary.repository.AdminBlindDao;
import com.appfoodiary.foodiary.repository.ReviewDao;
import com.appfoodiary.foodiary.vo.BlindReplyContentsVO;
import com.appfoodiary.foodiary.vo.BlindReviewContentsVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/blind")
public class AdminBlindController {
	@Autowired
	private ReviewDao reviewDao;
	
	@Autowired
	private AdminBlindDao blindDao;
	
	@GetMapping("/review")
	public String reviewBlind(Model model, @RequestParam(required=false) String keyword) {
		model.addAttribute("list", blindDao.reviewBlindList(keyword));
		return "admin/blind-review";
	}
	
	@GetMapping("/review/detail")
	public String reviewBlindDetail(@RequestParam int reviewNo, Model model) {
		//리뷰정보
		BlindReviewContentsVO reviewVO = blindDao.selectOne(reviewNo);
		model.addAttribute("rvo", reviewVO);
		
		//첨부파일
		model.addAttribute("attaches", reviewDao.findReviewAttachViewList(reviewNo));
		
		//신고내역
		Date reviewReportStart = blindDao.reviewReportStart(reviewNo);
		
		Map<String, Object> history = new HashMap<>();
		history.put("reviewNo", reviewNo);
		history.put("reportStartTime", reviewReportStart);
		model.addAttribute("history", blindDao.reviewReportHistory(history));
		return "admin/blind-review-detail";
	}
	
	@GetMapping("/reply")
	public String replyBlind(Model model, @RequestParam(required=false) String keyword) {
		model.addAttribute("list", blindDao.replyBlindList(keyword));
		return "admin/blind-reply";
	}
	
	@GetMapping("/reply/detail")
	public String replyBlindDetail(@RequestParam int replyNo, Model model) {
		//댓글정보
		BlindReplyContentsVO replyVO = blindDao.pickOne(replyNo);
		model.addAttribute("rvo", replyVO);
		
		//신고내역
		Date replyReportStart = blindDao.replyReportStart(replyNo);
		
		Map<String, Object> history = new HashMap<>();
		history.put("replyNo", replyNo);
		history.put("reportStartTime", replyReportStart);
		model.addAttribute("history", blindDao.replyReportHistory(history));
		return "admin/blind-reply-detail";
	}
}
