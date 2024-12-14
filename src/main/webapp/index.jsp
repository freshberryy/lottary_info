<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DAO.WinningStoresDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page import="lotto.DTO.WinningStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>복권 판매점 지도 및 로또 추첨</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895&libraries=services"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f6f9;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        h1 {
            font-size: 24px;
            color: #333;
        }
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        #map-container {
            display: flex;
            gap: 20px;
        }
        #map {
            width: 70%;
            height: 500px;
            border-radius: 12px;
        }
        #info {
            width: 30%;
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
        }
        .map-controls {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }
        input[type="text"] {
            flex: 1;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        button {
            background-color: #1e88e5;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        button:hover {
            background-color: #1565c0;
        }
        .btn-group {
            margin: 20px 0;
        }
        .btn {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #007BFF;
            color: white;
            border: none;
            margin-right: 10px;
        }
        .btn.active {
            background-color: #0056b3;
        }
        .store-info {
            margin-bottom: 20px;
        }
        .store-info h3 {
            margin: 10px 0;
            color: #333;
        }
        .store-info p {
            margin: 5px 0;
            font-size: 14px;
            color: #666;
        }
        .lotto-container {
            text-align: center;
        }
        .lotto-balls {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .ball {
            display: inline-flex;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            color: #fff;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.15);
            animation: bounce 0.5s ease;
        }
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
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 지도 섹션 -->
        <div class="card">
            <h1>복권 판매점 지도</h1>
            <div class="btn-group">
                <button class="btn active" id="allStoresBtn">전체 판매점</button>
                <button class="btn" id="winningStoresBtn">1등 당첨 판매점</button>
            </div>
            <div id="map-container">
                <div id="map"></div>
                <div id="info">
                    <h2>판매점 정보</h2>
                    <div id="storeDetails">
                        <p>마커를 클릭하면 판매점 정보가 여기에 표시됩니다.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 로또 번호 섹션 -->
        <div class="card">
            <h1>로또 번호 추첨</h1>
            <button id="drawBtn">추첨하기</button>
            <div id="numbersContainer"></div>
        </div>
    </div>

    <script>
        // 지도 관련 초기화 코드 (기존 유지)
        var mapContainer = document.getElementById('map');
        var mapOption = { center: new kakao.maps.LatLng(37.5665, 126.9780), level: 7 };
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 데이터 로드 (기존 코드 유지)
        var allStores = [
            <% 
                LotteryStoreDAO dao = new LotteryStoreDAO();
                java.util.List<LotteryStore> stores = dao.getAllLotteryStores();
                for (LotteryStore store : stores) {
            %>
            {
                name: "<%= store.getName() %>",
                address: "<%= store.getRoadAddress() %>",
                latitude: <%= store.getLatitude() %>,
                longitude: <%= store.getLongitude() %>
            },
            <% } %>
        ];
        var winningStores = [
            <% 
                WinningStoresDAO winningDao = new WinningStoresDAO();
                java.util.List<WinningStore> winningStoresList = winningDao.getAllWinningStores();
                for (WinningStore store : winningStoresList) {
            %>
            {
                name: "<%= store.getName() %>",
                address: "<%= store.getRegion() %>",
                winCount: <%= store.getWinCount() %>,
                latitude: <%= store.getLatitude() %>,
                longitude: <%= store.getLongitude() %>
            },
            <% } %>
        ];

        var markers = [];
        function createMarkers(locations, isWinningStore) {
            markers.forEach(marker => marker.setMap(null));
            markers = [];
            locations.forEach(location => {
                if (location.latitude && location.longitude) {
                    var position = new kakao.maps.LatLng(location.latitude, location.longitude);
                    var marker = new kakao.maps.Marker({ position, map });

                    kakao.maps.event.addListener(marker, 'click', function() {
                        var infoHTML = '<div class="store-info">' +
                                       '<h3>' + location.name + '</h3>' +
                                       '<p><strong>주소:</strong> ' + location.address + '</p>';
                        if (isWinningStore && location.winCount) {
                            infoHTML += '<p><strong>1등 당첨 횟수:</strong> ' + location.winCount + '</p>';
                        }
                        infoHTML += '</div>';
                        document.getElementById('storeDetails').innerHTML = infoHTML;
                    });
                    markers.push(marker);
                }
            });
        }

        // 초기 상태
        createMarkers(allStores, false);

        // 버튼 클릭 이벤트
        document.getElementById('allStoresBtn').addEventListener('click', function() {
            createMarkers(allStores, false);
            document.getElementById('allStoresBtn').classList.add('active');
            document.getElementById('winningStoresBtn').classList.remove('active');
        });

        document.getElementById('winningStoresBtn').addEventListener('click', function() {
            createMarkers(winningStores, true);
            document.getElementById('winningStoresBtn').classList.add('active');
            document.getElementById('allStoresBtn').classList.remove('active');
        });

        // 로또 번호 생성
        document.getElementById('drawBtn').addEventListener('click', function() {
            var numbers = generateLottoNumbers();
            displayLottoNumbers(numbers);
        });

        function generateLottoNumbers() {
            var numbers = [];
            while (numbers.length < 6) {
                var num = Math.floor(Math.random() * 45) + 1; // 1~45 사이의 랜덤 숫자
                if (!numbers.includes(num)) {
                    numbers.push(num);
                }
            }
            numbers.sort((a, b) => a - b); // 오름차순 정렬
            var bonus = Math.floor(Math.random() * 45) + 1; // 보너스 번호
            while (numbers.includes(bonus)) {
                bonus = Math.floor(Math.random() * 45) + 1;
            }
            return { main: numbers, bonus: bonus };
        }

        function displayLottoNumbers(data) {
            var container = document.getElementById('numbersContainer');
            container.innerHTML = '';

            data.main.forEach(function(num) {
                var ball = document.createElement('span');
                ball.className = 'ball ' + getBallColor(num);
                ball.textContent = num;
                container.appendChild(ball);
            });

            var plus = document.createElement('span');
            plus.className = 'plus-sign';
            plus.textContent = '+';
            container.appendChild(plus);

            var bonusBall = document.createElement('span');
            bonusBall.className = 'ball ' + getBallColor(data.bonus);
            bonusBall.textContent = data.bonus;
            container.appendChild(bonusBall);
        }

        function getBallColor(num) {
            if (num >= 1 && num <= 10) return 'range1';
            if (num >= 11 && num <= 20) return 'range2';
            if (num >= 21 && num <= 30) return 'range3';
            if (num >= 31 && num <= 40) return 'range4';
            if (num >= 41 && num <= 45) return 'range5';
        }
    </script>
</body>
</html>
