package com.appfoodiary.foodiary.repository;

import java.util.List;

import com.appfoodiary.foodiary.entity.AttachDto;
import com.appfoodiary.foodiary.entity.ReviewAttachDto;
import com.appfoodiary.foodiary.entity.ReviewDto;

public interface ReviewDao {
	//리뷰
	int newReviewNo();
	List<ReviewDto> list();
	void write(ReviewDto dto);
	ReviewDto find(int reviewNo);
	boolean edit(ReviewDto dto);
	boolean delete(int reviewNo);
	
	//리뷰 첨부파일
	void addReviewAttach(ReviewAttachDto dto);
	List<AttachDto> findReviewAttachViewList(int reviewNo);
}
