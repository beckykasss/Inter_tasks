import java.util.regex.Matcher;
import java.util.regex.Pattern;

class ExcelFileFilter {
    public static void filterExcelFiles() {
        String input = "path/to/files/1.xls, path/to/files/2.XLSX, path/to/files/9.vra, " +
                "path/to/files/3.jpg, path/to/files/4.xml, path/to/files/5.png, " +
                "path/to/files/6.xlsm, path/to/files/7.xlso, path/to/files/8.xls*, " +
                "path/to/files/9.xlasx, path/to/files/9.vba";

        Pattern pattern = Pattern.compile(".*\\.(xls[xm]?|xlsm|vba)", Pattern.CASE_INSENSITIVE);

        String[] paths = input.split(", ");
        StringBuilder result = new StringBuilder();

        for (String path : paths) {
            Matcher matcher = pattern.matcher(path);
            if (matcher.matches()) {
                result.append(path).append(",");
            }
        }

        if (result.length() > 0) {
            result.deleteCharAt(result.length() - 1); // Remove the trailing comma
            System.out.println(result.toString());
        } else {
            System.out.println("No Excel files found");
        }
    }
}

public class Main {
    public static void main(String[] args) {
        ExcelFileFilter.filterExcelFiles();
    }
}

