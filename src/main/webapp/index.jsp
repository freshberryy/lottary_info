<%@ page import="lotto.DAO.LotteryStoreDAO"%>
<%@ page import="lotto.DAO.WinningStoresDAO"%>
<%@ page import="lotto.DTO.LotteryStore"%>
<%@ page import="lotto.DTO.WinningStore"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>복권 판매점 지도 및 로또 추첨</title>
<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b2beea50fe7814a052e2636303536895&libraries=services"></script>
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

#numbersContainer{

	margin-top: 10px;
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

.range1 {
	background-color: #fbc02d;
} /* 노란색 */
.range2 {
	background-color: #1e88e5;
} /* 파란색 */
.range3 {
	background-color: #e53935;
} /* 주황색 */
.range4 {
	background-color: #757575;
} /* 회색 */
.range5 {
	background-color: #43a047;
} /* 초록색 */
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

@
keyframes bounce { 0%, 100% {
	transform: translateY(0);
}

50
%
{
transform
:
translateY(
-10px
);
}
}

/* 로또 조회 섹션 */
.lotto-container {
	text-align: center;
	padding: 20px;
	background: #ffffff;
	border-radius: 12px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.lotto-header {
	font-size: 22px;
	font-weight: bold;
	margin-bottom: 20px;
	color: #1e88e5;
}

.lotto-dropdown {
	margin-bottom: 20px;
}

select {
	padding: 10px 15px;
	border-radius: 8px;
	border: 1px solid #ddd;
	font-size: 16px;
	color: #333;
	background: #f9f9f9;
}

.lotto-result {
	text-align: left;
	margin-top: 20px;
	padding: 15px;
	border-radius: 10px;
	background: #f7f7f7;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.lotto-result h2 {
	font-size: 20px;
	color: #444;
	margin-bottom: 10px;
}

.lotto-result p {
	font-size: 16px;
	margin: 5px 0;
	color: #666;
}

.lotto-result p span {
	font-weight: bold;
	color: #1e88e5;
}

.error-message {
	color: #e53935;
	font-weight: bold;
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
				<div class="map-controls">
					<input type="text" id="searchInput" placeholder="판매점 이름 또는 주소 검색">
					<button id="searchBtn">검색</button>
				</div>
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


		<%!// 로또 첫 추첨일 (2002년 12월 7일)을 기준으로 회차 계산
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
	}%>
		<div class="lotto-result error-message">

			<h1>로또 번호 조회</h1>

			<%
			int latestDraw = getLatestDrawNumber(); // 최신 회차 계산
			int firstDraw = 1; // 첫 회차 번호
			String selectedDrawParam = request.getParameter("drawNumber"); // URL에서 선택된 회차 가져오기
			int selectedDraw = (selectedDrawParam != null) ? Integer.parseInt(selectedDrawParam) : latestDraw; // 선택된 회차 (기본값: 최신 회차)

			// 선택된 회차의 결과 가져오기
			String[] data = getLottoResult(selectedDraw);
			%>

			<div class="lotto-dropdown">
				<label for="drawDropdown">회차 선택:</label> <select id="drawDropdown"
					onchange="showLottoResult()">
					<%
					for (int i = latestDraw; i >= firstDraw; i--) {
					%>
					<option value="<%=i%>"
						<%=(i == selectedDraw) ? "selected" : ""%>>
						<%=i%>회차
					</option>
					<%
					}
					%>
				</select>
			</div>


			<!-- 선택된 회차의 결과 표시 -->
			<%
			if (data[0] != null) { // 당첨번호가 null이 아니면 성공
			%>
			<div class="lotto-result">
				<h2><%=selectedDraw%>회차 (<%=data[7]%>)
				</h2>
				<p>
					당첨번호: <span><%=data[0]%></span>, <span><%=data[1]%></span>, <span><%=data[2]%></span>,
					<span><%=data[3]%></span>, <span><%=data[4]%></span>, <span><%=data[5]%></span>
				</p>
				<p>
					보너스번호: <span><%=data[6]%></span>
				</p>
			</div>

			<%
			} else {
			%>
			<h2><%=selectedDraw%>회차 정보를 가져올 수 없습니다.
			</h2>
		</div>

		<%
		}
		%>
	</div>




	<script>
    
    //드롭다운
    function showLottoResult() {
        const selectedDraw = document.getElementById('drawDropdown').value;
        window.location.href = "?drawNumber=" + selectedDraw;
    }
    
    function showLottoResult() {
        const selectedDraw = document.getElementById('drawDropdown').value;
        window.location.href = "?drawNumber=" + selectedDraw;
    }

        // 지도 관련 초기화 코드
        var mapContainer = document.getElementById('map');
        var mapOption = { 
            center: new kakao.maps.LatLng(37.5665, 126.9780), 
            level: 5,
            maxLevel: 7
        };
        var map = new kakao.maps.Map(mapContainer, mapOption);

        // 데이터 로드
        var allStores = [
            <%LotteryStoreDAO dao = new LotteryStoreDAO();
java.util.List<LotteryStore> stores = dao.getAllLotteryStores();
for (LotteryStore store : stores) {%>
            {
                name: "<%=store.getName()%>",
                address: "<%=store.getRoadAddress()%>",
                latitude: <%=store.getLatitude()%>,
                longitude: <%=store.getLongitude()%>
            },
            <%}%>
        ];
        
        var winningStores = [
            <%WinningStoresDAO winningDao = new WinningStoresDAO();
	java.util.List<WinningStore> winningStoresList = winningDao.getAllWinningStores();
	for (WinningStore store : winningStoresList) {%>
            {
                name: "<%=store.getName()%>",
                address: "<%=store.getRegion()%>",
                winCount: <%=store.getWinCount()%>,
                latitude: <%=store.getLatitude()%>,
                longitude: <%=store.getLongitude()%>
            },
            <%}%>
        ];

        // 현재 표시 모드 (전체매장 or 1등매장)
        var currentMode = 'winning'; 
        // 매장 마커 저장용 배열
        var storeMarkers = [];
        // 검색 마커
        var searchMarker = null;

        function createStoreMarkers(locations, isWinningStore) {
            // 기존 매장 마커 제거
            storeMarkers.forEach(m => m.setMap(null));
            storeMarkers = [];

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
                    storeMarkers.push(marker);
                }
            });
        }

        // 초기 상태: 1등 당첨 매장 표시
        createStoreMarkers(winningStores, true);

        // 버튼 클릭 이벤트 (전체 매장)
        document.getElementById('allStoresBtn').addEventListener('click', function() {
            currentMode = 'all';
            createStoreMarkers(allStores, false);
            document.getElementById('allStoresBtn').classList.add('active');
            document.getElementById('winningStoresBtn').classList.remove('active');
        });

        // 버튼 클릭 이벤트 (1등 당첨 매장)
        document.getElementById('winningStoresBtn').addEventListener('click', function() {
            currentMode = 'winning';
            createStoreMarkers(winningStores, true);
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

        // 현재 위치 가져오기
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude; // 위도
                var lon = position.coords.longitude; // 경도

                // 현재 위치를 지도 중심으로 설정
                var currentPosition = new kakao.maps.LatLng(lat, lon);
                map.setCenter(currentPosition);

                // 표시할 내용(HTML)
                var content = '<div style="padding:5px;background-color:#ffffff; border:1px solid #888; border-radius:5px; font-size:14px;">나의 현재 위치</div>';

                // 커스텀 오버레이 생성
                var customOverlay = new kakao.maps.CustomOverlay({
                    position: currentPosition,
                    content: content,
                    map: map
                });

                // 오버레이 클릭 이벤트 (필요 시)
                kakao.maps.event.addListener(map, 'click', function() {
                    document.getElementById('storeDetails').innerHTML = 
                        '<div class="store-info">' +
                        '<h3>나의 현재 위치</h3>' +
                        '<p>위도: ' + lat.toFixed(6) + '</p>' +
                        '<p>경도: ' + lon.toFixed(6) + '</p>' +
                        '</div>';
                });
            }, function(error) {
                console.error("Geolocation Error:", error);
                alert("현재 위치를 가져올 수 없습니다.");
            });
        } else {
            alert("Geolocation API를 지원하지 않는 브라우저입니다.");
        }

        // Geocoder 객체 생성
        var geocoder = new kakao.maps.services.Geocoder();

        // 검색 버튼 이벤트
        document.getElementById('searchBtn').addEventListener('click', function() {
            var query = document.getElementById('searchInput').value.trim(); // 검색어 입력값
            if (query === '') {
                alert("검색어를 입력해주세요.");
                return;
            }

            // 입력된 주소를 좌표로 변환
            geocoder.addressSearch(query, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    // 검색 결과의 첫 번째 좌표를 가져옴
                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                    // 지도 중심 이동
                    map.setCenter(coords);
                
                    // 기존 검색 마커 제거
                    if (searchMarker) {
                        searchMarker.setMap(null);
                        searchMarker = null;
                    }

                    // 검색 위치에 마커 추가 (매장 마커는 그대로 유지)
                    searchMarker = new kakao.maps.Marker({
                        map: map,
                        position: coords
                    });

                    // 검색 위치 정보를 표시
                    document.getElementById('storeDetails').innerHTML =
                        '<div class="store-info">' +
                        '<h3>검색된 위치</h3>' +
                        '<p><strong>주소:</strong> ' + query + '</p>' +
                        '<p><strong>위도:</strong> ' + result[0].y + '</p>' +
                        '<p><strong>경도:</strong> ' + result[0].x + '</p>' +
                        '</div>';
                        
                } else {
                    alert("검색 결과가 없습니다. 정확한 주소를 입력해주세요.");
                }
            });
        });
        
        
        // 자바스크립트로 선택된 회차를 서버로 전달
        function showLottoResult() {
            const selectedDraw = document.getElementById('drawDropdown').value;
            window.location.href = "?drawNumber=" + selectedDraw;
        }
    </script>
</body>
</html>
