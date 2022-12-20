package com.appfoodiary.foodiary.repository;

import java.util.List;

import com.appfoodiary.foodiary.entity.NoticeEmailDto;
import com.appfoodiary.foodiary.vo.ListSearchVO;
import com.appfoodiary.foodiary.vo.MemEmailVO;

public interface AdminEmailDao {
	
	//메일 번호 시퀀스
	int emailSequence();
	//메일 발송
	void insertMail(NoticeEmailDto noticeEmailDto);
	//메일 상세 조회
	NoticeEmailDto selectOne(int emailNo);
	//메일 목록 조회
	List<NoticeEmailDto> selectList(ListSearchVO vo);
	List<NoticeEmailDto> list(ListSearchVO vo);
	List<NoticeEmailDto> search(ListSearchVO vo);
	//회원 메일 목록
	List<MemEmailVO> emailList();
	//페이지네이션 게시물 카운트
	int count(ListSearchVO vo);
	int listCount(ListSearchVO vo);
	int searchCount(ListSearchVO vo);
}
