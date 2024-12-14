package lotto.DAO;

import java.util.List;

import lotto.DTO.LotteryStore;

public class Test {
	public static void main(String[] args) {
		LotteryStoreDAO dao = new LotteryStoreDAO();
		System.out.println("==== 전체 데이터 조회 테스트 ====");
		List<LotteryStore> stores = dao.getAllLotteryStores();
		if(stores.isEmpty()) {
			System.out.println("조회된 데이터가 없습니다.");
		}else {
			for(LotteryStore s : stores) {
				System.out.println(s);
			}
		}
	}
}
