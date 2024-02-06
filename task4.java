
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;

public class FootballDataScraper {
    public static void main(String[] args) {
        String url = "https://terrikon.com/football/italy/championship/strikers";

        try {

            Document document = Jsoup.connect(url).get();
            Element table = document.select("table").first();
            StringBuilder outputData = new StringBuilder("<table>");

            Elements headers = table.select("th");
            for (Element header : headers) {
                outputData.append("<th>").append(header.text()).append("</th>");
            }

            Elements rows = table.select("tr");
            for (Element row : rows) {
                Elements columns = row.select("td");

                if (!columns.isEmpty()) {
                    for (Element column : columns) {
                        outputData.append("<td>").append(column.text()).append("</td>");
                    }
                }
            }

            outputData.append("</table>");

            System.out.println(outputData.toString());

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
