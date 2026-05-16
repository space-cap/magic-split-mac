# [계획서] Mock 데이터 기반 프리미엄 UI 구현

본 문서는 키움 API 연동 전, 사용자 경험(UX) 검증을 위해 가상의 데이터를 활용한 대시보드 UI 구현 계획을 서술합니다.

## 1. 목적
- **UX 검증**: 실제 매매 시 필요한 정보가 적절한 위치에 있는지 확인
- **디자인 시스템 구축**: Tailwind CSS 기반의 공통 컴포넌트(버튼, 테이블, 카드) 정의
- **LiveView 학습**: 실시간 가격 변동 시 화면이 어떻게 갱신되는지 로직 테스트

## 2. Mock 데이터 설계
프로그램 내부에서 사용할 가상의 종목 리스트를 다음과 같이 정의합니다.

```elixir
[
  %{id: "005930", name: "삼성전자", price: 72500, change: 1.2, qty: 100, avg_price: 71000, level: 2},
  %{id: "000660", name: "SK하이닉스", price: 115000, change: -0.8, qty: 50, avg_price: 116500, level: 3},
  %{id: "035420", name: "NAVER", price: 195000, change: 0.5, qty: 0, avg_price: 0, level: 0}
]
```

## 3. 화면 구성 및 레이아웃 (Layout)

### 3.1. 사이드바 (Left Sidebar)
- **자산 요약**: 총 자산, 당일 손익(금액/수익률)
- **내비게이션**: 
    - 🏦 실시간 잔고 (Dashboard)
    - 📈 매매 일지 (History)
    - ⚙️ 환경 설정 (Settings)

### 3.2. 메인 콘텐츠 (Center Grid)
- **상단 툴바**: 종목 검색창, 필터 버튼 (보유종목만 보기 등)
- **메인 테이블**:
    - **가독성**: 윈도우 버전의 빽빽한 격자를 제거하고, 충분한 행 간격(Padding) 확보
    - **분할 매수 인디케이터**: 7개의 점(dot)으로 표시 (매수 완료는 꽉 찬 점, 예정은 빈 점)

### 3.3. 주문 패널 (Right Sidebar)
- **종목 상세**: 현재 선택된 종목의 미니 차트와 정보
- **주문 폼**: 매수/매도 수량 입력 및 버튼

## 4. 디자인 가이드 (CSS)
- **컬러**: Slate-900 (배경), Slate-800 (카드/패널), White (텍스트)
- **강조색**: 
    - 상승: `text-rose-500` (Red 계열)
    - 하락: `text-blue-500` (Blue 계열)
    - 메인 포인트: `text-indigo-400`
- **폰트**: Pretendard 또는 시스템 기본 산세리프 폰트 활용

## 5. 단계별 구현 로직
1. **Route 등록**: `/dashboard` 경로 추가
2. **LiveView 생성**: `MagicSplitMacWeb.DashboardLive` 모듈 작성
3. **Template 작업**: `dashboard_live.html.heex`에 레이아웃 및 컴포넌트 배치
4. **시뮬레이션**: `Process.send_after`를 이용해 1~2초마다 가짜 가격 변동 이벤트 발생

---
> **작성자**: Antigravity (HTS 설계 전문가)
> **작성일**: 2026-05-16
