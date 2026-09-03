

Readme · MD
# 수릿 (Surit)
 
> 출장 수리 중개 플랫폼 — 고객이 증상만 올리면 주변 기사가 직접 견적을 보내고, 고객이 골라 매칭됩니다.
 
수수료 없는 무상 중개이고, 수리비는 **작업이 끝난 뒤 현장에서 직접 결제**합니다. 플랫폼은 접수·매칭·소통까지만 담당합니다.
 
```
접수 등록 → 기사가 견적 전송 → 고객이 견적 수락 → 실시간 채팅으로 일정 협의
        → 방문·수리 → 기사가 완료 처리 → 고객이 리뷰 작성
```
 
---
 
## 기술 스택
 
| 구분 | 사용 기술 |
|---|---|
| 언어 · 빌드 | Java 17, Maven |
| 프레임워크 | Spring Boot 4.1.0, Spring Security (비밀번호 암호화 용도) |
| 화면 | JSP + JSTL (Jakarta), 순수 CSS · JavaScript (프레임워크 미사용) |
| 데이터 접근 | MyBatis (`mybatis-spring-boot-starter`) |
| DB | Oracle (`ojdbc11`) |
| 실시간 통신 | WebSocket + STOMP + SockJS |
| 서버 | 내장 Tomcat (`tomcat-embed-jasper`) |
 
---
 
## 실행 방법
 
### 1. 설정 파일 만들기
 
`src/main/resources/application.properties` 는 **저장소에 올라가지 않습니다** (`.gitignore` 에 `*.properties`). 같은 폴더의 `application.properties.example` 을 복사해서 채워 넣으세요.
 
```properties
server.port=8800
 
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
 
spring.datasource.url=jdbc:oracle:thin:@<호스트>:<포트>:<SID>
spring.datasource.username=<계정>
spring.datasource.password=<비밀번호>
spring.datasource.driver-class-name=oracle.jdbc.driver.OracleDriver
 
mybatis.mapper-locations=classpath:mappers/**/*.xml
mybatis.type-aliases-package=com.surit
mybatis.configuration.jdbc-type-for-null=NULL
mybatis.configuration.map-underscore-to-camel-case=true
 
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=50MB
 
file.upload-dir.license=uploads/license
file.web-prefix.license=/uploads/license
file.upload-dir.photo=uploads/photo
file.web-prefix.photo=/uploads/photo
 
# 채팅 메시지 암호화 키 (Base64, 32바이트)
surit.chat.crypto.key=<Base64 32바이트 키>
surit.chat.crypto.migrate-on-start=false
 
# 세션 만료
server.servlet.session.timeout=30m
```
 
### 2. 실행
 
```bash
./mvnw spring-boot:run        # macOS · Linux
mvnw.cmd spring-boot:run      # Windows
```
 
브라우저에서 `http://localhost:8800` 으로 접속합니다.
 
### 3. 최초 1회 필요한 데이터
 
DB를 새로 만들었다면 아래 두 가지가 있어야 정상 동작합니다.
 
**고객센터 계정** — 1:1 문의 기능이 이 계정 자격으로 대화에 참여합니다.
 
```sql
INSERT INTO USERS (USER_ID, EMAIL, PASSWORD, NAME, PHONE, USER_ROLE)
VALUES ('surit_support', 'support@surit.kr', 'NO_LOGIN',
        '수릿 고객센터', '00000000000', 'USER');
COMMIT;
```
 
> 비밀번호가 BCrypt 형식이 아니라서 이 계정으로는 로그인할 수 없습니다. 의도한 설정입니다.
 
**공통 코드** — 상태·카테고리·지역·문의유형이 모두 `COMMON_CODE` 에서 나옵니다.
 
```sql
SELECT CODE_GROUP, COUNT(*) FROM COMMON_CODE GROUP BY CODE_GROUP;
-- STATUS / CATEGORY / REGION / INQUIRY_TYPE / VISIT_TIME 네 그룹 이상이 있어야 합니다
```
 
---
 
## 프로젝트 구조
 
```
src/main/java/com/surit/
├── SuritApplication.java
├── common/
│   ├── config/SecurityConfig.java        비밀번호 인코더 · 필터체인
│   ├── model/                            COMMON_CODE 공통 코드
│   └── request/                          수리 접수 (고객·기사 공용)
├── user/                                 고객 : 가입 · 로그인 · 마이페이지 · 주소 · 리뷰
│   ├── controller/  service/  mapper/  model/
│   ├── address/                          주소 관리
│   └── review/                           리뷰 작성 · 조회
├── fixer/                                기사
│   ├── verify/                           기사 인증 (자격증 제출 · 심사)
│   ├── estimate/                         견적 작성 · 전송
│   ├── job/                              내 작업 (수주 건)
│   ├── mypage/                           분야 · 지역 설정
│   ├── block/                            고객 개인 차단
│   ├── payment/                          작업 완료 · 사진
│   ├── booking/                          예약 상세 (미완성)
│   └── common/                           FixerGuard · 파일 업로드 · 예외 처리
├── chat/                                 실시간 채팅 · 1:1 문의
│   ├── config/WebSocketConfig.java       STOMP 엔드포인트
│   ├── controller/                       HTTP 진입 + STOMP 메시지 수신
│   ├── util/                             AES-GCM 암호화 · TypeHandler
│   └── service/  mapper/  dto/
├── admin/                                관리자
│   ├── controller/                       로그인 · 접수 · 회원 · 리뷰 · 블랙리스트
│   ├── interceptor/AdminInterceptor.java 관리자 인증 문지기
│   ├── scheduler/SanctionScheduler.java  정지 자동 해제
│   └── service/  model/
└── interceptor/FixerInterceptor.java
 
src/main/resources/
├── mappers/                              MyBatis XML 18개
└── static/{css,js}                       style.css · pages.css · common.js
 
src/main/webapp/WEB-INF/views/
├── common/                               header · footer · admin-header · admin-footer
├── home/  user/  request/  fixer/  chat/  admin/
```
 
---
 
## 주요 기능
 
### 고객
 
| 기능 | 설명 |
|---|---|
| 회원가입 · 로그인 | 아이디 · 이메일 중복 확인, BCrypt 비밀번호 저장 |
| 수리 접수 | 분야 선택 · 증상 작성 · 사진 최대 5장 · 방문 일정 · 긴급 접수 |
| 주소 관리 | 최대 3개, 기본 주소 지정, 접수 화면에서도 추가 · 수정 · 삭제 |
| 견적 비교 | 받은 견적을 금액 · 소요시간 · 기사 평점으로 비교 후 수락 |
| 실시간 채팅 | 배정된 기사와 1:1 대화 (전화번호 비공개) |
| 리뷰 | 수리 완료 건에 별점 · 후기 작성 |
| 1:1 문의 | 고객센터와 채팅으로 문의 |
 
### 기사
 
| 기능 | 설명 |
|---|---|
| 기사 인증 | 자격증 · 본인 확인 사진 제출 → 관리자 승인 후 활동 가능 |
| 분야 · 지역 설정 | 이 설정과 겹치는 접수만 일감 목록에 노출 |
| 일감 찾기 | 아직 기사가 정해지지 않은 접수 목록 (분야 · 지역 · 차단 고객 필터) |
| 견적 전송 | 예상 금액 · 소요시간 · 설명 |
| 내 작업 | 고객이 내 견적을 선택한 건만 표시, 수리 완료 처리 |
| 고객 차단 | 특정 고객의 접수를 내 목록에서 숨김 |
 
### 관리자
 
| 기능 | 설명 |
|---|---|
| 관리자 로그인 | `ADMIN` 테이블 기반, 일반 회원과 완전히 분리 |
| 접수 현황 | 전체 접수 목록 · 상태 필터 · 검색 · 페이징 |
| 회원 · 기사 관리 | 목록 · 상세, 기사 자격증 확인 후 승인 · 반려 |
| 리뷰 관리 | 리뷰 원문 열람 (관리자만), 평점 하위 기사에게 경고 |
| 블랙리스트 | 경고 누적 기사 정지 (기간 · 영구), 해제, 제재 이력 |
| 문의 응대 | 고객 1:1 문의에 답변, 답변 대기 · 완료 필터 |
 
---
 
## 상태값
 
접수 상태는 `COMMON_CODE` 의 `STATUS` 그룹에서 읽어옵니다.
 
| 코드 | 이름 | 언제 |
|---|---|---|
| `REQ_01` | 접수대기 | 접수 등록 직후 |
| `REQ_02` | 견적중 | 기사가 견적을 보냄 |
| `REQ_03` | 매칭완료 | 고객이 견적을 수락 |
| `REQ_04` | 수리완료 | 기사가 완료 처리 |
| `REQ_05` | 취소 | 고객이 취소 (`REQ_01` · `REQ_02` · `REQ_99` 에서만) |
| `REQ_99` | 긴급접수 | 접수할 때 **긴급**을 선택한 경우 `REQ_01` 대신 들어감 |
 
> `REQ_99` 는 진행 단계가 아니라 **긴급 여부 표시**입니다. 그래서 견적이 들어와도 `REQ_02` 로 바뀌지 않습니다 — 긴급 표시가 지워지면 기사 목록에서 급한 건을 구분할 수 없기 때문입니다. 대신 견적 수락 · 취소 · 수정은 `REQ_01` · `REQ_02` · `REQ_99` 세 상태를 모두 허용합니다.
 
**견적** `ESTIMATES.STATUS` : `PENDING` 대기 → `SELECTED` 채택 / `REJECTED` 반려
**제재** `SANCTION.SANCTION_TYPE` : `WARNING` 경고 · `SUSPEND` 기간 정지 · `PERMANENT` 영구 정지
 
---
 
## DB 테이블
 
```
COMMON_CODE                                 모든 코드값의 출처
USERS · USER_ADDRESS · ADMIN                회원 · 주소 · 관리자
FIXER_PROFILE · FIXER_CATEGORY
FIXER_REGION · FIXER_LICENSE · FIXER_BLOCK  기사 프로필 · 분야 · 지역 · 자격증 · 차단
REPAIR_REQUESTS · REPAIR_PHOTO              접수 · 첨부 사진
ESTIMATES                                   견적
PAYMENT · PAYMENT_DETAIL                    결제 기록 (현장 결제 내역)
REVIEW                                      리뷰
CHAT_ROOM · CHAT_MESSAGE                    채팅방 · 메시지
SANCTION                                    제재 이력 (경고 · 정지)
INQUIRY                                     문의
```
 
`REPAIR_REQUESTS` 에는 배정 기사 컬럼이 없습니다. 담당 기사는 `ESTIMATES.STATUS = 'SELECTED'` 로 역추적합니다.
 
---
 
## 구현 포인트
 
### 실시간 채팅 (WebSocket + STOMP)
 
메시지를 보내면 새로고침 없이 상대 화면에 나타납니다.
 
```
브라우저 → SockJS → /pub/chat/{roomId} → ChatStompController
        → DB 저장 → /sub/chat/room/{roomId} 구독자에게 브로드캐스트
```
 
보낸 사람은 클라이언트가 보낸 값이 아니라 **세션에 심어둔 값**으로 판단합니다. 그래서 남의 이름으로 메시지를 보낼 수 없습니다.
 
### 메시지 암호화 (AES-256-GCM)
 
`CHAT_MESSAGE.CONTENT` 만 암호화해서 저장합니다.
 
```
enc:v1:BASE64( IV(12바이트) + 암호문 + 검증태그(16바이트) )
```
 
MyBatis `TypeHandler` 를 그 컬럼 하나에만 걸어서, Service · Controller · JSP 는 평문을 다루는 그대로 두었습니다. GCM 을 쓴 이유는 DB에서 값을 한 글자라도 고치면 복호화가 실패하기 때문입니다.
 
> `mybatis.type-handlers-package` 는 **설정하면 안 됩니다.** 모든 String 컬럼이 암호화됩니다.
 
### 견적 수락 트랜잭션
 
고객의 클릭 한 번에 네 가지가 한 덩어리로 처리됩니다.
 
1. 내 접수가 맞는지 확인
2. 고른 견적 `PENDING` → `SELECTED`
3. 나머지 견적 → `REJECTED`
4. 접수 → `REQ_03`
조건을 SQL 의 `WHERE` 절에 넣어서, 이미 처리된 건이면 0건이 수정되고 그러면 예외를 던져 전부 롤백합니다. 자바에서 확인하고 수정하는 방식은 그 사이에 다른 요청이 끼어들 수 있습니다.
 
### 관리자 인증
 
`/admin/**` 전체를 `AdminInterceptor` 가 지킵니다. 로그인이 없으면 원래 가려던 주소를 `returnUri` 에 담아 로그인 화면으로 보내고, 로그인 후 그 자리로 되돌립니다. `returnUri` 는 `/admin` 으로 시작하는지 등 네 가지를 검사해 외부 사이트로 유도되는 것을 막습니다.
 
### 제재 자동 해제
 
`SanctionScheduler` 가 1시간마다 아래 한 문장을 실행합니다.
 
```sql
UPDATE USERS SET STATUS = 'ACTIVE'
 WHERE STATUS = 'SUSPEND'
   AND NOT EXISTS (해당 회원의 유효한 정지)
```
 
몇 번 실행해도 결과가 같고, 정지가 겹쳐 있으면 마지막 것이 끝날 때까지 풀리지 않습니다. 관리자가 수동으로 해제할 때도 같은 쿼리를 씁니다.
 
### XSS 방어
 
사람이 입력한 값은 화면에서 `<c:out>` · `fn:escapeXml` 로 감쌉니다. 채팅은 JavaScript 가 메시지를 그릴 때 `innerHTML` 대신 `textContent` 만 씁니다.
 
---
 
## 알려진 제한사항
 
- **업로드 파일은 서버를 실행한 PC 에만 저장됩니다.** `uploads/` 가 `.gitignore` 에 있어 저장소로 공유되지 않습니다. DB 는 원격이라 공유되지만 이미지는 서버를 띄운 컴퓨터에만 있습니다. 실제 서비스라면 공용 스토리지가 필요합니다.
- **관리자 행위 감사 로그(`ADMIN_LOG`)가 없습니다.** 제재는 `SANCTION` 행에 누가 · 언제 · 왜가 남지만, 해제한 관리자는 기록되지 않습니다.
- **앱 내 결제가 없습니다.** 기획 단계에서 현장 직접 결제로 정했습니다.
- **채팅은 방에 들어올 때 최근 30개만 불러옵니다.** "이전 대화 더 보기" 는 아직 없습니다.
- **기사 예약 상세(`/fixer/bookings`)는 미완성입니다.** 메뉴에서 연결하지 않았습니다.
- 리뷰 원문은 기획상 관리자만 열람합니다. 고객 · 기사에게는 평균 별점과 완료 건수만 공개됩니다.
---
 
## 팀 구성
 
| 파트 | 담당 기능 |
|---|---|
| 고객 페이지 | 메인 · 회원가입 · 로그인 · 접수 · 매칭 · 마이페이지 · 리뷰 |
| 기사 페이지 | 기사 인증 · 일감 · 견적 · 내 작업 · 차단 |
| 소통 · 관리자 | 실시간 채팅 (F-12) · 고객센터 (F-13) · 접수 현황 (F-22) · 회원 기사 관리 (F-23) · 블랙리스트 (F-24) · 리뷰 관리 (F-25) · 문의 응대 (F-26) · 관리자 로그인 (F-27) |
 
---
 
## 브랜치 규칙
 
```
main                기준
develop             통합 브랜치
feature/F-00-이름   기능별 작업 브랜치
```
 
작업은 `feature/*` 에서 하고 `develop` 으로 합칩니다. **`git push --force` 는 사용하지 않습니다.**
 


