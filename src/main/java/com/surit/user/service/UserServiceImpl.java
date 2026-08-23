package com.surit.user.service;

import java.io.IOException;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.surit.user.dto.UserDTO;
import com.surit.user.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
	
	//MemberMapper DI
	private final UserMapper mapper;
	//PasswordEncoder DI
	private final PasswordEncoder passwordencoder;
	
	@Override
	public void sign(UserDTO user) throws IOException {
	if(isUserIdCheck(user.getUserId())) {
		throw new IllegalStateException("이미 사용중인 아이디입니다.");
	}
		//비밀번호 암호화 처리 -> BCryptPasswordEncoder => SecurityConfig 설정
		//암호화 
		String encodePwd = passwordencoder.encode(user.getPassword());
		user.setPassword(encodePwd);//비밀번호 필드를 암호화된 값으로 변경
		mapper.insertUser(user);
	}
	@Override
	public boolean isUserIdCheck(String userId) {
		// TODO Auto-generated method stub
		return mapper.countByUserId(userId) ==1;
	}

	@Override
	public UserDTO login(String userId, String userPwd) throws IllegalStateException {
		//아이디 기준으로 회원 정보 조회
		UserDTO user = mapper.selectByUserID(userId);
		//조회된 정보 중 비밀번호(암호문)와 전달된 비밀번호(평문)가 일치하는 지 확인
		//암호화된 비밀번호 = DB에서 조회된 값(member.etMemberPwd())
		//평문 비밀번호 => 전달된 값 (memberPwd)
		
		//passwordEncoder.matches(평문, 암호문)=> 동일한 경우 true, 그렇지 않으면 false 반환
		if(user == null || passwordencoder.matches(userPwd, user.getPassword())) {
			throw new IllegalStateException("아이디 또는 비밀번호가 일치하지 않습니다.");
		}
		//회원 정보 반환
		return user;
	}

	@Override
	public void withdraw(String userId) {
		//삭제 전 아이디 기준으로 조회
		UserDTO user = mapper.selectByUserID(userId);
		// DB에서 해당 사용자 정보 삭제 (Mapper)
		mapper.deleteUser(userId);
		//프로필 이미지가 있는 경우 서버에서 이미지 파일 삭제 (FileUploadUtil)
		
		
	}
	@Override
	public void insertAddress(UserDTO address) {
		mapper.insertUser(address);
		
	}
	

}
