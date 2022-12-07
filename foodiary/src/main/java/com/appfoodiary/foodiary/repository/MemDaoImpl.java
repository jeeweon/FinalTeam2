package com.appfoodiary.foodiary.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

import com.appfoodiary.foodiary.entity.MemDto;

@Repository
public class MemDaoImpl implements MemDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Override
	public int sequence() {
		return sqlSession.selectOne("mem.sequence");
	}
	@Override
	public void join(MemDto memDto) {
		String pw = memDto.getMemPw();
		String enc = encoder.encode(pw);
		memDto.setMemPw(enc);
		sqlSession.insert("mem.join",memDto);
	}
	
	@Override
	public MemDto selectOne(int memNo) {
		return sqlSession.selectOne("mem.one",memNo);
	}
	
	@Override
	public MemDto findByEmail(String memEmail) {
		return sqlSession.selectOne("mem.email",memEmail);
	}
	
	@Override
	public MemDto findByNick(String memNick) {
		return sqlSession.selectOne("mem.nick", memNick);
	}
	
	@Override
	public boolean login(MemDto memDto) {
		//memDto : 암호화 되지 않은 사용자 입력 정보, findDto : 암호화된 DB 정보
		
		MemDto findDto = sqlSession.selectOne("mem.email",memDto.getMemEmail());
		if(findDto==null) return false;
		boolean judge = encoder.matches(memDto.getMemPw(), findDto.getMemPw());
		return judge;
	}

}
