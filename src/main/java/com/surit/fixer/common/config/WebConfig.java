package com.surit.fixer.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 업로드한 자격증 파일을 브라우저에서 볼 수 있게 해준다.
 *
 * 파일은 프로젝트 밖(예: C:/surit-upload/license)에 저장되기 때문에
 * 그냥 두면 /uploads/license/xxx.png 로 접근해도 404 가 난다.
 * "이 URL 로 오면 이 디스크 폴더를 뒤져라" 를 알려주는 게 이 클래스다.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Value("${file.upload-dir.license}")
	private String licenseUploadDir;

	@Value("${file.web-prefix.license}")
	private String licenseWebPrefix;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {

		// 설정값에 끝 슬래시가 있든 없든 똑같이 동작하도록 맞춰준다
		String urlPattern = trimEndSlash(licenseWebPrefix) + "/**";
		String location   = "file:" + trimEndSlash(licenseUploadDir.replace("\\", "/")) + "/";

		registry.addResourceHandler(urlPattern)
		        .addResourceLocations(location);
	}

	private String trimEndSlash(String s) {
		String v = (s == null) ? "" : s.trim();
		while (v.endsWith("/")) {
			v = v.substring(0, v.length() - 1);
		}
		return v;
	}
}
