<%@ page import="lotto.DAO.LotteryStoreDAO" %>
<%@ page import="lotto.DTO.LotteryStore" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>복권 판매점 지도</title>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895"></script>
</head>
<body>
    <h1>복권 판매점 지도</h1>
    <div id="map" style="width:100%;height:500px;"></div>

    <script>
        // 1. 지도를 생성합니다.
        var mapContainer = document.getElementById('map'); // 지도를 표시할 div
        var mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 지도 중심 좌표 (서울 기준)
            level: 7 // 확대 레벨
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 2. 서버에서 데이터를 받아옵니다.
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

        // 3. 데이터를 기반으로 마커를 지도에 표시합니다.
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
    </script>
</body>
</html>
