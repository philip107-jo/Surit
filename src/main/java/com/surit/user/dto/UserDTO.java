package com.surit.user.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
	
public class UserDTO {
	private String userId;
	private String userPwd;
	private String userName;
	private String userPnumber;
	private String userEmail;
	private String userRole;
	private String accountStatus;
	private int isWithdrawn;
	private Timestamp withdrawnAt;
	private Timestamp userCreatedAt;
	
	 private int addressId;
	 private String addressName;
	 private String zipcode;
	 private String addressBasic;
	 private String addressDetail;
	 private int isDefault; 
}
