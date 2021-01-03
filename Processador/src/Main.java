import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;


/**
 * args[0] = metricas.txt
 * args[1] = dataset.csv
 * args[2] = Agregador/Main
 */

public class Main {
	public static void main(String[] args) throws IOException{
		Stream<String> lines = java.nio.file.Files.lines(Paths.get(args[0]));
		lines.forEach(System.out::println);
		lines.close();
	}
	
}
