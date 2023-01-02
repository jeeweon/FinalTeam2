package com.appfoodiary.foodiary.restcontroller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.appfoodiary.foodiary.constant.SessionConstant;
import com.appfoodiary.foodiary.entity.BookmarkDto;
import com.appfoodiary.foodiary.entity.FollowDto;
import com.appfoodiary.foodiary.entity.LikeDto;
import com.appfoodiary.foodiary.entity.LikePointHistoryDto;
import com.appfoodiary.foodiary.entity.ReviewDto;
import com.appfoodiary.foodiary.repository.BookmarkDao;
import com.appfoodiary.foodiary.repository.FollowDao;
import com.appfoodiary.foodiary.repository.LikeDao;
import com.appfoodiary.foodiary.repository.ReviewDao;
import com.appfoodiary.foodiary.service.LevelPointService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@Tag(name = "like-rest-controller", description = "리뷰 액션 모")
@RequestMapping("/rest/review")
public class LikeRestController {
	
	@Autowired
	private LikeDao likeDao;
	@Autowired
	private BookmarkDao bookmarkDao;
	@Autowired
	private LevelPointService levelPointService;
	@Autowired
	private ReviewDao reviewDao;
	
	
	//좋아요 비동기 통신처리 백인드 
	@PostMapping("/like")
	@Operation(summary = "좋아요 설정/해제")
	public int like(
			@RequestParam int reviewNo,
			Model model,
			HttpSession session
			) {
		//우선 값을 넣어놓고 확인하겠다.
		//목표
		//(1): 프론트로부터 데이터를 받는다.
		//(2): 받은 데이터 값을 dto에 담에서 cert에 넣는다. 
		//(3)cert값이 있으면 지우고 없으면 넣는다.
		
		//session.removeAttribute(SessionConstant.NO);
		//session.setAttribute(SessionConstant.NO, 14);
		int memNo=(int)session.getAttribute(SessionConstant.NO);
		LikeDto dto =LikeDto.builder()
					.reviewNo(reviewNo)
					.memNo(memNo)
					.build();
		
		if(likeDao.cert(dto)) {
			//값이 존재 데이터를 삭제
			likeDao.delete(dto);
			//리뷰갯수 하나 지운다.
			likeDao.minus(reviewNo);
			
		}else {
			//값이 없음 데이터를 삽입
			likeDao.insert(dto);
			//리뷰갯수증가
			likeDao.plus(reviewNo);
		}
		return likeDao.count2(reviewNo);
	}
	
	
	//북마크 비동기통신 처리 앤드
	@PostMapping("/bookmark")
	@Operation(summary = "북마크 설정/해제")
	public boolean bookmark(
			@RequestParam int reviewNo,
			HttpSession session
			
			)
		{
		//session.removeAttribute(SessionConstant.NO);
		//session.setAttribute(SessionConstant.NO, 14);
		int memNo=(int)session.getAttribute(SessionConstant.NO);
		//dto에 값을 넣는다.
		BookmarkDto dto=BookmarkDto.builder()
					.reviewNo(reviewNo)
					.memNo(memNo)
					.build();
		if(bookmarkDao.cert(dto)) {
			//데이터 값이 있으면 지워라
			bookmarkDao.delete(dto);
			return false;
		}else {
			//데이터값이 없으면 추가해라
			bookmarkDao.insert(dto);
			return true;
		}
		
	}
	
	//like2
	@PostMapping("/like2")
	@Operation(summary = "좋아요 설정/해제 & 활동 점수용 기록 추가")
	public int like2(
			@RequestParam int reviewNo,
			HttpSession session
			) {
		int memNo=(int)session.getAttribute(SessionConstant.NO);
		LikeDto dto =LikeDto.builder()
					.reviewNo(reviewNo)
					.memNo(memNo)
					.build();
		if(likeDao.cert(dto)) {
			//삭제 
			likeDao.delete(dto);
			//리뷰갯수 하나 지운다.
			likeDao.minus(reviewNo);
			return 0;
		}else {
			//입력
			likeDao.insert(dto);
			//추가
			likeDao.plus(reviewNo);
			
			//좋아요 점수 내역 추가(내역에 없으면 내역 추가 후 점수 추가)
			Map<String,Integer> param = new HashMap<>();
			param.put("memNo", memNo);
			param.put("reviewNo", reviewNo);
			
			//점수 내역 조회
			LikePointHistoryDto likePointHistoryDto = likeDao.likePointHistory(param);
			ReviewDto writeDto = reviewDao.find(reviewNo);
			int writerNo = writeDto.getMemNo();
			
			//내역이 없으면 추가, 점수 추가
			if(likePointHistoryDto==null) {
				param.put("memNo", memNo);
				param.put("reviewNo", reviewNo);
				likeDao.addHisotry(param);
				levelPointService.likePoint(writerNo);
			}
			
			return 1;
		}
	}
	//리뷰 갯수 구하기 
	@PostMapping("/count")
	@Operation(summary = "좋아요 수")
	public int count(@RequestParam int reviewNo) 
	{
		return likeDao.count(reviewNo);
	}
}
