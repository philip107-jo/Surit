package com.surit.user.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.surit.user.model.dto.UserDTO;
@Mapper
public interface UserMapper {

	//회원가입 -> 데이터 추가
	int insertUser(UserDTO user);
	
	// 아이디 중복확인 -> 데이터 조회
	int countByUserId(String userId);
	
	// 아이디를 통한 회원 조회
	UserDTO selectByUserId(String userId);
	
	//아이디 기준을 회원 삭제 -> 데이터 삭제
	int deleteUser(String userId);
	/** 내 정보 수정 (이름/전화번호/이메일, 비밀번호는 값이 있을 때만) */
	int updateUser(UserDTO user);
}
