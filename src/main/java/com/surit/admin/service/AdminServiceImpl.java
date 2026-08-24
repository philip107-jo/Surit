package com.surit.admin.service;

import org.springframework.stereotype.Service;

import com.surit.admin.model.mapper.MemberManagementMapper;

@Service
public class AdminServiceImpl implements AdminService {
	private final MemberManagementMapper memberManagementMapper;
	
	// 회원 / 기사 페이지
	
		// 승인 기능
		int apporved (int fixerId) {
			
		}
		
		// 반려 기능
		int rejectFixer (int fixerId) {
			
		}
		
		// 차단 기능
		int blockFixerAccount(UserDTO) {
			
		}
		
	

}
