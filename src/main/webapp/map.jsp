<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>복권 판매점 지도</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895&libraries=services"></script>
</head>
<body>
    <h1>복권 판매점 지도</h1>
    <!-- 검색창 -->
    <div>
        <input type="text" id="searchInput" placeholder="위치를 검색하세요" style="width:300px; padding:5px;">
        <button id="searchButton" style="padding:5px 10px;">검색</button>
    </div>
    <div id="map" style="width:100%;height:500px;margin-top:10px;"></div>

    <script>
        // 1. 지도를 생성합니다.
        var mapContainer = document.getElementById('map'); // 지도를 표시할 div
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 기본 지도 중심 좌표 (서울 기준)
            level: 7 // 확대 레벨
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 2. 장소 검색 객체를 생성합니다.
        var places = new kakao.maps.services.Places();

        // 3. 서버에서 데이터를 받아옵니다.
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
        ];

        // 4. 데이터를 기반으로 마커를 지도에 표시합니다.
        locations.forEach(function(location) {
            if (location.latitude && location.longitude) {
                var markerPosition = new kakao.maps.LatLng(location.latitude, location.longitude);

                var marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map
                });

                // 마커 클릭 시 정보창 표시
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:5px;font-size:12px;">' + location.name + '<br>' + location.roadAddress + '</div>'
                });

                kakao.maps.event.addListener(marker, 'click', function() {
                    infowindow.open(map, marker);
                });
            }
        });

        // 5. 사용자의 현재 위치를 가져옵니다.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var userLat = position.coords.latitude; // 사용자의 위도
                var userLng = position.coords.longitude; // 사용자의 경도

                // 사용자의 현 위치를 지도 중심으로 설정
                var userPosition = new kakao.maps.LatLng(userLat, userLng);
                map.setCenter(userPosition);

                // 사용자 위치에 마커를 추가
                var userMarker = new kakao.maps.Marker({
                    position: userPosition,
                    map: map,
                    title: '내 위치'
                });

                // 사용자 위치에 정보창 추가
                var userInfowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:5px;font-size:12px;">현재 위치</div>'
                });
                userInfowindow.open(map, userMarker);
            }, function(error) {
                console.error("Error getting user location: ", error);
                alert("현재 위치를 가져올 수 없습니다.");
            });
        } else {
            alert("브라우저에서 위치 정보 가져오기를 지원하지 않습니다.");
        }

        // 6. 검색 버튼 클릭 이벤트 처리
        document.getElementById('searchButton').addEventListener('click', function() {
            var keyword = document.getElementById('searchInput').value;

            if (!keyword.trim()) {
                alert("검색어를 입력하세요.");
                return;
            }

            // 장소 검색 요청
            places.keywordSearch(keyword, function(data, status, pagination) {
                if (status === kakao.maps.services.Status.OK) {
                    // 검색된 첫 번째 위치로 지도 이동
                    var firstLocation = new kakao.maps.LatLng(data[0].y, data[0].x);
                    map.setCenter(firstLocation);

                    // 검색된 위치에 마커 표시
                    var searchMarker = new kakao.maps.Marker({
                        position: firstLocation,
                        map: map
                    });

                    // 검색된 위치에 정보창 추가
                    var searchInfowindow = new kakao.maps.InfoWindow({
                        content: '<div style="padding:5px;font-size:12px;">' + data[0].place_name + '</div>'
                    });
                    searchInfowindow.open(map, searchMarker);
                } else {
                    alert("검색 결과가 없습니다.");
                }
            });
        });
    </script>
</body>
</html>
