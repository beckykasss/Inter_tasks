import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.HashSet;
import java.util.ArrayList;
import java.util.Collections;

public class SortInputString {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: java SortInputString <input_string>");
            return;
        }

        String input = args[0];
        String regex = "-?\\b(0|[1-9]\\d*)\\b";

        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        HashSet<Integer> uniqueNumbers = new HashSet<>();

        while (matcher.find()) {
            int number = Integer.parseInt(matcher.group());
            uniqueNumbers.add(number);
        }

        ArrayList<Integer> sortedNumbers = new ArrayList<>(uniqueNumbers);
        Collections.sort(sortedNumbers);

        for (int number : sortedNumbers) {
            System.out.print(number + " ");
        }
    }
}

