<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>로또 번호 추첨</title>
    <style>
        body {
            font-family: sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        button {
            background-color: #1e88e5;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        button:hover {
            background-color: #1565c0;
        }
        .numbers {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
        }
        .ball {
            display: inline-flex;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            color: #fff;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            font-size: 18px;
        }
        /* 번호에 따라 색상을 변경하는 예시 */
        /* 1 ~ 10: 노란색, 11 ~ 20: 파란색, 21 ~ 30: 주황색, 31 ~ 40: 회색, 41 ~ 45: 초록색 */
        .range1 { background-color: #fbc02d; }  /* 노란색 */
        .range2 { background-color: #1e88e5; }  /* 파란색 */
        .range3 { background-color: #e53935; }  /* 주황색 */
        .range4 { background-color: #757575; }  /* 회색 */
        .range5 { background-color: #43a047; }  /* 초록색 */
        
        .plus-sign {
            font-size: 20px;
            color: #757575;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e0e0e0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>로또 번호 추첨</h1>
        <button id="drawBtn">추첨하기</button>
        <div class="numbers" id="numbersContainer"></div>
    </div>

    <script>
        document.getElementById('drawBtn').addEventListener('click', function() {
            fetch('LottoServlet')
                .then(response => response.json())
                .then(data => {
                    // data: {numbers: [...], bonus: ...}
                    const container = document.getElementById('numbersContainer');
                    container.innerHTML = '';

                    // 메인 번호 생성
                    data.numbers.forEach(num => {
                        const span = document.createElement('span');
                        span.textContent = num;
                        span.classList.add('ball', getRangeClass(num));
                        container.appendChild(span);
                    });

                    // 플러스 기호
                    const plus = document.createElement('span');
                    plus.classList.add('plus-sign');
                    plus.textContent = '+';
                    container.appendChild(plus);

                    // 보너스 번호
                    const bonusSpan = document.createElement('span');
                    bonusSpan.textContent = data.bonus;
                    bonusSpan.classList.add('ball', getRangeClass(data.bonus));
                    container.appendChild(bonusSpan);
                })
                .catch(error => console.error('Error:', error));
        });

        // 번호에 따른 range class 리턴하는 함수
        function getRangeClass(num) {
            if (num >= 1 && num <= 10) return 'range1';
            if (num >= 11 && num <= 20) return 'range2';
            if (num >= 21 && num <= 30) return 'range3';
            if (num >= 31 && num <= 40) return 'range4';
            if (num >= 41 && num <= 45) return 'range5';
            return 'range1'; // fallback
        }
    </script>
</body>
</html>
