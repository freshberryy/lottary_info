package lotto.DTO;

public class WinningStore {
	private int id;
    private String name;
    private String region;
    private int winCount;
    
    
	public WinningStore(int id, String name, String region, int winCount) {
		super();
		this.id = id;
		this.name = name;
		this.region = region;
		this.winCount = winCount;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public int getWinCount() {
		return winCount;
	}
	public void setWinCount(int winCount) {
		this.winCount = winCount;
	}
    
    
}
