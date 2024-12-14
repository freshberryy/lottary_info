package lotto.DAO;

import lotto.DTO.WinningStore;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WinningStoresDAO {
    // 데이터베이스 연결 정보
	private static final String DB_URL = "jdbc:mysql://ls-f8dc441f16b317431a0c626ef5cd85578e5485cc.c9awuy0mqmj5.ap-northeast-2.rds.amazonaws.com:3306/lotto"; // DB URL
    private static final String DB_USER = "dbmasteruser"; // DB 사용자명
    private static final String DB_PASSWORD = "98899889"; // DB 비밀번호

    // DB 연결 가져오기
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // 모든 당첨 판매점 조회
    public List<WinningStore> getAllWinningStores() {
        String sql = "SELECT id, name, region, win_count, latitude, longitude FROM winning_stores";
        List<WinningStore> winningStores = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                WinningStore store = new WinningStore(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("region"),
                        rs.getInt("win_count"),
                        rs.getObject("latitude") != null ? rs.getDouble("latitude") : null,
                        rs.getObject("longitude") != null ? rs.getDouble("longitude") : null
                );
                winningStores.add(store);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }

        return winningStores;
    }

    // 특정 ID의 당첨 판매점 조회
    public WinningStore getWinningStoreById(int id) {
        String sql = "SELECT id, name, region, win_count, latitude, longitude FROM winning_stores WHERE id = ?";
        WinningStore store = null;

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    store = new WinningStore(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("region"),
                            rs.getInt("win_count"),
                            rs.getObject("latitude") != null ? rs.getDouble("latitude") : null,
                            rs.getObject("longitude") != null ? rs.getDouble("longitude") : null
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }

        return store;
    }
}
