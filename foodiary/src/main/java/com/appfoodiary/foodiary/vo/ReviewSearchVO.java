package com.appfoodiary.foodiary.vo;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReviewSearchVO {
	private int reviewNo;
	private int memNo;
	private String memNick;
	private String memLevel;
	private String reviewContent;
	@JsonFormat(shape= JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss", timezone="Asia/Seoul")
	private Date reviewWriteTime;
	private float starScore;
	private String reviewPlace;
	private String reviewAddress;
	private int reviewReportCnt;
	private String interestArea;
	private int likeCnt;
	private int replyCnt;
	private int memReviewCnt;
	private int imgCnt;
	private boolean likeCheck; //특정회원이 리뷰에 좋아요했는지 여부
	private boolean bookmarkCheck; //특정회원이 리뷰를 북마크했는지 여부
	private String keyword; //검색어
	private int attachNo; //프로필 이미지 첨부파일번호
}
