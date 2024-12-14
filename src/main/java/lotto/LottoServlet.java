package lotto;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LottoServlet")
public class LottoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 로또 번호 생성 (1~45 중 7개 랜덤: 6개 메인, 1개 보너스)
        List<Integer> lottoNumbers = IntStream.rangeClosed(1, 45)
                .boxed()
                .collect(Collectors.toList());
        Collections.shuffle(lottoNumbers);
        
        // 7개 번호 추첨 후 정렬
        List<Integer> drawnNumbers = lottoNumbers.stream().limit(7).sorted().collect(Collectors.toList());
        
        // 앞의 6개는 메인 번호, 마지막 1개는 보너스 번호로 할당
        List<Integer> selectedNumbers = drawnNumbers.subList(0, 6);
        Integer bonusNumber = drawnNumbers.get(6);

        // JSON 문자열 생성
        // 예: {"numbers":[1,2,3,4,5,6],"bonus":7}
        String mainNumbersJson = selectedNumbers.stream()
            .map(String::valueOf)
            .collect(Collectors.joining(",", "[", "]"));
        
        String json = "{\"numbers\":" + mainNumbersJson + ",\"bonus\":" + bonusNumber + "}";

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write(json);
    }
}
