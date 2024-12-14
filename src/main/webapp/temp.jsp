<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>LotteryStore 조회 테스트</title>
</head>
<body>
    <h1>LotteryStore 조회 테스트</h1>

    <h2>전체 데이터 조회</h2>
    <%
        // DAO 객체 생성
        LotteryStoreDAO dao = new LotteryStoreDAO();
        java.util.List<LotteryStore> stores = dao.getAllLotteryStores();

        if (stores.isEmpty()) {
    %>
        <p>조회된 데이터가 없습니다.</p>
    <%
        } else {
    %>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>상호</th>
                <th>도로명 주소</th>
                <th>지번 주소</th>
                <th>위도</th>
                <th>경도</th>
                <th>지역</th>
                <th>당첨 여부</th>
            </tr>
            <%
                for (LotteryStore store : stores) {
            %>
            <tr>
                <td><%= store.getId() %></td>
                <td><%= store.getName() %></td>
                <td><%= store.getRoadAddress() %></td>
                <td><%= store.getLandAddress() %></td>
                <td><%= store.getLatitude() %></td>
                <td><%= store.getLongitude() %></td>
                <td><%= store.getRegion() %></td>
                <td><%= store.isWinner() ? "당첨" : "미당첨" %></td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>

    <h2>ID로 데이터 조회</h2>
    <form method="GET">
        <label for="storeId">조회할 ID 입력:</label>
        <input type="text" id="storeId" name="storeId" />
        <button type="submit">조회</button>
    </form>
    <%
        String storeIdParam = request.getParameter("storeId");
        if (storeIdParam != null && !storeIdParam.isEmpty()) {
            try {
                int storeId = Integer.parseInt(storeIdParam);
                LotteryStore storeById = dao.getLotteryStoreById(storeId);

                if (storeById != null) {
    %>
        <h3>조회 결과:</h3>
        <table border="1">
            <tr>
                <th>ID</th>
                <td><%= storeById.getId() %></td>
            </tr>
            <tr>
                <th>상호</th>
                <td><%= storeById.getName() %></td>
            </tr>
            <tr>
                <th>도로명 주소</th>
                <td><%= storeById.getRoadAddress() %></td>
            </tr>
            <tr>
                <th>지번 주소</th>
                <td><%= storeById.getLandAddress() %></td>
            </tr>
            <tr>
                <th>위도</th>
                <td><%= storeById.getLatitude() %></td>
            </tr>
            <tr>
                <th>경도</th>
                <td><%= storeById.getLongitude() %></td>
            </tr>
            <tr>
                <th>지역</th>
                <td><%= storeById.getRegion() %></td>
            </tr>
            <tr>
                <th>당첨 여부</th>
                <td><%= storeById.isWinner() ? "당첨" : "미당첨" %></td>
            </tr>
        </table>
    <%
                } else {
    %>
        <p>ID <%= storeId %>에 해당하는 데이터가 없습니다.</p>
    <%
                }
            } catch (NumberFormatException e) {
    %>
        <p>유효한 숫자를 입력하세요.</p>
    <%
            }
        }
    %>
</body>
</html>
