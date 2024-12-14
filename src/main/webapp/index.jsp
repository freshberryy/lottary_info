<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>복권 판매점 지도 및 로또 추첨</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895&libraries=services"></script>
    <style>
        /* 기본 설정 */
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
            margin-bottom: 10px;
        }
        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        /* 지도 섹션 */
        #map {
            width: 100%;
            height: 500px;
            border-radius: 12px;
            margin-top: 10px;
        }
        #searchInput {
            width: 300px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        #searchButton {
            background-color: #1e88e5;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            margin-left: 5px;
        }
        #searchButton:hover {
            background-color: #1565c0;
        }

        /* 로또 번호 섹션 */
        .numbers {
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

        /* 애니메이션 */
        @keyframes bounce {
            0%, 100% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-10px);
            }
        }
        button {
            background-color: #1e88e5;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }
        button:hover {
            background-color: #1565c0;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 지도 섹션 -->
        <div class="card">
            <h1>복권 판매점 지도</h1>
            <div>
                <input type="text" id="searchInput" placeholder="위치를 검색하세요">
                <button id="searchButton">검색</button>
            </div>
            <div id="map"></div>
        </div>

        <!-- 로또 번호 섹션 -->
        <div class="card">
            <h1>로또 번호 추첨</h1>
            <button id="drawBtn">추첨하기</button>
            <div class="numbers" id="numbersContainer"></div>
        </div>
    </div>

    <script>
        // 지도 관련 코드
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 7
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);
        var places = new kakao.maps.services.Places();

        var locations = [
            <% 
                LotteryStoreDAO dao = new LotteryStoreDAO();
                java.util.List<LotteryStore> stores = dao.getAllLotteryStores();
                for (LotteryStore store : stores) {
            %>
            {
                name: "<%= store.getName() %>",
                roadAddress: "<%= store.getRoadAddress() %>",
                latitude: <%= store.getLatitude() != null ? store.getLatitude() : "null" %>,
                longitude: <%= store.getLongitude() != null ? store.getLongitude() : "null" %>
            },
            <% } %>
            
            
            
            // 2. 전체 판매점 데이터 로드
            var allStores = [
                <% 
                    LotteryStoreDAO dao = new LotteryStoreDAO();
                    java.util.List<LotteryStore> stores = dao.getAllLotteryStores();
                    for (LotteryStore store : stores) {
                %>
                {
                    name: "<%= store.getName() %>",
                    address: "<%= store.getRoadAddress() %>",
                    latitude: <%= store.getLatitude() != null ? store.getLatitude() : "null" %>,
                    longitude: <%= store.getLongitude() != null ? store.getLongitude() : "null" %>
                },
                <% } %>
            ];

            // 3. 1등 당첨 판매점 데이터 로드
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
                    latitude: <%= store.getLatitude() != null ? store.getLatitude() : "null" %>,
                    longitude: <%= store.getLongitude() != null ? store.getLongitude() : "null" %>
                },
                <% } %>
        ];

        locations.forEach(function(location) {
            if (location.latitude && location.longitude) {
                var markerPosition = new kakao.maps.LatLng(location.latitude, location.longitude);

                var marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map
                });

                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:5px;font-size:12px;">' + location.name + '<br>' + location.roadAddress + '</div>'
                });

                kakao.maps.event.addListener(marker, 'click', function() {
                    infowindow.open(map, marker);
                });
            }
        });

        document.getElementById('searchButton').addEventListener('click', function() {
            var keyword = document.getElementById('searchInput').value;
            if (!keyword.trim()) {
                alert("검색어를 입력하세요.");
                return;
            }

            places.keywordSearch(keyword, function(data, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var firstLocation = new kakao.maps.LatLng(data[0].y, data[0].x);
                    map.setCenter(firstLocation);

                    var searchMarker = new kakao.maps.Marker({
                        position: firstLocation,
                        map: map
                    });

                    var searchInfowindow = new kakao.maps.InfoWindow({
                        content: '<div style="padding:5px;font-size:12px;">' + data[0].place_name + '</div>'
                    });
                    searchInfowindow.open(map, searchMarker);
                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
        });

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var userLat = position.coords.latitude;
                var userLng = position.coords.longitude;
                var userPosition = new kakao.maps.LatLng(userLat, userLng);
                map.setCenter(userPosition);

                var userMarker = new kakao.maps.Marker({
                    position: userPosition,
                    map: map,
                    title: '내 위치'
                });

                var userInfowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:5px;font-size:12px;">현재 위치</div>'
                });
                userInfowindow.open(map, userMarker);
            });
        }

        // 로또 번호 추첨 코드
        document.getElementById('drawBtn').addEventListener('click', function() {
            fetch('LottoServlet')
                .then(response => response.json())
                .then(data => {
                    const container = document.getElementById('numbersContainer');
                    container.innerHTML = '';

                    data.numbers.forEach(num => {
                        const span = document.createElement('span');
                        span.textContent = num;
                        span.classList.add('ball', getRangeClass(num));
                        container.appendChild(span);
                    });

                    const plus = document.createElement('span');
                    plus.classList.add('plus-sign');
                    plus.textContent = '+';
                    container.appendChild(plus);

                    const bonusSpan = document.createElement('span');
                    bonusSpan.textContent = data.bonus;
                    bonusSpan.classList.add('ball', getRangeClass(data.bonus));
                    container.appendChild(bonusSpan);
                });
        });

        function getRangeClass(num) {
            if (num >= 1 && num <= 10) return 'range1';
            if (num >= 11 && num <= 20) return 'range2';
            if (num >= 21 && num <= 30) return 'range3';
            if (num >= 31 && num <= 40) return 'range4';
            if (num >= 41 && num <= 45) return 'range5';
            return 'range1';
        }
    </script>
</body>
</html>
