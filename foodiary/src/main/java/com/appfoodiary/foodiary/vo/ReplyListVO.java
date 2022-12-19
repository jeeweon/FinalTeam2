package com.appfoodiary.foodiary.vo;

import java.sql.Date;

import com.appfoodiary.foodiary.entity.ReplyDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReplyListVO {
	private int replyNo;
	private int reviewNo;
	private int memNo;
	private String replyContent;
	private Date replyWriteTime;
	private int replyReportCnt;
	private String memNick;
	private String memLevel;
	private int attachNo;
}
