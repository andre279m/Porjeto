import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * args[0] = metricas.txt
 * args[1] = dataset.csv
 * args[2] = Agregador/Main
 */

public class Main {
	public static void main(String[] args) throws IOException{
		Stream<String> metrics = java.nio.file.Files.lines(Paths.get(args[0]));
		Stream<String> data = java.nio.file.Files.lines(Paths.get(args[1]));
		ProcessWrapper processor1 = new ProcessWrapper(args[2]);
		Map<Long,String> outputTable = new HashMap<>();	
		metrics.forEach (metric -> {
			processor1.writeLine(metric);
			AtomicLong counter = new AtomicLong(0);
			data.forEach (line -> {
				processor1.writeLine(line.replace(",", " "));
				String outputPorMetrica = processor1.readLine();
				if (!outputTable.containsKey(counter.get()))
  					outputTable.put(counter.get(),outputPorMetrica);
				else
  					outputTable.replace(counter.get(), outputTable.get(counter.get())+ "," + outputPorMetrica);
				counter.getAndIncrement();
			});
		});
		for(String lines : outputTable.values()){
			System.out.println(lines);
		}
		data.close();
		metrics.close();

		
	}
	
}
