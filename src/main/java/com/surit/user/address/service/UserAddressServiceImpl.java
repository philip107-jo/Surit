
// ==========================================================
package com.surit.user.address.service;
 
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.surit.user.mapper.UserAddressMapper;
import com.surit.user.model.dto.UserAddressDTO;

import lombok.RequiredArgsConstructor;
 
@Service
@RequiredArgsConstructor
public class UserAddressServiceImpl implements UserAddressService {
 
    private final UserAddressMapper mapper;
 
    @Override
    @Transactional(readOnly = true)
    public List<UserAddressDTO> getAddressesByUserNo(Long userNo) {
        return mapper.selectAddressesByUserNo(userNo);
    }
 
    @Override
    @Transactional(readOnly = true)
    public UserAddressDTO getAddress(Long addressId, Long userNo) {
        return mapper.selectAddressById(addressId, userNo);
    }
 
    @Override
    @Transactional
    public void insertAddress(UserAddressDTO address) {
 
        // 기본 주소로 등록하려는 거면, 기존 기본 주소를 먼저 해제
        if ("Y".equals(address.getIsDefault())) {
            mapper.clearDefaultByUserNo(address.getUserNo());
        }
 
        mapper.insertAddress(address);
    }
 
    @Override
    @Transactional
    public void updateAddress(UserAddressDTO address) {
 
        // 내 주소가 맞는지 확인
        UserAddressDTO existing = mapper.selectAddressById(address.getAddressId(), address.getUserNo());
        if (existing == null) {
            throw new IllegalStateException("존재하지 않거나 접근할 수 없는 주소입니다.");
        }
 
        if ("Y".equals(address.getIsDefault())) {
            mapper.clearDefaultByUserNo(address.getUserNo());
        }
 
        mapper.updateAddress(address);
    }
 
    @Override
    @Transactional
    public void deleteAddress(Long addressId, Long userNo) {
 
        UserAddressDTO existing = mapper.selectAddressById(addressId, userNo);
        if (existing == null) {
            throw new IllegalStateException("존재하지 않거나 접근할 수 없는 주소입니다.");
        }
 
        mapper.deleteAddress(addressId, userNo);
    }
}