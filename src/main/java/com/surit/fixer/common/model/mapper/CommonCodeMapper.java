package com.surit.fixer.common.model.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.surit.fixer.common.model.dto.CommonCodeDTO;

@Mapper
public interface CommonCodeMapper {

	/** 사용중(Y)인 코드를 그룹별로 조회. CATEGORY / REGION / STATUS */
	List<CommonCodeDTO> selectByGroup(String codeGroup);
}
