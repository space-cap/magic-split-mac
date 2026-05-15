# 📈 키움 REST API 연동 테스트 가이드

이 문서는 키움증권의 REST API가 우리 프로젝트(Elixir/Phoenix)와 잘 연동되는지 테스트하는 방법을 설명합니다.

---

## 1. 사전 준비 (Kiwoom 설정)

테스트를 시작하기 전에 키움증권 개발자 센터에서 다음 정보가 준비되어 있어야 합니다.
- **App Key (Client ID)**
- **App Secret (Client Secret)**
- **키움 OpenAPI(REST) 서비스 신청 완료**

---

## 2. 환경 변수 설정

보안을 위해 API 키는 코드에 직접 쓰지 않고 `.env` 파일이나 OS 환경 변수에 저장합니다.
프로젝트 루트에 `.env` 파일을 만들고 아래 내용을 입력하세요 (이미 있다면 추가).

```bash
KIWOOM_APP_KEY="여러분의_앱_키"
KIWOOM_APP_SECRET="여러분의_앱_시크릿"
KIWOOM_BASE_URL="https://api.kiwoom.com"
```

---

## 3. Elixir에서 테스트하기 (IEx 활용)

코드를 짜기 전에 터미널에서 즉석으로 API가 응답하는지 테스트해 볼 수 있습니다.

1.  **터미널에서 IEx 실행**:
    ```powershell
    iex -S mix
    ```

2.  **인증 토큰 요청 테스트 (예시)**:
    아래 코드를 IEx 창에 복사해서 붙여넣어 보세요 (실제 키가 설정되어 있어야 합니다).
    ```elixir
    # Req 라이브러리를 사용한 토큰 요청 예시
    base_url = System.get_env("KIWOOM_BASE_URL")
    url = "#{base_url}/oauth2/token"  # 파이썬 샘플 기준 경로
    body = %{
      grant_type: "client_credentials",
      appkey: System.get_env("KIWOOM_APP_KEY"),
      secretkey: System.get_env("KIWOOM_APP_SECRET") # appsecret -> secretkey로 변경
    }

    response = Req.post!(url, json: body)
    IO.inspect(response.body["token"]) # access_token이 아니라 "token"입니다!
    ```

---

## 4. 테스트 모듈 만들기 (`lib/magic_split_mac/kiwoom.ex`)

실제 프로젝트 코드에서 연동을 담당할 간단한 모듈을 만들어 테스트합니다.

```elixir
defmodule MagicSplitMac.Kiwoom do
  @doc "접근 토큰을 가져옵니다."
  def get_token do
    base_url = System.get_env("KIWOOM_BASE_URL")
    url = "#{base_url}/oauth2/token"
    body = %{
      grant_type: "client_credentials",
      appkey: System.get_env("KIWOOM_APP_KEY"),
      secretkey: System.get_env("KIWOOM_APP_SECRET")
    }

    Req.post!(url, json: body).body["token"]
  end

  @doc "주식 현재가를 조회합니다."
  def get_price(stock_code) do
    base_url = System.get_env("KIWOOM_BASE_URL")
    token = get_token()
    url = "#{base_url}/v1/quotes/current/#{stock_code}"
    
    Req.get!(url, headers: [{"Authorization", "Bearer #{token}"}]).body
  end
end
```

---

## 5. 확인 사항 (Troubleshooting)

1.  **401 Unauthorized**: App Key나 Secret이 틀렸거나, 서비스 신청이 승인되지 않은 경우입니다.
2.  **403 Forbidden**: 접근 권한이 없거나 호출 한도를 초과한 경우입니다.
3.  **네트워크 에러**: 윈도우 방화벽이나 네트워크 환경에서 키움 서버 접속을 차단하는지 확인하세요.

---

## 💡 다음 단계
연동이 확인되면, 이 데이터를 **Phoenix LiveView**와 연결하여 화면에 실시간으로 숫자가 변하는 대시보드를 만들 예정입니다!
