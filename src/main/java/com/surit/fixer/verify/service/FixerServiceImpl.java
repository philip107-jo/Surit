package com.surit.fixer.verify.service;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.surit.common.model.dto.CommonCodeDTO;
import com.surit.common.model.mapper.CommonCodeMapper;
import com.surit.fixer.common.util.FileUploadUtil;
import com.surit.fixer.common.util.SavedFile;
import com.surit.fixer.verify.model.dto.FixerLicenseDTO;
import com.surit.fixer.verify.model.dto.FixerProfileDTO;
import com.surit.fixer.verify.model.dto.FixerVerifyRequest;
import com.surit.fixer.verify.model.mapper.FixerMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FixerServiceImpl implements FixerService {

	// APPROVAL_STATUS 에 CHECK 제약이 없으므로 자바 쪽에서 오타를 막는다
	public static final String PENDING  = "PENDING";
	public static final String APPROVED = "APPROVED";
	public static final String REJECTED = "REJECTED";

	private final FixerMapper      mapper;
	private final CommonCodeMapper codeMapper;
	private final FileUploadUtil   fileUploadUtil;

	@Value("${file.upload-dir.license}")
	private String licenseUploadDir;

	@Value("${file.web-prefix.license}")
	private String licenseWebPrefix;

	@Value("${file.upload-dir.photo}")
	private String photoUploadDir;

	@Value("${file.web-prefix.photo}")
	private String photoWebPrefix;


	@Override
	public List<CommonCodeDTO> getCategoryList() {
		return codeMapper.selectByGroup("CATEGORY");
	}

	@Override
	public List<CommonCodeDTO> getRegionList() {
		return codeMapper.selectByGroup("REGION");
	}

	@Override
<<<<<<< HEAD
	public FixerProfileDTO getMyProfile(long userNo) {
=======
	public FixerProfileDTO getMyProfile(Long userNo) {
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5
		return mapper.selectFixerProfile(userNo);
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
<<<<<<< HEAD
	public void applyVerify(long userNo, FixerVerifyRequest request) throws IOException {
=======
	public void applyVerify(Long userNo, FixerVerifyRequest request) throws IOException {
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5

		// ---------- 0) 입력값 검증 ----------
		validate(request);

		// ---------- 1) 신규인가 재신청인가 ----------
		FixerProfileDTO profile = mapper.selectFixerProfile(userNo);
		boolean isNew;

		if (profile == null) {
			isNew = true;
		} else if (PENDING.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException("이미 심사 중인 신청이 있습니다.");
		} else if (APPROVED.equals(profile.getApprovalStatus())) {
			throw new IllegalStateException("이미 인증된 기사입니다.");
		} else {
			isNew = false;   // REJECTED → 재신청
		}

		// ---------- 2) 재신청이면 기존 데이터 정리 ----------
		// DB 행을 지우기 전에 파일 경로를 미리 확보해둔다.
		// 지우고 나면 어떤 파일을 삭제해야 할지 알 수 없게 되니까.
		List<FixerLicenseDTO> oldLicenses = new ArrayList<>();
		String oldPhotoUrl = (profile != null) ? profile.getPhotoUrl() : null;

		if (!isNew) {
			oldLicenses = mapper.selectLicensesByUserNo(userNo);
			mapper.deleteLicensesByUserNo(userNo);
			mapper.deleteRegionsByUserNo(userNo);
			mapper.deleteCategoriesByUserNo(userNo);
		}

		// 이번 요청에서 디스크에 새로 만든 파일들. 아래에서 실패하면 이것만 치운다.
		String       newPhotoPath    = null;
		List<String> newLicensePaths = new ArrayList<>();

		try {
			// ---------- 3) 인증 사진 ----------
			// validate() 에서 이미 필수값인지 확인했으므로 여기서는 저장만 한다.
			// INSERT/UPDATE 보다 먼저 저장해야 photoUrl 을 프로필에 채울 수 있다.
			SavedFile savedPhoto = fileUploadUtil.save(request.getPhotoFile(), photoUploadDir, photoWebPrefix);
			newPhotoPath = savedPhoto.getPath();

			// ---------- 4) 프로필 저장 ----------
			FixerProfileDTO save = new FixerProfileDTO();
			save.setUserNo(userNo);
			save.setIntro(request.getIntro());
			save.setCareerYears(request.getCareerYears());
			save.setPhotoUrl(newPhotoPath);

			if (isNew) {
				mapper.insertFixerProfile(save);

			} else {
				// UPDATE 의 WHERE 에 APPROVAL_STATUS='REJECTED' 조건이 있어서,
				// 조회한 뒤 여기까지 오는 사이에 관리자가 승인했다면 0건이 된다.
				int updated = mapper.updateFixerProfile(save);
				if (updated == 0) {
					throw new IllegalStateException("신청 상태가 이미 변경되었습니다. 새로고침 후 다시 시도해주세요.");
				}
			}

			// ---------- 5) 활동 지역 ----------
			for (String regionCode : new LinkedHashSet<>(request.getRegionCodes())) {
				mapper.insertFixerRegion(userNo, regionCode);
			}

			// ---------- 6) 수리 분야 ----------
			for (String categoryCode : new LinkedHashSet<>(request.getCategoryCodes())) {
				mapper.insertFixerCategory(userNo, categoryCode);
			}

			// ---------- 7) 자격증 ----------
			int savedCount = saveLicenses(userNo, request, newLicensePaths);

			if (savedCount == 0) {
				// 자격증 없는 인증 신청은 심사할 근거가 없다.
				// 여기서 던지면 @Transactional 이 위의 INSERT 들을 전부 되돌린다.
				throw new IllegalStateException("자격증을 최소 1개 입력해주세요.");
			}

		} catch (RuntimeException | IOException e) {
			// @Transactional 이 DB 는 되돌려주지만 파일은 안 되돌린다.
			// 이번 요청에서 새로 만든 파일만 직접 치우고, 예외는 그대로 위로 던진다.
			if (newPhotoPath != null) {
				fileUploadUtil.delete(newPhotoPath, photoUploadDir);
			}
			for (String path : newLicensePaths) {
				fileUploadUtil.delete(path, licenseUploadDir);
			}
			throw e;
		}

		// ---------- 8) 옛 파일 삭제 (반드시 맨 마지막) ----------
		// DB 작업이 전부 끝난 뒤에 지운다. 중간에 예외가 나면 DB는 롤백되지만
		// 이미 지워버린 파일은 되살릴 방법이 없기 때문.
		fileUploadUtil.delete(oldPhotoUrl, photoUploadDir);
		for (FixerLicenseDTO old : oldLicenses) {
			fileUploadUtil.delete(old.getUploadUrl(), licenseUploadDir);
		}
	}


	/**
	 * 자격증 목록을 저장하고, 실제로 저장된 건수를 돌려준다.
	 * 새로 저장에 성공한 파일 경로는 savedPaths 에 계속 쌓아준다 —
	 * 실패 시 치우는 책임은 이제 applyVerify() 의 바깥 try/catch 가 진다
	 * (사진 파일과 함께 한 곳에서 정리하기 위함).
	 */
<<<<<<< HEAD
	private int saveLicenses(long userNo, FixerVerifyRequest request, List<String> savedPaths) throws IOException {
=======
	private int saveLicenses(Long userNo, FixerVerifyRequest request, List<String> savedPaths) throws IOException {
>>>>>>> 718f7fe4d56ce2dc5f6840629fa877ded9b6d8e5

		List<String>        names = request.getLicenseNames();
		List<String>        dates = request.getLicenseIssuedAts();
		List<MultipartFile> files = request.getLicenseFiles();

		if (names == null) {
			return 0;
		}

		int count = 0;

		for (int i = 0; i < names.size(); i++) {

			String name = names.get(i);

			// 이름이 빈 칸은 아예 입력을 안 한 것으로 본다
			if (name == null || name.isBlank()) {
				continue;
			}

			// ---- 검증을 파일 저장보다 먼저 끝낸다 ----
			// 저장한 뒤에 예외를 던지면 @Transactional 이 DB 는 되돌려도
			// 이미 디스크에 쓴 파일은 못 되돌려서 고아 파일이 남는다.
			LocalDate issuedAt = toDate(pick(dates, i));

			// ---- 검증 통과 후 저장 ----
			String uploadUrl = null;
			MultipartFile file = pickFile(files, i);

			if (file != null && !file.isEmpty()) {
				SavedFile saved = fileUploadUtil.save(file, licenseUploadDir, licenseWebPrefix);
				savedPaths.add(saved.getPath());
				uploadUrl = saved.getPath();
			}

			FixerLicenseDTO license = new FixerLicenseDTO();
			license.setUserNo(userNo);
			license.setLicenseName(name.trim());
			license.setUploadUrl(uploadUrl);
			license.setIssuedAt(issuedAt);

			mapper.insertFixerLicense(license);
			count++;
		}

		return count;
	}


	// ---------- 작은 도우미들 ----------

	private String pick(List<String> list, int i) {
		return (list != null && i < list.size()) ? list.get(i) : null;
	}

	private MultipartFile pickFile(List<MultipartFile> list, int i) {
		return (list != null && i < list.size()) ? list.get(i) : null;
	}

	/** "2023-05-10" → LocalDate, 비었으면 null */
	private LocalDate toDate(String s) {
		if (s == null || s.isBlank()) {
			return null;
		}
		try {
			return LocalDate.parse(s.trim());
		} catch (Exception e) {
			throw new IllegalStateException("발급일 형식이 올바르지 않습니다: " + s);
		}
	}

	private void validate(FixerVerifyRequest r) {

		// 사진은 필수 — DB 컬럼은 nullable 이라 여기서 막지 않으면 사진 없이도 신청이 된다.
		if (r.getPhotoFile() == null || r.getPhotoFile().isEmpty()) {
			throw new IllegalStateException("본인 확인용 사진을 첨부해주세요.");
		}
		if (r.getRegionCodes() == null || r.getRegionCodes().isEmpty()) {
			throw new IllegalStateException("활동 지역을 최소 1개 선택해주세요.");
		}
		if (r.getCategoryCodes() == null || r.getCategoryCodes().isEmpty()) {
			throw new IllegalStateException("수리 가능 분야를 최소 1개 선택해주세요.");
		}
		// Long 은 null 이 될 수 있으므로 반드시 null 검사를 먼저 한다.
		// 순서를 바꾸면 자동 언박싱에서 NullPointerException 이 난다.
		if (r.getCareerYears() == null || r.getCareerYears() < 0) {
			throw new IllegalStateException("경력(년)을 올바르게 입력해주세요.");
		}
		if (r.getCareerYears() > 70) {
			throw new IllegalStateException("경력이 너무 큽니다. 다시 확인해주세요.");
		}
		// DB 컬럼 길이를 넘으면 ORA-12899 라는 알아보기 힘든 에러가 난다.
		// 사용자에게는 읽을 수 있는 말로 먼저 알려준다.
		if (r.getIntro() != null && r.getIntro().length() > 4000) {
			throw new IllegalStateException("자기소개는 4000자를 넘을 수 없습니다.");
		}
	}
}