package lotto.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lotto.DTO.LotteryStore;

public class LotteryStoreDAO {

    private static final String DB_URL = "jdbc:mysql://ls-f8dc441f16b317431a0c626ef5cd85578e5485cc.c9awuy0mqmj5.ap-northeast-2.rds.amazonaws.com:3306/lotto"; // DB URL
    private static final String DB_USER = "dbmasteruser"; // DB 사용자명
    private static final String DB_PASSWORD = "98899889"; // DB 비밀번호

    // DB 연결 가져오기
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // 데이터 삽입
    public void insertLotteryStore(LotteryStore store) {
        String sql = "INSERT INTO lottery_stores (id, name, road_address, land_address, latitude, longitude, region, is_winner) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, store.getId());
            pstmt.setString(2, store.getName());
            pstmt.setString(3, store.getRoadAddress());
            pstmt.setString(4, store.getLandAddress());
            pstmt.setObject(5, store.getLatitude()); // NULL 허용
            pstmt.setObject(6, store.getLongitude()); // NULL 허용
            pstmt.setString(7, store.getRegion());
            pstmt.setBoolean(8, store.isWinner());
            pstmt.executeUpdate();
            System.out.println("데이터 삽입 성공: " + store.getName());
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 삽입 실패: " + e.getMessage());
        }
    }

    // 데이터 조회 (전체)
    public List<LotteryStore> getAllLotteryStores() {
        String sql = "SELECT * FROM lottery_stores";
        List<LotteryStore> stores = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                LotteryStore store = new LotteryStore(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("road_address"),
                    rs.getString("land_address"),
                    rs.getDouble("latitude"),
                    rs.getDouble("longitude"),
                    rs.getString("region"),
                    rs.getBoolean("is_winner")
                );
                stores.add(store);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }
        return stores;
    }

    // 데이터 조회 (ID로 검색)
    public LotteryStore getLotteryStoreById(int id) {
        String sql = "SELECT * FROM lottery_stores WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new LotteryStore(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("road_address"),
                        rs.getString("land_address"),
                        rs.getDouble("latitude"),
                        rs.getDouble("longitude"),
                        rs.getString("region"),
                        rs.getBoolean("is_winner")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }
        return null;
    }

    // 데이터 업데이트
    public void updateLotteryStore(LotteryStore store) {
        String sql = "UPDATE lottery_stores SET name = ?, road_address = ?, land_address = ?, latitude = ?, longitude = ?, region = ?, is_winner = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, store.getName());
            pstmt.setString(2, store.getRoadAddress());
            pstmt.setString(3, store.getLandAddress());
            pstmt.setObject(4, store.getLatitude()); // NULL 허용
            pstmt.setObject(5, store.getLongitude()); // NULL 허용
            pstmt.setString(6, store.getRegion());
            pstmt.setBoolean(7, store.isWinner());
            pstmt.setInt(8, store.getId());
            pstmt.executeUpdate();
            System.out.println("데이터 업데이트 성공: " + store.getName());
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 업데이트 실패: " + e.getMessage());
        }
    }

    // 데이터 삭제
    public void deleteLotteryStore(int id) {
        String sql = "DELETE FROM lottery_stores WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            System.out.println("데이터 삭제 성공: ID = " + id);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 삭제 실패: " + e.getMessage());
        }
    }
}
