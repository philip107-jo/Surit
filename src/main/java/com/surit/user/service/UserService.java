package com.surit.user.service;

import java.io.IOException;

import com.surit.user.dto.UserDTO;

public interface UserService {

	// 회원 가입
	void sign(UserDTO user) throws IOException;
	
	// 아이디 중복체크
	boolean isUserIdCheck(String userId);
	
	// 로그인
	UserDTO login(String userId, String password);
	
	// 회원 탈퇴
	void withdraw(String userId);
	
	//회원 주소 가입
	void insertAddress(UserDTO address);

}
