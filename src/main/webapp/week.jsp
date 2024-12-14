<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로또 번호 조회</title>
    <script>
        // 자바스크립트로 선택된 회차를 서버로 전달
        function showLottoResult() {
            const selectedDraw = document.getElementById('drawDropdown').value;
            window.location.href = "?drawNumber=" + selectedDraw;
        }
    </script>
</head>
<body>
<%! 
// 로또 첫 추첨일 (2002년 12월 7일)을 기준으로 회차 계산
int getLatestDrawNumber() {
    LocalDate firstDrawDate = LocalDate.of(2002, 12, 7); // 첫 로또 추첨일
    LocalDate today = LocalDate.now(); // 오늘 날짜
    long weeksBetween = ChronoUnit.WEEKS.between(firstDrawDate, today); // 주 단위로 계산
    return (int) weeksBetween + 1; // 첫 주를 포함해야 하므로 +1
}

// API 응답에서 데이터를 추출하는 함수 (JSON 대신 정규식을 사용)
String[] getLottoResult(int drwNo) {
    String[] result = new String[8]; // 당첨번호 6개 + 보너스번호 + 날짜
    try {
        String apiUrl = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=" + drwNo;
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();

            String response = sb.toString();

            // 정규식을 사용해 JSON-like 데이터에서 필요한 값 추출
            Pattern pattern = Pattern.compile("\"drwtNo([1-6])\":(\\d+),?");
            Matcher matcher = pattern.matcher(response);

            int index = 0;
            while (matcher.find() && index < 6) {
                result[index] = matcher.group(2); // 당첨번호 1~6 추출
                index++;
            }

            // 보너스번호 추출
            Pattern bonusPattern = Pattern.compile("\"bnusNo\":(\\d+),?");
            Matcher bonusMatcher = bonusPattern.matcher(response);
            if (bonusMatcher.find()) {
                result[6] = bonusMatcher.group(1); // 보너스번호
            }

            // 날짜 추출
            Pattern datePattern = Pattern.compile("\"drwNoDate\":\"([^\"]+)\",?");
            Matcher dateMatcher = datePattern.matcher(response);
            if (dateMatcher.find()) {
                result[7] = dateMatcher.group(1); // 추첨 날짜
            }
        }
        conn.disconnect();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return result;
}
%>
<h1>로또 번호 조회</h1>

<%
    int latestDraw = getLatestDrawNumber(); // 최신 회차 계산
    int firstDraw = 1; // 첫 회차 번호
    String selectedDrawParam = request.getParameter("drawNumber"); // URL에서 선택된 회차 가져오기
    int selectedDraw = (selectedDrawParam != null) ? Integer.parseInt(selectedDrawParam) : latestDraw; // 선택된 회차 (기본값: 최신 회차)

    // 선택된 회차의 결과 가져오기
    String[] data = getLottoResult(selectedDraw);
%>

<!-- 드롭다운 형식 -->
<div>
    <label for="drawDropdown">회차 선택:</label>
    <select id="drawDropdown" onchange="showLottoResult()">
        <% for (int i = latestDraw; i >= firstDraw; i--) { %>
            <option value="<%= i %>" <%= (i == selectedDraw) ? "selected" : "" %>>
                <%= i %>회차
            </option>
        <% } %>
    </select>
</div>

<!-- 선택된 회차의 결과 표시 -->
<%
if (data[0] != null) { // 당첨번호가 null이 아니면 성공
%>
<div>
    <h2><%= selectedDraw %>회차 (<%= data[7] %>)</h2>
    <p>당첨번호: <%= data[0] %>, <%= data[1] %>, <%= data[2] %>, <%= data[3] %>, <%= data[4] %>, <%= data[5] %></p>
    <p>보너스번호: <%= data[6] %></p>
</div>
<%
} else {
%>
<div>
    <h2><%= selectedDraw %>회차 정보를 가져올 수 없습니다.</h2>
</div>
<%
}
%>
</body>
</html>
