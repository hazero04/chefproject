# 🥕 방구석 셰프 (Chef_Project)

식재료 마트 · 장바구니 · 나의 냉장고 · 레시피 추천을 한 번에 하는 웹앱입니다.
Online Groceries 스타일의 초록색 모바일 UI, 반응형 레이아웃, PWA(홈 화면에 설치, 오프라인 지원)를 지원합니다.

| 버전 | 위치 | 실행 환경 |
| --- | --- | --- |
| **JSP 원본 앱** | `Chef_Project/` | Tomcat 10.1 + MySQL (Eclipse Dynamic Web Project) |
| **GitHub Pages 데모** | `docs/` | 정적 사이트 (데이터는 브라우저 localStorage 에 저장) |

## 📱 GitHub Pages 데모

👉 https://hazero04.github.io/chefproject/

GitHub Pages는 JSP·DB를 실행할 수 없어서, 같은 화면과 흐름을 JavaScript로 옮긴 정적 버전을 `docs/`에 두었습니다.
식재료·레시피 데이터는 프로젝트의 SQL 파일(`insert.sql`, `recipe.sql`)에서 그대로 가져옵니다.

### 처음 한 번만: Pages 켜기
1. 저장소 **Settings → Pages**
2. **Build and deployment → Source: Deploy from a branch**
3. **Branch:** `claude/online-groceries-mobile-ui-ne12r8` / 폴더 **`/docs`** → **Save**
4. 1~2분 뒤 위 주소로 접속

### 디자인·데이터를 바꾼 뒤 데모 다시 만들기
```bash
python3 tools/build_pages.py   # CSS/아이콘/이미지 복사 + SQL → docs/data.js 생성
```
화면 로직은 `docs/app.js`, 캐시 목록은 `docs/sw.js` 입니다. (`sw.js`의 `VERSION`을 올리면 설치된 앱도 새 파일을 받습니다.)

## 📲 앱으로 설치 (PWA)
- **Android / PC 크롬·엣지**: 상단의 ⬇️ 설치 버튼 또는 주소창의 설치 아이콘
- **iPhone (Safari)**: 공유 버튼 → **홈 화면에 추가**
- 한 번 열어본 화면은 인터넷이 끊겨도 볼 수 있습니다. (Pages 데모는 전체 기능이 오프라인 동작)

## ☕ JSP 앱 실행
1. MySQL에 `ChefDB` 생성 후 `resources/sql/` 의 `food.sql → insert.sql → refri.sql → recipe.sql` 순서로 실행
2. `dbconnect.jsp` 의 접속 정보 확인 (기본 `root / root`)
3. Eclipse에서 Tomcat 10.1 서버로 실행 → `http://localhost:8080/<컨텍스트>/mainhome.jsp`

PWA 관련 파일: `manifest.json`, `sw.js`, `offline.html`, `resources/js/pwa.js`, `resources/icons/`
로고 원본은 `design/logo-source.png` 이고, 앱 아이콘·로고는 `resources/icons/` 에 있습니다.
(Bootstrap·아이콘은 오프라인에서도 동작하도록 `resources/` 아래에 포함되어 있습니다.)

> 서비스워커는 `localhost` 또는 `https` 에서만 동작합니다.

---
© Chef_Project 쩝쩝박사
