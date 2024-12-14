<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DAO.WinningStoresDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page import="lotto.DTO.WinningStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>복권 판매점 지도</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895"></script>
    <style>
        #container {
            display: flex;
        }
        #map {
            width: 50%;
            height: 500px;
        }
        #info {
            width: 50%;
            padding: 20px;
            border-left: 1px solid #ccc;
            overflow-y: auto;
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
    </style>
</head>
<body>
    <h1>복권 판매점 지도</h1>
    <h3>출처 기획재정부, 20240531 기준</h3>
    
    <!-- 토글 버튼 -->
    <div class="btn-group">
        <button class="btn active" id="allStoresBtn">전체 판매점</button>
        <button class="btn" id="winningStoresBtn">1등 당첨 판매점</button>
    </div>

    <!-- 지도와 정보 영역 -->
    <div id="container">
        <div id="map"></div>
        <div id="info">
            <h2>판매점 정보</h2>
            <div id="storeDetails">
                <p>마커를 클릭하면 판매점 정보가 여기에 표시됩니다.</p>
            </div>
        </div>
    </div>

    <script>
        // 1. 지도 초기화
        var mapContainer = document.getElementById('map'); 
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), 
            level: 7 
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);

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

        // 현재 활성화된 마커 배열
        var markers = [];

        // 마커 생성 함수
        function createMarkers(locations, isWinningStore) {
            // 기존 마커 제거
            markers.forEach(function(marker) {
                marker.setMap(null);
            });
            markers = [];

            // 새 마커 추가
            locations.forEach(function(location) {
                if (location.latitude && location.longitude) {
                    var markerPosition = new kakao.maps.LatLng(location.latitude, location.longitude);

                    var marker = new kakao.maps.Marker({
                        position: markerPosition,
                        map: map
                    });

                    // 마커 클릭 시 정보창 및 오른쪽 정보 표시
                    kakao.maps.event.addListener(marker, 'click', function() {
                        var infoHTML = '<div class="store-info">' +
                                       '<h3>' + location.name + '</h3>' +
                                       '<p><strong>주소:</strong> ' + location.address + '</p>';

                        if (isWinningStore && location.winCount) {
                            infoHTML += '<p><strong>1등 당첨 횟수:</strong> ' + location.winCount + '</p>';
                        }

                        infoHTML += '</div>';

                        // 오른쪽 정보 표시
                        document.getElementById('storeDetails').innerHTML = infoHTML;
                    });

                    markers.push(marker);
                }
            });
        }

        // 초기 상태: 전체 판매점
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
    </script>
</body>
</html>
