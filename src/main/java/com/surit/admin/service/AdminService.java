package com.surit.admin.service;

public interface AdminService {
	// 회원 / 기사 페이지
	
	// 승인 기능
	int apporved (int fixerId);
	// 반려 기능
	int rejectFixer (int fixerId);
	// 차단 기능
	int blockFixerAccount(UserDTO);
	
	
	
	 

}
