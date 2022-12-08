package com.appfoodiary.foodiary.repository;

import com.appfoodiary.foodiary.entity.MemDto;

public interface MemDao {
	
	//가입
	int sequence();
	void join(MemDto memDto);
	
	//단일 조회
	MemDto selectOne(int memNo);
	MemDto findByNick(String memNick);
	MemDto findByEmail(String memEmail);
	
	//로그인
	boolean login(MemDto memDto);
}
