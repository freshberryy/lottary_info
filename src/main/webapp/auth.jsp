<%@ page import="lotto.DAO.UserDAO" %>
<%@ page import="lotto.DTO.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // POST 요청 처리
    String action = request.getParameter("action");
    String message = null;

    if ("signup".equals(action)) {
        // 회원가입 처리
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            UserDAO userDAO = new UserDAO();
            User newUser = new User(0, username, password, "user", java.time.LocalDateTime.now().toString());

            if (userDAO.addUser(newUser)) {
                message = "회원가입 성공! 이제 로그인하세요.";
            } else {
                message = "회원가입 실패. 사용자 이름이 이미 존재하거나 오류가 발생했습니다.";
            }
        } else {
            message = "모든 필드를 입력해주세요.";
        }
    } else if ("login".equals(action)) {
        // 로그인 처리
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getAllUsers().stream()
                .filter(u -> u.getUsername().equals(username) && u.getPassword().equals(password))
                .findFirst()
                .orElse(null);

            if (user != null) {
                // 로그인 성공: index.jsp로 이동
                session.setAttribute("loggedInUser", user);
                response.sendRedirect("index.jsp");
                return;
            } else {
                message = "로그인 실패. 사용자 이름 또는 비밀번호를 확인하세요.";
            }
        } else {
            message = "모든 필드를 입력해주세요.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>회원가입 및 로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }
        h1 {
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        button {
            background-color: #1e88e5;
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1565c0;
        }
        .message {
            text-align: center;
            color: red;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .switch {
            text-align: center;
            font-size: 14px;
        }
        .switch a {
            color: #1e88e5;
            text-decoration: none;
        }
        .switch a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>회원가입 및 로그인</h1>
        <% if (message != null) { %>
            <p class="message"><%= message %></p>
        <% } %>

        <!-- 로그인 폼 -->
        <form method="post">
            <input type="hidden" name="action" value="login">
            <input type="text" name="username" placeholder="사용자 이름" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>

        <div class="switch">
            <p>회원이 아니신가요? 아래에서 가입하세요.</p>
        </div>

        <!-- 회원가입 폼 -->
        <form method="post">
            <input type="hidden" name="action" value="signup">
            <input type="text" name="username" placeholder="사용자 이름" required>
            <input type="password" name="password" placeholder="비밀번호" required>
            <button type="submit">회원가입</button>
        </form>
    </div>
</body>
</html>
